Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbZISJTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbZISJTI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 05:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756463AbZISJTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 05:19:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:51214 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbZISJTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 05:19:05 -0400
Date: Sat, 19 Sep 2009 11:19:12 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Jim Meyering <jim@meyering.net>
Cc: Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: efficient access to "rotational";  new fcntl?
Message-ID: <20090919111912.34a35f95@infradead.org>
In-Reply-To: <87k4zvpak6.fsf@meyering.net>
References: <87vdjgqcbd.fsf@meyering.net>
	<20090918221658.GB28781@mit.edu>
	<87pr9npdlc.fsf@meyering.net>
	<20090919103149.54258081@infradead.org>
	<87k4zvpak6.fsf@meyering.net>
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

On Sat, 19 Sep 2009 11:07:21 +0200
Jim Meyering <jim@meyering.net> wrote:

> > btw have you given thought about using threads as part of rm -r[f] ?
> > (would make the unlinks of unrelated directories/files asynchronous)
> 
> While it is certainly a nicely parallelizable process,
> rm usually runs so quickly that I doubt it'd be worthwhile.
> If you know in advance that parallelizing a particular recursive
> removal would give a significant benefit, it's probably best to do it
> via e.g., xargs --max-procs=N.

deleting large files has several seeks kind of cost (small files is
cheap). At least on ext3. I guess with btrfs being the future it's
indeed not worth doing in userspace.

 
> However, sort *would* benefit, and some UCLA students implemented that
> for a term project.  Unfortunately, the project is stalled because the
> implementation was not efficient enough, and no one has found the
> time to improve it since.

parallel sort... call me skeptical. My gut feeling is that you'll get
killed by communication overhead.
(sort seems to be more communication than raw cpu use)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
