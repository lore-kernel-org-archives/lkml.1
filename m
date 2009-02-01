Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbZBAREi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbZBAREi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 12:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZBAREa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 12:04:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:48325 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbZBARE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 12:04:29 -0500
Date: Sun, 1 Feb 2009 09:04:29 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
Message-ID: <20090201090429.0c7e1362@infradead.org>
In-Reply-To: <4985CC57.7090800@s5r6.in-berlin.de>
References: <20090127001708.GA4815@nowhere>
	<20090126163015.7f879b18@infradead.org>
	<20090131180347.GC5884@nowhere>
	<20090131101502.7ce8e7af@infradead.org>
	<20090131182843.GD5884@nowhere>
	<4985CC57.7090800@s5r6.in-berlin.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Feb 2009 17:22:47 +0100
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> > I don't know, most of those I've looked on are not documented about
> > the reason for a private workqueue. I guess most of them can use
> > the usual kevent.
> 
> I have stuff in drivers/firewire/ done in a private workqueue and some
> in the shared workqueue which I will eventually move either into
> short-lived ad hoc created kthreads /or/ preferably into a thread pool
> implementation --- if such a thing will have found its way into the
> kernel when I have time for my project.
> 
> I need to get callers of scsi_add_device and scsi_remove_device out of
> the picture.

what are the requirements for you to do this?

right now, the async calls are "fire and forget... but you can wait for
completion". The "price" is that the code needs to allocate a little
bit of memory for management overhead. The second price then is that 
if this allocation fails, the code needs to run "in context".

Would this be a problem?

I can add a variant of the API where you pass in some memory of your
own, which then does not fail. (but also won't get freed automatically
etc)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
