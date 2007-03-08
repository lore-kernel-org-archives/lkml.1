Return-Path: <linux-kernel-owner+w=401wt.eu-S1750916AbXCHAfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750916AbXCHAfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbXCHAfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:35:40 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54138 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750916AbXCHAfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:35:39 -0500
Date: Thu, 8 Mar 2007 01:37:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: torvalds@osdl.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       Adrian Bunk <bunk@stusta.de>
Subject: Bad regression v 2.6.19 from the ATA ACPI merge
Message-ID: <20070308013746.751281a6@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every single non-PCI controller has been broken by this code.

pata_get_dev_handle() assumes that the passed ata_port is PCI. The
libata-core code does not do any checking. This causes everyone to
experience oopses with pata_pcmcia for example.

Multiple examples of the bug in our FC7test tree reports from end users
trying the new libata and kernels.

