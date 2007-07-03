Return-Path: <linux-kernel-owner+w=401wt.eu-S1758474AbXGCGrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474AbXGCGrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 02:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbXGCGrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 02:47:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:46164 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbXGCGro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 02:47:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=jTGv49tuirJkMUVIa10n//U4Teurefu689BvWg91zOp/r7KS4yVBpGhB5dOl0VBBFba34TkxhXECGOfZGvPmPStnJf5B9WciZulEJ/tSOZ4vwQkvgim/AP3e4VYMP4xQ8+Yta1CIKoDNmMbOi64/TiulWlOvUyYPhcwfhP/191c=
Message-ID: <4689F10B.8090606@gmail.com>
Date: Tue, 03 Jul 2007 15:47:39 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.22-rc5 2/2] sata_promise: SATA hotplug support
References: <200706191954.l5JJsVl9002671@alkaid.it.uu.se>
In-Reply-To: <200706191954.l5JJsVl9002671@alkaid.it.uu.se>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> This patch enables hotplugging of SATA devices in the
> sata_promise driver. It's been tested successfully on
> both first- and second-generation Promise SATA chips:
> SATA150 TX2plus, SATAII150 TX2plus, SATA300 TX2plus,
> and SATA300 TX4.
> 
> The only quirk I've seen is that hotplugging (insertion)
> on the first-generation SATA150 TX2plus requires a lengthier
> EH sequence than on the second-generation chips.
> On the second-generation chips a simple soft reset seems
> to suffice, but on the first-generation chip there's a
> "port is slow to respond" after the initial soft reset,
> after which libata issues a hard reset, and then the
> device is recognised.
> 
> The hotplug checks are high up in the interrupt handling
> path, not deep down in error_intr as in ahci/sata_sil24.
> That's because the chip doesn't signal hotplug status changes
> in the per-port status register: instead a global register
> contains hotplug control and status flags for all ports.
> I considered following the ahci/sata_sil24 structure, but
> that would have required non-trivial changes to the interrupt
> handling path, so I chose to keep the hotplug changes simple
> and unobtrusive.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

Some unlikely()'s might be helpful here and there but other than that.

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
