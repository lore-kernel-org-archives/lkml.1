Return-Path: <linux-kernel-owner+w=401wt.eu-S1753628AbZKNBjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbZKNBjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 20:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbZKNBjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 20:39:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbZKNBjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 20:39:07 -0500
Date: Fri, 13 Nov 2009 20:38:56 -0500
From: Dave Jones <davej@redhat.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/debug] x86: Minimise printk spew from per-vendor init
 code
Message-ID: <20091114013856.GB21609@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Yinghai Lu <yhlu.kernel@gmail.com>, mingo@redhat.com, hpa@zytor.com,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
	linux-tip-commits@vger.kernel.org
References: <20091113203000.GA19160@redhat.com>
 <tip-0388423dba2217b4e5b6c61690b0506d13b25a49@git.kernel.org>
 <86802c440911131703y35520496pfbdaa4e0bd8f8609@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86802c440911131703y35520496pfbdaa4e0bd8f8609@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 05:03:44PM -0800, Yinghai Lu wrote:

 > > --- a/arch/x86/kernel/cpu/common.c
 > > +++ b/arch/x86/kernel/cpu/common.c
 > > @@ -656,6 +656,7 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 > >
 > >  void __init early_cpu_init(void)
 > >  {
 > > +#ifdef PROCESSOR_SELECT
 > >        const struct cpu_dev *const *cdev;
 > >        int count = 0;
 > >
 > > @@ -676,7 +677,7 @@ void __init early_cpu_init(void)
 > >                                cpudev->c_ident[j]);
 > >                }
 > >        }
 > > -
 > > +#endif
 > >        early_identify_cpu(&boot_cpu_data);
 > >  }
 > 
 > NACK.
 > 
 > the function is initializing cpu_devs array.
 
Ugh, I don't know how I missed that.  I also seem to have boot tested the wrong kernel.
Back to the drawing board.

	Dave



