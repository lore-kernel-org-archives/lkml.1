Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYG1H6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYG1H6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 03:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbYG1H56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 03:57:58 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:48975 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188AbYG1H56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 03:57:58 -0400
X-Sasl-enc: wKQoyyipZ3GcM6oPii5H2GOaBun5P2YsUVwqrqMMC0WS 1217231876
Message-ID: <488D7BFF.10005@ladisch.de>
Date: Mon, 28 Jul 2008 09:57:51 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: lkml <linux-kernel@vger.kernel.org>, bob.picco@hp.com,
       venkatesh.pallipadi@intel.com, Vojtech Pavlik <vojtech@suse.cz>,
       the arch/x86 maintainers <x86@kernel.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [patch 2.6.26-git] /dev/hpet - fixes and cleanup
References: <200807221508.56672.david-b@pacbell.net> <200807230912.49850.david-b@pacbell.net> <4888691D.5090307@ladisch.de> <200807251258.59878.david-b@pacbell.net>
In-Reply-To: <200807251258.59878.david-b@pacbell.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> ...
> Plus, add a FIXME comment for something that could cause big trouble
> on systems with more capable HPETs than at least Intel seems to ship.
> ...
> +
> +		/* FIXME this may trash both the system clocksource and
> +		 * the current clock event device!  Use HPET_TN_SETVAL
> +		 * instead, like arch/x86/kernel/hpet.c does ... never
> +		 * modify the counter, ever.
> +		 */
>  		m = read_counter(&hpet->hpet_mc);
>  		write_counter(t + m + hpetp->hp_delta, &timer->hpet_compare);

This comment seems to assume that the code below modifies the main
counter, which it doesn't.  Additionally, HPET_TN_SETVAL has the same
value as Tn_VAL_SET_CNF_MASK (from <linux/hpet.h>), which _is_ used.


Regards,
Clemens
