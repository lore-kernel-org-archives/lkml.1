Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbYAOLFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbYAOLFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 06:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbYAOLFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 06:05:03 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58363 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751060AbYAOLFA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 06:05:00 -0500
Date: Tue, 15 Jan 2008 11:02:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Mao Rui" <maorui@yuvad.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: SATA DOM is not identified by ata_piix module
Message-ID: <20080115110218.24a18b27@lxorguk.ukuu.org.uk>
In-Reply-To: <003a01c8575f$070d2230$7740a8c0@cmaorui2>
References: <003a01c8575f$070d2230$7740a8c0@cmaorui2>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008 18:11:25 +0800
"Mao Rui" <maorui@yuvad.com> wrote:

> Hi,
> 
> I have a PQI Turbo SATA DOM. It works well under Windows. I installed it in
> a SuperMicro motherboard, Intel 5000P chipset. The OS is Ubuntu 7.04, kernel
> 2.6.20-15. But the DOM is not appeared as a device node, and I found several
> error messages in kernel log.

Generally it is a good idea to report problems with vendor built kernels
to the vendor and their support, especially one that is 3 releases behind.
They have a much better idea what is in that kernel and who else has seen
problems.

> [   67.124299] ata2.00: qc timeout (cmd 0x91)
> [   67.124306] ata2.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
> err_mask=0x4)

We issued commands, it didn't respond. That could be a libata problem but
actually looks more like an IRQ routing problem.

> Actually I also have a PQI IDE DOM, it have same error with Ubuntu 7.04 /

The PQI DOM is a bit odd, it is however known to work with libata at
least for the PATA one, and the versions which don't understand
SET_XFER_MODE to work with current kernels. (Your failure mode isn't the
SET_XFER_MODE one - it hasn't got that far).

Alan
