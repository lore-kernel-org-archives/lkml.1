Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbZDXLLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbZDXLLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 07:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZDXLKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 07:10:55 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:31450 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751855AbZDXLKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 07:10:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oJJZaxu7Cd9wjnF5hkrJMxr6UaqUmkzZXeKuPPoGnmKo6B0sv+hToquyV+UB2RGpqiYQKvVfxtLiTy8ILHX8Zn5VHpv/ISsGP9NM1ORLUCSgD7dMlnKEhMi0Kl7I/perb77mFumuyNvGh5Y4F7d4OrtXkLRj2+ztkSPyKYUva0I=  ;
X-YMail-OSG: jHB2_EcVM1lStTvAF.1VZsm5f4zlHTqrPbGaA.8CzwXXtrU6WoE5KZkVAn3eutowgkilol1JKUZpCU4z5kpNtcysHNDK463VXxJbptHQFDgWBnhvFT0cvJIo.FXZrDvrqDO1INGWkV2as8aR_fev2Hqh3Olo35TqMYJcUHMmDWlg3O0tw._BuASB00vMIadZaW2NX3kC5yWFLlPhTZTi.nBMdabtMdkyICyN5w9bf2z_nGQ5hIeomjipIuZiQcnWZffj5SO2WaV9ae47
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [rtc-linux] Re: [PATCH] rtc: Make rtc_update_irq callable with irqs enabled
Date: Fri, 24 Apr 2009 04:10:51 -0700
User-Agent: KMail/1.9.10
Cc: rtc-linux@googlegroups.com, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hcegtvedt@atmel.com, vapier@gentoo.org, rongkai.zhan@windriver.com,
       balajirrao@openmoko.org, broonie@opensource.wolfsonmicro.com
References: <20090410005820.4fcfcc1f@i1501.lan.towertech.it> <200904240231.12906.david-b@pacbell.net> <20090424120100.76797d20@i1501.lan.towertech.it>
In-Reply-To: <20090424120100.76797d20@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904240410.52543.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 April 2009, Alessandro Zummo wrote:
>  I'm not tying to fix call issues or lockdep politics,
>  just to understand if it's possible to avoid disabling the IRQs.
> 
>  i.e.,
> 
>  use spin_lock() in the IRQ handler and spin_lock_irq/irq_save
>  in the setup functions.

I think you're describing how the *current* scheme is supposed
to work ... except that some IRQ handlers aren't calling the
rtc_update_irq() routine with IRQs blocked.

Yes, that current scheme works ... modulo those buggy handlers.


