Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbZLXLJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbZLXLJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 06:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZLXLJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 06:09:24 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45532 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbZLXLJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 06:09:23 -0500
Date: Thu, 24 Dec 2009 12:09:21 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC][PATCH 2/14] Convert arm to read/update_persistent_clock
Message-ID: <20091224110921.GA14511@pengutronix.de>
References: <1261540762.3508.61.camel@localhost.localdomain> <1261540826.3508.62.camel@localhost.localdomain> <1261540902.3508.63.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1261540902.3508.63.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Dec 22, 2009 at 08:01:42PM -0800, john stultz wrote:
> This patch converts the arm architecture to use the generic
> read_persistent_clock and update_persistent_clock interfaces, reducing
> the amount of arch specific code we have to maintain, and allowing for
> further cleanups in the future.
> 
> Also removes a direct xtime access, replacing it with
> current_kernel_time()
> 
> I have not built or tested this patch, so help from arch maintainers
> would be appreciated.
I havn't tested either, but built footbridge_defconfig successfully.
bloat-o-meter reports:

add/remove: 4/1 grow/shrink: 2/2 up/down: 388/-196 (192)
function                                     old     new   delta
sync_cmos_clock                                -     240    +240
update_persistent_clock                        -      52     +52
sync_cmos_work                                 -      40     +40
do_adjtimex                                 1924    1956     +32
save_time_delta                               56      76     +20
no_sync_cmos_clock                             -       4      +4
next_rtc_update                                4       -      -4
set_isa_cmos_time                            372     364      -8
timer_tick                                   324     140    -184

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
