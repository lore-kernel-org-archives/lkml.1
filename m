Return-Path: <linux-kernel-owner+w=401wt.eu-S1762959AbXGEVR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762959AbXGEVR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 17:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757501AbXGEVRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 17:17:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:55271 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674AbXGEVRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 17:17:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FHXLNVCT+Xzkkg7/YO2LHr6TzuyEb3IzUljuDuU7dejyI8dpuf70Bic/3mjN94Euml/5exUbAOo2KMAhEQdrn0zP84TgrI04QjhmZ0KMSNF76oqU/Tnuhh5lzD6MkG/b+JBNcGNHoK/xjCEqfbMK4xaoTA1D4+kRsPtnk4PujJ4=
Subject: SD card readable only up to certain boundary (samcop sdi
	controller)
From: Milan Plzik <milan.plzik@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx
Content-Type: text/plain
Date: Thu, 05 Jul 2007 23:17:24 +0200
Message-Id: <1183670244.9213.81.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  I'm trying to get samcop sdi controller (found e.g. in h5000 ipaqs)
working with Apacer 2GB SD card. Samcop sdi, nor samcop in general is
supported in vanilla kernel, but I'm not sure what could be wrong (I
suspect either mmc_block or sdi driver), so I think lkml might be the
right place.

  My problem is that I can access only small portion of SD card --
roughly 224MB (in 512byte sectors, the boundary is 0x70000, inclusive).
All reads/writes beyond this address cause errors like timeouts, fifo
underrun, etc. (MMC errors 1, 3 and 4). DMA engine, which reads received
data seems to be 'frozen' at incomplete transfer (counter of remaining
blocks to be transferred is stopped at non-zero value, although
something seems to be transferred, but that might not be useful data).
Kernel version is 2.6.21, with handhelds.org patches.

  The SD card works correctly with other devices, like PCMCIA card
readers. Also samcop sdi was able to fully read 512MB card. I'm not
really sure what could cause behavior like this and I'm open to any
suggestion.

  Also, please Cc me, as I'm not subscribed to linux-kernel... .

  Thank you,

	Milan Plzik

