Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbZDWP3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbZDWP3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZDWP3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:29:05 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:59751 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbZDWP3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:29:03 -0400
Date: Fri, 24 Apr 2009 00:29:00 +0900 (JST)
Message-Id: <20090424.002900.11623503.anemo@mba.ocn.ne.jp>
To: alessandro.zummo@towertech.it
Cc: akpm@linux-foundation.org, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, hcegtvedt@atmel.com, vapier@gentoo.org,
       rongkai.zhan@windriver.com, balajirrao@openmoko.org,
       david-b@pacbell.net, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] rtc: Make rtc_update_irq callable with irqs enabled
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20090423170253.6b6dfd21@i1501.lan.towertech.it>
	<8bd0f97a0904230807q6c40436wa561d7b26db26cef@mail.gmail.com>
	<200904091627.15776.david-b@pacbell.net>
References: <20090410005820.4fcfcc1f@i1501.lan.towertech.it>
	<20090423.235141.61509229.anemo@mba.ocn.ne.jp>
	<20090423170253.6b6dfd21@i1501.lan.towertech.it>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009 17:02:53 +0200, Alessandro Zummo <alessandro.zummo@towertech.it> wrote:
>  As I said in my last email to Andrew, I think we can call
>  rtc_update_irq with irqs enabled and we don't probably need
>  any IRQF_ to request_irq . 
>  
>  Are you willing to make some tests in that direction with your
>  drivers?

Yes, if we had consensus of the API change.  But since all my drivers
have IRQF_DISABLED and I don't want to drop them, I'm not a good
tester for this ;)

On Thu, 23 Apr 2009 11:07:38 -0400, Mike Frysinger <vapier.adi@gmail.com> wrote:
> we just removed the shared bit from the Blackfin rtc driver because it
> didnt really make sense for us.  i need to test something else, so is
> the only change you need is the one posted originally ?  that makes
> more sense to me than forcing everyone to use IRQF_DISABLED.

My original patch should not be merged as is, as David said in other
mail:

On Thu, 9 Apr 2009 16:27:15 -0700, David Brownell <david-b@pacbell.net> wrote:
> Any driver doing that right now is by definition buggy; that
> function is clearly defined to need IRQs blocked:
> 
> /**
>  * rtc_update_irq - report RTC periodic, alarm, and/or update irqs
>  * @rtc: the rtc device
>  * @num: how many irqs are being reported (usually one)
>  * @events: mask of RTC_IRQF with one or more of RTC_PF, RTC_AF, RTC_UF
>  * Context: in_interrupt(), irqs blocked
>  */
> 
> If you're going to change the interface, do it right...
> update that kerneldoc and drivers like rtc-ds130[57],
> rtc-ds1374, and rtc-test which do extra work to follow
> the current interface spec.

I agree on this.

---
Atsushi Nemoto
