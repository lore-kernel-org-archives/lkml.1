Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595AbYGUBfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbYGUBfW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 21:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbYGUBfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 21:35:09 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:64383 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbYGUBfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 21:35:08 -0400
Subject: Re: [patch 2/4] fastboot: retry mounting the root fs if we can't
	find init
From: Daniel Walker <dwalker@mvista.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Simon Arlott <simon@fire.lp0.eu>,
       Rene Herman <rene.herman@keyaccess.nl>, Neil Brown <neilb@suse.de>
In-Reply-To: <20080720151304.59b06786@infradead.org>
References: <20080720151140.4aa7c682@infradead.org>
	 <20080720151304.59b06786@infradead.org>
Content-Type: text/plain
Date: Sun, 20 Jul 2008 18:35:04 -0700
Message-Id: <1216604104.14562.3.camel@dhcp32.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-20 at 15:13 -0700, Arjan van de Ven wrote:
> +               /*
> +                * We haven't found init yet... potentially because the device
> +                * is still being probed. We need to
> +                * - flush keventd and friends
> +                * - wait for the known devices to complete their probing
> +                * - try to mount the root fs again
> +                */
> +               flush_scheduled_work();
> +               while (driver_probe_done() != 0)
> +                       msleep(100);

I realize the while() loop above is just code shifted from
init/do_mounts_md.c , but I'm wondering if that could be a complete
instead of a while then sleep 100ms .. That would reduce the overshoot .

Daniel

