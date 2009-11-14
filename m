Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbZKNCsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbZKNCsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 21:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbZKNCsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 21:48:54 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:65399 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbZKNCsx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 21:48:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=FWLn5CcktNRhoG9F3wcOJgl3EPe4R0tyXDPdbjoy4FChMDd9qSM+N7wG7zTSMmZPv9
         NojHFbKXmm0pSLMRWwp3nxY0LryuchxHhTmQ9MJzDH8FE79fyDtE4qwLSlQaEE6dREG2
         0xYwSnHluqGVDufFTht4m8Ifr1VresJpPVXYs=
MIME-Version: 1.0
In-Reply-To: <20091114013856.GB21609@redhat.com>
References: <20091113203000.GA19160@redhat.com>
	 <tip-0388423dba2217b4e5b6c61690b0506d13b25a49@git.kernel.org>
	 <86802c440911131703y35520496pfbdaa4e0bd8f8609@mail.gmail.com>
	 <20091114013856.GB21609@redhat.com>
Date: Fri, 13 Nov 2009 18:48:58 -0800
Message-ID: <86802c440911131848o2cccb056x32a819634c6855d9@mail.gmail.com>
Subject: Re: [tip:x86/debug] x86: Minimise printk spew from per-vendor init 
	code
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Dave Jones <davej@redhat.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 5:38 PM, Dave Jones <davej@redhat.com> wrote:
> On Fri, Nov 13, 2009 at 05:03:44PM -0800, Yinghai Lu wrote:
>
>  > > --- a/arch/x86/kernel/cpu/common.c
>  > > +++ b/arch/x86/kernel/cpu/common.c
>  > > @@ -656,6 +656,7 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
>  > >
>  > >  void __init early_cpu_init(void)
>  > >  {
>  > > +#ifdef PROCESSOR_SELECT
>  > >        const struct cpu_dev *const *cdev;
>  > >        int count = 0;
>  > >
>  > > @@ -676,7 +677,7 @@ void __init early_cpu_init(void)
>  > >                                cpudev->c_ident[j]);
>  > >                }
>  > >        }
>  > > -
>  > > +#endif
>  > >        early_identify_cpu(&boot_cpu_data);
>  > >  }
>  >
>  > NACK.
>  >
>  > the function is initializing cpu_devs array.
>
> Ugh, I don't know how I missed that.  I also seem to have boot tested the wrong kernel.
> Back to the drawing board.
>
use two loop instead?

YH
