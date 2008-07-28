Return-Path: <linux-kernel-owner+w=401wt.eu-S1759684AbYG1Ury@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759684AbYG1Ury (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYG1Urq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:47:46 -0400
Received: from mx0.towertech.it ([213.215.222.73]:33589 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751739AbYG1Urq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:47:46 -0400
Date: Mon, 28 Jul 2008 22:47:40 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: =?iso-8859-2?Q?Tom=E1=B9_Janou=B9ek?= <tomi@nomi.cz>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] rtc-dev: stop periodic interrupts on device release
Message-ID: <20080728224740.5a7a1b3e@i1501.lan.towertech.it>
In-Reply-To: <20080728204136.GA6683@nomi.cz>
References: <20080726154617.GA5613@notes.lisk.in>
	<200807261350.55524.david-b@pacbell.net>
	<20080728204136.GA6683@nomi.cz>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 22:41:36 +0200
Tomáš Janoušek <tomi@nomi.cz> wrote:

> 
> From: Tomas Janousek <tomi@nomi.cz>
> Date: Sat, 26 Jul 2008 16:23:36 +0100
> Subject: [PATCH] rtc-dev: stop periodic interrupts on device release
> 
> Solves http://bugzilla.kernel.org/show_bug.cgi?id=11127
> 
> The old rtc.c driver did it and some drivers (like rtc-sh) do it in their
> release function, though they should not -- because they should provide the
> irq_set_state op and the rtc framework itself should care about it. This patch
> makes it do so.
> 
> I am aware that some drivers, like rtc-sh, handle userspace PIE sets in their
> ioctl op (instead of having the framework call the op), exporting the
> irq_set_state op at the same time. The logic in rtc_irq_set_state should make
> sure it doesn't matter and the driver should not need to care stopping periodic
> interrupts in its release routine any more.
> 
> The correct way, in my opinion, should be this:
> 1) The driver provides the irq_set_state op and does not care closing the
>    interrupts in its release op.
> 2) If the driver does not provide the op and handles PIE in the ioctl op, it's
>    reponsible for closing them in its release op.
> 3) Something similar for other IRQs, like UIE -- if there's no in-kernel API
>    like irq_set_state, handle it in ioctl and release ops. The framework will
>    be responsible either for everything or for nothing.
> 
> Signed-off-by: Tomas Janousek <tomi@nomi.cz>
> Acked-by: David Brownell <dbrownell@users.sourceforge.net>

 ok, that's fair.

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

