Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbYKDGOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbYKDGOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 01:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYKDGKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 01:10:36 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45511 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045AbYKDGKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 01:10:30 -0500
Message-ID: <490FE750.50405@pobox.com>
Date: Tue, 04 Nov 2008 01:10:24 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 2.6.28-rc2] sata_promise: add ATA engine reset to reset
 ops
References: <200810310703.m9V73tAk019180@harpo.it.uu.se>
In-Reply-To: <200810310703.m9V73tAk019180@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> Promise ATA engines need to be reset when errors occur.
> That's currently done for errors detected by sata_promise itself,
> but it's not done for errors like timeouts detected outside of
> the low-level driver.
> 
> The effect of this omission is that a timeout tends to result
> in a sequence of failed COMRESETs after which libata EH gives
> up and disables the port. At that point the port's ATA engine
> hangs and even reloading the driver will not resume it.
> 
> To fix this, make sata_promise override ->hardreset on SATA
> ports with code which calls pdc_reset_port() on the port in
> question before calling libata's hardreset. PATA ports don't
> use ->hardreset, so for those we override ->softreset instead.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
> ---
> Updated to add pdc_reset_port() to ->softreset not ->hardreset
> on PATA ports. Patch title adjusted accordingly.
> 
> This should also go into the 2.6.27 and 2.6.26 stable branches.
> In older branches libata EH is different and I'm seeing different
> behaviour on timeouts, so I don't think this should go in as-is
> in 2.6.25 and older.
> 
>  drivers/ata/sata_promise.c |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)

applied


