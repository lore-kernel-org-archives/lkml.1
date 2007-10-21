Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbXJUUmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbXJUUmg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 16:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbXJUUma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 16:42:30 -0400
Received: from 133.90.227.87.static.ehn.siw.siwnet.net ([87.227.90.133]:52422
	"EHLO 133.90.227.87.static.ehn.siw.siwnet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855AbXJUUm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 16:42:29 -0400
Date: Sun, 21 Oct 2007 22:42:24 +0200
From: Henrik Carlqvist <hc1@poolhem.se>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tristate and bool not enogh for Kconfig anymore
Message-Id: <20071021224224.5a0bd1a1.hc1@poolhem.se>
In-Reply-To: <20071021094517.78dd1916.rdunlap@xenotime.net>
References: <200710201257.55616.nick@ukfsn.org>
	<20071020144238.4f258c8c.hc1@poolhem.se>
	<20071020191700.GB8774@uranus.ravnborg.org>
	<26703.1192942058@turing-police.cc.vt.edu>
	<20071021122402.2f0f3b40.hc1@poolhem.se>
	<20071021094517.78dd1916.rdunlap@xenotime.net>
X-Mailer: Sylpheed version 0.9.2 (GTK+ 1.2.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> config FOO
> 	depends on BAR && m
> 
> restricts FOO to module-only.

Thanks alot! That really did the trick! With the following file:

-8<-------------------------------
config SCSI_QLA_FC
        tristate "QLogic QLA2XXX Fibre Channel Support"
        depends on PCI && SCSI && m
        select SCSI_FC_ATTRS
        select FW_LOADER
        ---help---
        This qla2xxx driver supports all QLogic Fibre Channel
        PCI and PCIe host adapters.

        By default, firmware for the ISP parts will be loaded
        via the Firmware Loader interface.

        ISP               Firmware Filename
        ----------        -----------------
        21xx              ql2100_fw.bin
        22xx              ql2200_fw.bin
        2300, 2312, 6312  ql2300_fw.bin
        2322, 6322        ql2322_fw.bin
        24xx              ql2400_fw.bin

        Upon request, the driver caches the firmware image until
        the driver is unloaded.

        Firmware images can be retrieved from:

                ftp://ftp.qlogic.com/outgoing/linux/firmware/
-8<-------------------------------

It is now only possible to compile the driver as a module.

Best regards Henrik
-- 
NOTE: Dear Outlook users: Please remove me from your address books.
      Read this article and you know why:
      http://newsforge.com/article.pl?sid=03/08/21/143258
