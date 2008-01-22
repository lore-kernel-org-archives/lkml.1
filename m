Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbYAVP4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbYAVP4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 10:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbYAVP4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 10:56:07 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:37870 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752479AbYAVP4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 10:56:06 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Rescheduling interrupts
Date: Tue, 22 Jan 2008 17:55:55 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080118.763038)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <200801220119.42312.caglar@pardus.org.tr> <200801221455.16814.caglar@pardus.org.tr> <20080122152333.GB19590@elte.hu>
In-Reply-To: <20080122152333.GB19590@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801221755.56470.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

22 Oca 2008 Sal tarihinde, Ingo Molnar şunları yazmıştı: 
> * S.Çağlar Onur <caglar@pardus.org.tr> wrote:
> > I grabbed the logs two times to make sure to catch needed info. 1st [1]
> > one is generated while "Rescheduling interrupts" wakeups ~200 times and
> > 2nd one generated for ~350 wakeups.
> >
> > [1] http://cekirdek.pardus.org.tr/~caglar/dmesg.1st
> > [2] http://cekirdek.pardus.org.tr/~caglar/dmesg.2nd
>
> thanks, these seem to be mostly normal wakeups from standard tasks:
>
>  IPI from task kdm_greet:2118 on CPU#0:
>  IPI from task X:2079 on CPU#1:
>  IPI from task kdm_greet:2118 on CPU#0:
>  IPI from task hald-addon-inpu:2009 on CPU#1:
>  IPI from task events/0:7 on CPU#1:
>  IPI from task bash:2129 on CPU#0:
>  IPI from task kdm_greet:2118 on CPU#0:
>  IPI from task events/0:7 on CPU#1:
>  IPI from task events/0:7 on CPU#1:
>  IPI from task events/0:7 on CPU#1:
>  IPI from task bash:3902 on CPU#1:
>  IPI from task bash:3902 on CPU#1:
>  IPI from task amarokapp:3423 on CPU#1:
>  IPI from task amarokapp:3423 on CPU#1:
>  IPI from task amarokapp:3423 on CPU#1:
>  IPI from task X:2079 on CPU#0:
>  IPI from task yakuake:3422 on CPU#0:
>  IPI from task X:2079 on CPU#1:
>  IPI from task amarokapp:3423 on CPU#1:
>  IPI from task amarokapp:3423 on CPU#1:
>
> could you also add a similar IPI printouts (with the same panic_timeout
> logic) to arch/x86/kernel/smp_32.c's smp_reschedule_interrupt() function
> - while still keeping the other printouts too?
>
> Could you also enable PRINTK_TIME timestamps, so that we can see the
> timings? (And do a "dmesg -n 1" so that the printks happen fast and the
> timings are accurate.) I'd suggest to increase CONFIG_LOG_BUF_SHIFT to
> 20, so that your dmesg buffer is large enough. Plus try to capture 100
> events, ok?
>
> My theory is that for whatever reason we get "repeat" IPIs: multiple
> reschedule IPIs although the other CPU only initiated one.

Ok, please see http://cekirdek.pardus.org.tr/~caglar/dmesg.3rd :)

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
