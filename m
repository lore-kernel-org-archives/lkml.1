Return-Path: <linux-kernel-owner+w=401wt.eu-S1758362AbYAWAA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362AbYAWAA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 19:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYAWAAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 19:00:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:57797 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbYAWAAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 19:00:17 -0500
Subject: Re: [PATCH] ppc: fix #ifdef-s in mediabay driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <200801230012.38516.bzolnier@gmail.com>
References: <200801230012.38516.bzolnier@gmail.com>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 10:59:54 +1100
Message-Id: <1201046394.6807.49.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-23 at 00:12 +0100, Bartlomiej Zolnierkiewicz wrote:
> * Replace incorrect CONFIG_BLK_DEV_IDE #ifdef in
>   check_media_bay() by CONFIG_MAC_FLOPPY one.
> 
> * Replace incorrect CONFIG_BLK_DEV_IDE #ifdef-s by
>   CONFIG_BLK_DEV_IDE_PMAC ones.
> 
> * check_media_bay() is used only by drivers/block/swim3.c
>   so make this function available only if CONFIG_MAC_FLOPPY
>   is defined.
> 
> * check_media_bay_by_base() and media_bay_set_ide_infos()
>   are used only by drivers/ide/ppc/pmac.c so so make these
>   functions available only if CONFIG_MAC_FLOPPY is defined.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> Ben, IMO this patch is safe for 2.6.24 (assuming that it builds fine :),
> otherwise I would like to ask for permission to merge it through IDE
> tree since I have other pending IDE patches depending on this one.

I'd rather avoid touching 2.6.24 unless it actually fixes a bug or
regression...

I'm tempted to actually remove all ifdef's ... if you have a media-bay,
then there are about 99% chances it contains an IDE device, with the
remaining percent being split with putting a floppy or a battery in. I
doubt anybody will care building a kernel without the support for these
and with the mediabay support, and still want to save a handful of bytes
in that driver.

Ben.


