Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbYAFTYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbYAFTYQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 14:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYAFTYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 14:24:04 -0500
Received: from mail.gmx.net ([213.165.64.20]:39990 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752675AbYAFTYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 14:24:03 -0500
X-Authenticated: #19095397
X-Provags-ID: V01U2FsdGVkX19Y3Kwe7yxY+EGWgbuDdY+E62+TsKUivYbCq+AMDK
	ctvEpmxDHyyKEc
From: Bernd Schubert <bernd-schubert@gmx.de>
To: Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: sleep before boot panic
Date: Sun, 6 Jan 2008 20:23:57 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200801061908.43010.bernd-schubert@gmx.de> <200801062001.15220.ioe-lkml@rameria.de>
In-Reply-To: <200801062001.15220.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801062023.58089.bernd-schubert@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Sunday 06 January 2008, Ingo Oeser wrote:
> Hi Bernd,
>
> On Sunday 06 January 2008, you wrote:
> > Index: zd1211rw.git.beno/init/do_mounts.c
> > ===================================================================
> > --- zd1211rw.git.beno.orig/init/do_mounts.c	2008-01-06 18:44:23.000000000
> > +0100
> > +++ zd1211rw.git.beno/init/do_mounts.c	2008-01-06 18:45:44.000000000
> > +0100 @@ -330,6 +330,7 @@
> >  		printk("Please append a correct \"root=\" boot option; here are the
> > available partitions:\n");
> >
> >  		printk_all_partitions();
> > +		msleep(60 * 1000);
>
> ssleep(60);

feel free to replace it replace it :)

>
> >  		panic("VFS: Unable to mount root fs on %s", b);
> >  	}
>
> Better would be for this and similiar panic()s
> (fatal user/admin errors on boot) to NOT print a stack trace+registers,
> since it is useless and actually hides useful information.

There is no dump_stack() here, but disc detection is relatively early in boot 
process and on all these information are already scrolled off screen when the 
panic is done. For this and any other panic it would be optimal if scrolling 
still would work, but scrolling also requires kernel code, so I see there's a 
reason not to this for all panics. However, for this boot problem I tend to 
say there's no need to panic at all...

Btw, not all stack straces are useless, *most* of them are actually very 
useful.

Cheers,
Bernd

