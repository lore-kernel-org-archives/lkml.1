Return-Path: <linux-kernel-owner+w=401wt.eu-S1763006AbXE1SGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763006AbXE1SGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 14:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759632AbXE1SF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 14:05:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60726 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759200AbXE1SF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 14:05:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH][EXPERIMENTAL] Make kernel threads nonfreezable by default
Date: Mon, 28 May 2007 20:11:10 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>
References: <200705270012.59177.rjw@sisk.pl> <20070528103302.GD18807@elf.ucw.cz>
In-Reply-To: <20070528103302.GD18807@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705282011.11526.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 May 2007 12:33, Pavel Machek wrote:
> Hi!
> 
> > Index: linux-2.6.22-rc3/Documentation/power/kernel_threads.txt
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/Documentation/power/kernel_threads.txt
> > +++ linux-2.6.22-rc3/Documentation/power/kernel_threads.txt
> > @@ -1,13 +1,22 @@
> > -KERNEL THREADS
> > +The Freezer and Kernel Threads
> >  
> > -
> > -Freezer
> > -
> > -Upon entering a suspended state the system will freeze all
> > -tasks. This is done by delivering pseudosignals. This affects
> > -kernel threads, too. To successfully freeze a kernel thread
> > -the thread has to check for the pseudosignal and enter the
> > -refrigerator. Code to do this looks like this:
> > +Before entering a system-wide suspend state as well as before creating a
> > +hibernation snapshot image the system will freeze all tasks, which is done
> > +by delivering fake signals.  This affects kernel threads too, but they won't be
> > +frozen unless they declare that they want to.  For this purpose
> 
> Well... and unless thread that does disk writes or DMA _wants_ to, you
> have nice disk corruption... It should be pointed out that it is not
> voluntary for those types of threads.

Well, that really depends.

I think the only thing that must not be written to disk is filesystem stuff.
The other things (eg. writing directly to block devices etc.) doesn't hurt us.

Also, I think that DMA-ing while we're creating the image should be impossible
due to devices being frozen at that point.

That said, I think we need to write some better freezer documentation ASAP.

Greetings,
Rafael
