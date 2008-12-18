Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752615AbYLRSKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbYLRSKp (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 13:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYLRSKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 13:10:34 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52921 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750973AbYLRSKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 13:10:33 -0500
Date: Thu, 18 Dec 2008 18:10:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Mario Schwalbe <schwalbe@inf.tu-dresden.de>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] ide: Fix ata_id_has_dword_io to return DWORD I/O
 support properly
Message-ID: <20081218181015.2e160d5c@lxorguk.ukuu.org.uk>
In-Reply-To: <494A837A.50801@garzik.org>
References: <494A5BBF.8000807@inf.tu-dresden.de>
	<494A837A.50801@garzik.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This seems like a risky assumption...

Its wrong on various counts

- ata_id_major_version can't tell early ATA versions apart
- on anything later than the early ISA IDE paddles (the ones that
basically were just bus decoders) its invisible to the drive

Except for legacy ISA bus controllers (and even there it is questionable)
I would favour simply ignoring it.

The reverse half of the problem (the fact the ATA8 drafts reuse it and
can cause confusion if your device is treacherous computing crippled) is
IMHO just amusing 8)

