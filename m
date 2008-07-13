Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbYGMLzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbYGMLzJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 07:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYGMLy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 07:54:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46116 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752493AbYGMLyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 07:54:55 -0400
Date: Sun, 13 Jul 2008 12:35:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Alan Cox <alan@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: pata_it821x completely broken
Message-ID: <20080713123510.6f47ffdc@lxorguk.ukuu.org.uk>
In-Reply-To: <200807131347.14045.linux@rainbow-software.org>
References: <200807042153.56644.linux@rainbow-software.org>
	<20080711211409.2eef4ddb@lxorguk.ukuu.org.uk>
	<200807122342.12841.linux@rainbow-software.org>
	<200807131347.14045.linux@rainbow-software.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The patch below fixes the IDENTIFY problem for me and makes the RAID array accessible.
> Is it OK or is there a better way to do it?

Probably better to fix it in driver. Right now we don't have a way to
override the identify reading or post process it cleanly at it821x hacks
around that but if that was fixed then the special cases can all hide in
the driver where they belong.

> +	/* Has LBA48 but advertises neither LBA nor LBA48 */
> +	{ "Integrated Technology Express Inc", NULL, ATA_HORKAGE_LBA48_FORCE, },

That depends on the firmware revision it seems. Mine are fine

