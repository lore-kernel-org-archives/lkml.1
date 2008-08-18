Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbYHRNk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbYHRNk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 09:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYHRNkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 09:40:51 -0400
Received: from cpsmtpo-eml04.kpnxchange.com ([213.75.38.153]:2234 "EHLO
	cpsmtpo-eml04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752683AbYHRNku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 09:40:50 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
Date: Mon, 18 Aug 2008 15:40:24 +0200
User-Agent: KMail/1.9.9
Cc: Marcel Selhorst <tpm@selhorst.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808181540.25286.elendil@planet.nl>
X-OriginalArrivalTime: 18 Aug 2008 13:40:48.0007 (UTC) FILETIME=[0592C170:01C90138]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While comparing the loaded modules for 2.6.26 and 2.6.27-rc3 for my HP 
2510p, I noticed that the tpm_infineon module and related modules no 
longer get loaded automatically.

The difference seems to be that 2.6.26 listed:
/lib/modules/2.6.26.2/modules.alias:alias pnp:dIFX0102* tpm_infineon
/lib/modules/2.6.26.2/modules.alias:alias pnp:dIFX0101* tpm_infineon

while 2.6.27 has:
/lib/modules/2.6.27-rc3/modules.alias:alias acpi*:IFX0101:* tpm_infineon
/lib/modules/2.6.27-rc3/modules.alias:alias pnp:dIFX0101* tpm_infineon

My system has:
$ grep IFX /sys/bus/pnp/devices/*/id
/sys/bus/pnp/devices/00:02/id:IFX0102

And if I modprobe the module manually the device really does seem to be 
supported:
pnp: the driver 'tpm_inf_pnp' has been registered
tpm_inf_pnp 00:02: Found C284 with ID IFX0102
tpm_inf_pnp 00:02: TPM found: config base 0x560, data base 0x570, chip 
version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 
TT 1.2)
tpm_inf_pnp 00:02: driver attached

Relevant bit of the kernel config:
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=m

I've taken a quick look at changes from 2.6.26 in drivers/char/tpm/ but 
did not see really anything there that could explain this difference in 
behavior.

Cheers,
FJP
