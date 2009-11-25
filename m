Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbZKYRXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbZKYRXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759251AbZKYRXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:23:38 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53891 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759165AbZKYRXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:23:36 -0500
Date: Wed, 25 Nov 2009 17:25:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/86] pata_efar: fix register naming used in
 efar_set_piomode()
Message-ID: <20091125172541.1267490f@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125170422.5446.10637.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<20091125170422.5446.10637.sendpatchset@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Rename 'idetm_port' and 'idetm_data' variables to 'master_port'
> and 'master_data' respectively to match register naming used in
> efar_set_dma_mode() and in ata_piix.c.

Probably better to do the reverse to match the docs ?

> -	u16 idetm_data;
> +	u8 master_port		= ap->port_no ? 0x42 : 0x40;
> +	u16 master_data;

Please don't drop undocumented type changes in. And btw it uses unsigned
int here as all over the kernel because it produced better code in many
cases

These patches seem to spend a lot of time renaming everything in drivers
which is usually pointless churn (eg the atp grand renaming), but the bug
fixes all look good
