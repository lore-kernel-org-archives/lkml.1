Return-Path: <linux-kernel-owner+w=401wt.eu-S1756446AbXIWHwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbXIWHwl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 03:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbXIWHwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 03:52:35 -0400
Received: from www.osadl.org ([213.239.205.134]:33915 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751309AbXIWHwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 03:52:34 -0400
Subject: Re: [PATCH] [35/50] i386: Do cpuid_device_create() in
	CPU_UP_PREPARE instead of CPU_ONLINE.
From: Thomas Gleixner <tglx@linutronix.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andi Kleen <ak@suse.de>, hpa@zytor.com, ego@in.ibm.com, oleg@tv-sign.ru,
       patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <961aa3350709221852s3c55fc84i101a6f02ff9fbd1@mail.gmail.com>
References: <200709221231.836138000@suse.de>
	 <20070921223235.18A2A13DCD@wotan.suse.de> <1190489605.4035.104.camel@chaos>
	 <961aa3350709221852s3c55fc84i101a6f02ff9fbd1@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 23 Sep 2007 09:52:32 +0200
Message-Id: <1190533952.4035.142.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-23 at 10:52 +0900, Akinobu Mita wrote:
> > >  arch/i386/kernel/cpuid.c |   32 +++++++++++++++++++-------------
> > >  1 file changed, 19 insertions(+), 13 deletions(-)
> > >
> > > Index: linux/arch/i386/kernel/cpuid.c
> > > ===================================================================
> > > --- linux.orig/arch/i386/kernel/cpuid.c
> > > +++ linux/arch/i386/kernel/cpuid.c
> > > @@ -136,15 +136,18 @@ static const struct file_operations cpui
> > >       .open = cpuid_open,
> > >  };
> > >
> > > -static int __cpuinit cpuid_device_create(int i)
> > > +static int cpuid_device_create(int cpu)
> >
> >         __cpuinit please
> >
> 
> Yes. This eliminates earlier patch in this series.
> ([22/50] i386: Misc cpuinit annotation)

No, it's even worse:

#22 is applied before #35. 
#35 is reverting the __cpuinit anotation of #22 with its modificiations
of cpuid_device_create()

	tglx


