Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbYHPKB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbYHPKB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 06:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYHPKBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 06:01:18 -0400
Received: from aun.it.uu.se ([130.238.12.36]:57929 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbYHPKBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 06:01:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18598.42334.73411.476062@harpo.it.uu.se>
Date: Sat, 16 Aug 2008 12:01:02 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/3] ATA Kconfig cleanup: hide ATA_SFF and add SATA/PATA menu items
In-Reply-To: <qjoca411hv4hm25keq70ul5pnbi7747d13@4ax.com>
References: <qjoca411hv4hm25keq70ul5pnbi7747d13@4ax.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Coady writes:
 > 
 > From: Grant Coady <gcoady.lk@gmail.com>
 > 
 > ATA Kconfig cleanup 1/3: Hide ATA_SFF, add PATA and SATA driver menu
 > enable items, and add dependency on the enabled PATA/SATA lines to 
 > all the ATA drivers except the PATA_PLATFORM items.

...

 > @@ -147,7 +166,7 @@
 >  
 >  config SATA_PROMISE
 >  	tristate "Promise SATA TX2/TX4 support"
 > -	depends on PCI
 > +	depends on ATA_SFF_SATA && PCI
 >  	help
 >  	  This option enables support for Promise Serial ATA TX2/TX4.

As I told you last time this came up, sata_promise drives both
sata and pata ports. One board has 4 pata ports, a couple have
two sata ports and one pata port, and a couple have 4 sata ports.
It's the same ata engine, however.

So at least give sata_promise the same treatment you gave ata_piix:

 > @@ -104,7 +123,7 @@
 >  
 >  config ATA_PIIX
 >  	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
 > -	depends on PCI
 > +	depends on (ATA_SFF_SATA || ATA_SFF_PATA) && PCI
 >  	help
 >  	  This option enables support for ICH5/6/7/8 Serial ATA
 >  	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
 > @@ -114,7 +133,7 @@

I suspect sata_via will want this too.

/Mikael
