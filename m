Return-Path: <linux-kernel-owner+w=401wt.eu-S932200AbXBSMeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbXBSMeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 07:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932197AbXBSMeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 07:34:36 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:44535 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203AbXBSMeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 07:34:36 -0500
Message-ID: <45D9995F.9070108@drzeus.cx>
Date: Mon, 19 Feb 2007 13:34:39 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Recent and not-so problems with tifm_sd driver
References: <570331.88389.qm@web36706.mail.mud.yahoo.com>
In-Reply-To: <570331.88389.qm@web36706.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
> 
> mmc_rescan
>   mmc_register_card
>     device_add
>       mmc_block_probe
>         mmc_block_alloc
>           -> queue thread starts running
>         add_disk
>           -> issues a lot of requests; card fails, my drivers calls mmc_remove_host, which in 
>              turn calls device_del, though we are still in device_add
> 

Ahhh, now I see. Well that's an entirely different kettle of fish.

Removing the device in this stack is not supported (we would have a whole bunch
of nasty dead lock possibilities to consider). You need to delay the removal in
some form, e.g. using the mmc workqueue.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
