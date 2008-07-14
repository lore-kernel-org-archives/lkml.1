Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbYGNHde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbYGNHde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 03:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbYGNHd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 03:33:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52003 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbYGNHd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 03:33:26 -0400
Date: Mon, 14 Jul 2008 09:34:14 +0200
From: Pavel Machek <pavel@suse.cz>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Rus <harbour@sfinx.od.ua>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [mmotm] pm: fix build error
Message-ID: <20080714073414.GB1796@elf.ucw.cz>
References: <20080714162102.F6D1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080714162102.F6D1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> My IA64 machine can't build on today's mmotm(Jul 13).
> So, below patch is necessary, I think.
> 
> ----------------------------------------------------
> Against: mmotm, Jul 13
> Applies after: pm-schedule-sysrq-poweroff-on-boot-cpu.patch
> 
> Now, handle_poweroff() use cpu_online_map variable.
> So cpumask.h sould be included.
> Otherwise it cause following build error on ia64 (I guess also sevaral othor platfom).
> 
> 	kernel/power/poweroff.c: In function 'handle_poweroff':
> 	kernel/power/poweroff.c:29: error: implicit declaration of function 'first_cpu'
> 	kernel/power/poweroff.c:29: error: 'cpu_online_map' undeclared (first use in this function)
> 	kernel/power/poweroff.c:29: error: (Each undeclared identifier is reported only once
> 	kernel/power/poweroff.c:29: error: for each function it appears in.)
> 	make[2]: *** [kernel/power/poweroff.o] Error 1
> 	make[1]: *** [kernel/power] Error 2
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Zhang Rui <rui.zhang@intel.com>
> CC: Rus <harbour@sfinx.od.ua>
> CC: Rafael J. Wysocki <rjw@sisk.pl>
> CC: Pavel Machek <pavel@ucw.cz>

ACK.

> ---
>  kernel/power/poweroff.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: b/kernel/power/poweroff.c
> ===================================================================
> --- a/kernel/power/poweroff.c
> +++ b/kernel/power/poweroff.c
> @@ -10,6 +10,7 @@
>  #include <linux/pm.h>
>  #include <linux/workqueue.h>
>  #include <linux/reboot.h>
> +#include <linux/cpumask.h>
>  
>  /*
>   * When the user hits Sys-Rq o to power down the machine this is the
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
