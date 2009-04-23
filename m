Return-Path: <linux-kernel-owner+w=401wt.eu-S1758496AbZDWMjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496AbZDWMjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758346AbZDWMjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:39:19 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:60650 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758318AbZDWMjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:39:17 -0400
Message-ID: <49F06155.9060607@petalogix.com>
Date: Thu, 23 Apr 2009 14:38:45 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: coly.li@suse.de
CC: LKML <linux-kernel@vger.kernel.org>, Michal Simek <monstr@monstr.eu>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/7] microblaze: add parameter to microblaze_read()
References: <49EF6A7B.8070202@suse.de>
In-Reply-To: <49EF6A7B.8070202@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coly Li wrote:
> This patch modifies parameter of microblaze_read() from 'void' to 'struct
> clocksource *cs', which fixes compile warning for incompatible parameter type.
>
> Signed-off-by: Coly Li <coly.li@suse.de>
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/microblaze/kernel/timer.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
> index 05a497e..bdfa2f9 100644
> --- a/arch/microblaze/kernel/timer.c
> +++ b/arch/microblaze/kernel/timer.c
> @@ -176,7 +176,7 @@ static __init void microblaze_clockevent_init(void)
>  	clockevents_register_device(&clockevent_microblaze_timer);
>  }
>
> -static cycle_t microblaze_read(void)
> +static cycle_t microblaze_read(struct clocksource *cs)
>  {
>  	/* reading actual value of timer 1 */
>  	return (cycle_t) (in_be32(TIMER_BASE + TCR1));
>
>   
Add to fixes-for-linus branch.

Michal

-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

