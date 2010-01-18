Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772Ab0ARR6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab0ARR6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502Ab0ARR6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:58:12 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58321 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752032Ab0ARR6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:58:11 -0500
Date: Mon, 18 Jan 2010 18:00:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/64] pata_via: fix address setup timings underlocking
Message-ID: <20100118180057.6ecde501@lxorguk.ukuu.org.uk>
In-Reply-To: <20100118171703.14623.85025.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
	<20100118171703.14623.85025.sendpatchset@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 18:17:03 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] pata_via: fix address setup timings underlocking
> 
> Correct via_do_set_mode() documentation while at it.

>  		setup &= ~(3 << shift);
> -		setup |= clamp_val(t.setup, 1, 4) << shift;	/* 1,4 or 1,4 - 1  FIXME */
> +		setup |= (clamp_val(t.setup, 1, 4) - 1) << shift;
>  		pci_write_config_byte(pdev, 0x4C, setup);

Change looks correct to me and matches the VT8235 data sheet (p.97)

Alan
