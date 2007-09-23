Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbXIWBw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbXIWBw5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 21:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbXIWBws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 21:52:48 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:42504 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbXIWBwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 21:52:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cVND+5oOT4/j2GRBTfQhbUIAE1mC5Cd+MeOwqZjRYqSwKDjbLnwaedmM4DRP+81v9SR0vYyHIG9hN/5qcaworhHpEpVwNPQPFFvZC9wvJFljW3gbAhgAM6OhfBG4SYH08YsX6NdNuv0OEApCE+74WSqFbjbBLaHnaMwd0PLshr8=
Message-ID: <961aa3350709221852s3c55fc84i101a6f02ff9fbd1@mail.gmail.com>
Date: Sun, 23 Sep 2007 10:52:45 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH] [35/50] i386: Do cpuid_device_create() in CPU_UP_PREPARE instead of CPU_ONLINE.
Cc: "Andi Kleen" <ak@suse.de>, hpa@zytor.com, ego@in.ibm.com, oleg@tv-sign.ru,
       patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <1190489605.4035.104.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709221231.836138000@suse.de>
	 <20070921223235.18A2A13DCD@wotan.suse.de>
	 <1190489605.4035.104.camel@chaos>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/9/23, Thomas Gleixner <tglx@linutronix.de>:
> On Sat, 2007-09-22 at 00:32 +0200, Andi Kleen wrote:
> > From: Akinobu Mita <akinobu.mita@gmail.com>
> >
> > Do cpuid_device_create() in CPU_UP_PREPARE instead of CPU_ONLINE.
> >
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > Signed-off-by: Andi Kleen <ak@suse.de>
> > Cc: Gautham R Shenoy <ego@in.ibm.com>
> > Cc: Oleg Nesterov <oleg@tv-sign.ru>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >
> >  arch/i386/kernel/cpuid.c |   32 +++++++++++++++++++-------------
> >  1 file changed, 19 insertions(+), 13 deletions(-)
> >
> > Index: linux/arch/i386/kernel/cpuid.c
> > ===================================================================
> > --- linux.orig/arch/i386/kernel/cpuid.c
> > +++ linux/arch/i386/kernel/cpuid.c
> > @@ -136,15 +136,18 @@ static const struct file_operations cpui
> >       .open = cpuid_open,
> >  };
> >
> > -static int __cpuinit cpuid_device_create(int i)
> > +static int cpuid_device_create(int cpu)
>
>         __cpuinit please
>

Yes. This eliminates earlier patch in this series.
([22/50] i386: Misc cpuinit annotation)
