Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZKIKgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZKIKgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 05:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZKIKgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 05:36:16 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:41165 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbZKIKgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 05:36:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=g92pBBVuN+mnVTduXkFFsD4tSZSTHiRJtwiF/DOYo+4pm/sC27HxRChHdCpxdzR6fu
         f9U4DDdOBsoH5mlGSP1689hZx9fEROmgv4WXToykncgxToePXCC8OKirA1juxA6LAufE
         +apKzeJW9bKoKrARnHObge3qspealdqCMGH/A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [GIT]: IDE
Date: Mon, 9 Nov 2009 11:35:08 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091108.213055.54434626.davem@davemloft.net>
In-Reply-To: <20091108.213055.54434626.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911091135.09051.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 November 2009 06:30:55 David Miller wrote:
> 
> The revert we thought we didn't need, we really do need still, even
> with Bart Z.'s fix.
> 
> The issue is that we are doing these PIO setting calls before we did
> the device probe and therefore we don't yet know the media type.
> 
> Yet the ->set_pio_mode() of some drivers key off of the media type to
> determine whether to turn prefetching etc. on so it can't possibly
> work properly.

Thanks for quick reaction to the revert request.

If somebody is interested in the proper way to fix it you just need to
add ide_unknown media type and set it before probe instead of ide_disk
one.  Then audit ->set_pio_mode implementations for potential gotchas.

[ However it is too late for -rc and nobody is currently working on
  IDE fixes anyway so I just requested the revert . ]

-- 
Bartlomiej Zolnierkiewicz
