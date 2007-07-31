Return-Path: <linux-kernel-owner+w=401wt.eu-S934470AbXGaV3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934470AbXGaV3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764240AbXGaV3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:29:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:58495 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934350AbXGaV3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:29:35 -0400
In-Reply-To: <200707250128.l6P1SWSF1336935@shell01.TheWorld.com>
References: <200707250128.l6P1SWSF1336935@shell01.TheWorld.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <3a538bd3f5db759abb55a661e6e94c7a@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] powerpc: Pegasos keyboard detection
Date: Tue, 31 Jul 2007 23:26:35 +0200
To: Alan Curry <pacman@theworld.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> As of 2.6.22 the kernel doesn't recognize the i8042 keyboard/mouse 
> controller
> on the PegasosPPC. This is because of a feature/bug in the OF device 
> tree:
> the "device_type" attribute is an empty string instead of "8042" as the
> kernel expects. This patch (against 2.6.22.1) adds a secondary 
> detection
> which looks for a device whose *name* is "8042" if there is no device 
> whose
> *type* is "8042".
>
> Signed-off-by: Alan Curry <pacman@world.std.com>
>
> --- arch/powerpc/kernel/setup-common.c.orig	2007-07-24 
> 19:04:17.000000000 -0500
> +++ arch/powerpc/kernel/setup-common.c	2007-07-24 19:06:36.000000000 
> -0500
> @@ -487,6 +487,10 @@ int check_legacy_ioport(unsigned long ba
>  	switch(base_port) {
>  	case I8042_DATA_REG:
>  		np = of_find_node_by_type(NULL, "8042");
> +		/* Pegasos has no device_type on its 8042 node, look for the
> +		 * name instead */
> +		if (!np)
> +			np = of_find_node_by_name(NULL, "8042");

[I know it already got merged, I'm behind on mail, but anyway...]

Could board-specific quirks like this please always include a
check for that board?  Or, even better, do a fixup in the
bootwrapper.

In this case the workaround won't likely trigger on the wrong
boards, but "just a little bit" more dangerous workarounds
_will_, and the law of big numbers works against us...


Segher

