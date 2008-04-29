Return-Path: <linux-kernel-owner+w=401wt.eu-S1761454AbYD2U1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761454AbYD2U1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757252AbYD2U1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:27:06 -0400
Received: from mail-ausfall.charite.de ([193.175.70.131]:51809 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926AbYD2U1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:27:05 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Apr 2008 16:27:05 EDT
Date: Tue, 29 Apr 2008 22:17:27 +0200
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: HP server and atto driver from hell
Message-ID: <20080429201727.GV8066@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We thought HP would be a smart choice when it comes to Linux,..
Until now, because now we have to use a PCI Express SCSI card that
comes with a proprietary driver that won't even compile.

When I untar the lnx_drv_epciu320_107.tar.gz and try to compile the
glue between the binary blob and the kernel, I get:

c# make -k modules
Architecture is i386 (x86_regparm)
make[1]: Entering directory /usr/src/linux-2.6.25'
  CC [M]  /usr/src/lnx_drv_epciu320_107/src/atto_cfg.o
  /usr/src/lnx_drv_epciu320_107/src/atto_cfg.c: In function ‘attocfg_read_version’: /usr/src/lnx_drv_epciu320_107/src/atto_cfg.c:258: error: ‘struct device_driver’ has no member named ‘kobj’
make[2]: *** [/usr/src/lnx_drv_epciu320_107/src/atto_cfg.o] Error 1
  CC [M]  /usr/src/lnx_drv_epciu320_107/src/oswrap.o
  /usr/src/lnx_drv_epciu320_107/src/oswrap.c: In function ‘express2_attocfg_register’: /usr/src/lnx_drv_epciu320_107/src/oswrap.c:908: error: ‘struct device_driver’ has no member named ‘kobj’
make[2]: *** [/usr/src/lnx_drv_epciu320_107/src/oswrap.o] Error 1
make[2]: Target __build' not remade because of errors.
make[1]: *** [_module_/usr/src/lnx_drv_epciu320_107/src] Error 2
make[1]: Target modules' not remade because of errors.
make[1]: Leaving directory /usr/src/linux-2.6.25'
make: *** [modules] Error 2

in atto_cfg.c:

   258          if (this_drvr->kobj == &driver->kobj)
   259          {
   260              if (this_drvr->read_version)
   261                  return (*this_drvr->read_version) (driver, buffer);
   262              else
   263                  return 0;
   264          }

and in oswrap.o:

   905                  return NULL;
   906      }
   907
   908      return &atto_pci_driver.driver.kobj;
   909  }
   910
		  

-- 
Ralf Hildebrandt (i.A. des IT-Zentrums)         Ralf.Hildebrandt@charite.de
Charite - Universitätsmedizin Berlin            Tel.  +49 (0)30-450 570-155
Gemeinsame Einrichtung von FU- und HU-Berlin    Fax.  +49 (0)30-450 570-962
IT-Zentrum Standort CBF                 send no mail to snickebo@charite.de
