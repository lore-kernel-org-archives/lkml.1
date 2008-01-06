Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbYAFUiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbYAFUiL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 15:38:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYAFUh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 15:37:58 -0500
Received: from smtprelay10.ispgateway.de ([80.67.29.24]:36599 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbYAFUh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 15:37:57 -0500
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Bernd Schubert <bernd-schubert@gmx.de>
Subject: Re: sleep before boot panic
Date: Sun, 6 Jan 2008 21:38:39 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <200801061908.43010.bernd-schubert@gmx.de> <200801062001.15220.ioe-lkml@rameria.de> <200801062023.58089.bernd-schubert@gmx.de>
In-Reply-To: <200801062023.58089.bernd-schubert@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801062138.40192.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bernd,

CC'ed hpa, since I'm sure he can give useful advise on that :-)

On Sunday 06 January 2008, Bernd Schubert wrote:
> On Sunday 06 January 2008, Ingo Oeser wrote:
> > Hi Bernd,
> >
> > On Sunday 06 January 2008, you wrote:
> > > Index: zd1211rw.git.beno/init/do_mounts.c
> > > ===================================================================
> > > --- zd1211rw.git.beno.orig/init/do_mounts.c	2008-01-06 18:44:23.000000000
> > > +0100
> > > +++ zd1211rw.git.beno/init/do_mounts.c	2008-01-06 18:45:44.000000000
> > > +0100 @@ -330,6 +330,7 @@
> > >  		printk("Please append a correct \"root=\" boot option; here are the
> > > available partitions:\n");
> > >
> > >  		printk_all_partitions();
> > > +		msleep(60 * 1000);
> >
> > ssleep(60);
> 
> feel free to replace it replace it :)

Not that urgent, but if you resubmit please do it :-)

> There is no dump_stack() here, but disc detection is relatively early in boot 
> process and on all these information are already scrolled off screen when the 
> panic is done. For this and any other panic it would be optimal if scrolling 
> still would work, but scrolling also requires kernel code, so I see there's a 
> reason not to this for all panics. However, for this boot problem I tend to 
> say there's no need to panic at all...

But the kernel cannot continue from that position. You would need a "soft" panic,
which allows behavior of panic=X, but let the kernel continue.

Even better is to continue with the init in the builtin ramfs. That should always
be available and can implement any behavior desired (like droping into a dash).

> Btw, not all stack straces are useless, *most* of them are actually very 
> useful.

I didn't say that. Just if you cannot continue due to admin error, 
but the kernel is in a perfect valid state otherwise,
dumping stack is next to useless.


Best Regards

Ingo Oeser
