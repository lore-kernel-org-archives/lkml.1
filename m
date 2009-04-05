Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbZDESzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbZDESzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 14:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbZDESzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 14:55:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:38588 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbZDESzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 14:55:08 -0400
Date: Sun, 5 Apr 2009 11:56:29 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
Message-ID: <20090405115629.521057fc@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0904050927580.4023@localhost.localdomain>
References: <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain>
	<alpine.LFD.2.00.0904031329410.7007@localhost.localdomain>
	<20090404135719.GA9812@mit.edu>
	<20090404151649.GE5178@kernel.dk>
	<alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>
	<20090404173412.GF5178@kernel.dk>
	<alpine.LFD.2.00.0904041039230.3915@localhost.localdomain>
	<20090404180108.GH5178@kernel.dk>
	<20090404232222.GA7480@mit.edu>
	<20090404163349.20df1208@infradead.org>
	<20090405001005.GA7553@mit.edu>
	<alpine.LFD.2.00.0904050927580.4023@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Apr 2009 10:01:06 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> Also, one of the issues seems to literally be that the higher-level 
> request handling doesn't care AT ALL about the priority. Allocating
> the request itself does keep reads and writes separated, but if the
> request is a SYNCIO request, and non-sync writes have filled up th
> write requests, we'll have to wait for the background writes to free
> up requests.
> 
> That is quite possibly the longest wait we have in the system.

it often is; latencytop tends to point that out.
> 
> See get_request():

our default number of requests is so low that we very regularly hit the
limit. In addition to setting kjournald to higher priority, I tend to
set the number of requests to 4096 or so to improve interactive
performance on my own systems. That way at least the elevator has a
chance to see the requests ;-)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
