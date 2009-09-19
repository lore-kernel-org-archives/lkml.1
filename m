Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbZISIbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbZISIbr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 04:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbZISIbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 04:31:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:55384 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbZISIbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 04:31:44 -0400
Date: Sat, 19 Sep 2009 10:31:49 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Jim Meyering <jim@meyering.net>
Cc: Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: efficient access to "rotational";  new fcntl?
Message-ID: <20090919103149.54258081@infradead.org>
In-Reply-To: <87pr9npdlc.fsf@meyering.net>
References: <87vdjgqcbd.fsf@meyering.net>
	<20090918221658.GB28781@mit.edu>
	<87pr9npdlc.fsf@meyering.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Sep 2009 10:01:51 +0200
Jim Meyering <jim@meyering.net> wrote:
> Yeah, I mentioned I should do exactly that on IRC yesterday.
> I've just run some tests, and see that at least with one SSD (OCZ
> Summit 120GB), the 0.5s cost of sorting pays off handsomely with a
> 12-x speed-up, saving 5.5 minutes, when removing a
> 1-million-empty-file directory.
> 

likely because you actually reduce the amount of IO; inodes share
disk blocks; repeated unlinks in random order likely write the same
block multiple times....


btw have you given thought about using threads as part of rm -r[f] ?
(would make the unlinks of unrelated directories/files asynchronous)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
