Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbXEYAUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbXEYAUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 20:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbXEYAUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 20:20:44 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53215 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbXEYAUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 20:20:43 -0400
Message-ID: <46562B5A.2070008@zytor.com>
Date: Thu, 24 May 2007 17:18:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.22-rc1-mm1: IDE compile error
References: <20070515201914.16944e04.akpm@linux-foundation.org>	<20070516185552.GA4086@stusta.de>	<200705240145.38055.bzolnier@gmail.com>	<20070524115549.01c0e1ca@the-village.bc.nu>	<4656284D.7080709@zytor.com> <20070525011403.20e77ee7@the-village.bc.nu>
In-Reply-To: <20070525011403.20e77ee7@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> I believe the technical description for the comment is "bullshit" 8)
> 
> Almost all MFM controllers and RLL controllers will only run at the
> standard primary and secondary ATA address.

Yes, but that doesn't (necessarily) apply to the controller that is
likely to be the primary controller in a modern system.

The whole point is that what the BIOS considers primary isn't
necessarily tied to the standard ATA addresses anymore, with SATA
controllers being primary.

The question I'm asking is: do you think it's better to remove this from
hd.c, or do you think it's better to add it back boot code BIOS
detection (and take the risk of poking an ST-506 disk with legacy data
with parameters which may belong to another disk -- keep in mind this
can permanently damage an ST-506 disk)?

> Given the intended use of the driver today I don't see a big problem in
> requiring "hd=" although you have to question the point of this boot code
> rewrite when it seems primarily to be removing features 

I've been trying to remove features that are obsolete and/or broken.  I
don't have access to this particular ancient hardware, nor any system
that can even host them.   It's very easy to add the stuff back in the
boot code; it's a much more tricky/annoying question if one *should* do
so.  That's part of a rewrite/cleanup.

	-hpa
