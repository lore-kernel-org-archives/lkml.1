Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbZFKOWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbZFKOWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZFKOWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:22:38 -0400
Received: from lud.servebeer.com ([82.231.107.211]:43759 "EHLO
	lud.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZFKOWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:22:38 -0400
X-Greylist: delayed 2259 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jun 2009 10:22:37 EDT
Date: Thu, 11 Jun 2009 15:44:58 +0200
From: Ludovic Drolez <ldrolez@debian.org>
To: linux-kernel@vger.kernel.org
Subject: help needed: DVB-T nearly working with a Terratec Cynergy Hybrid
	XS 0ccd:005e
Message-ID: <20090611134458.GE8621@red.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

I've modified the sources of a 2.6.29.4 kernel to try to have my
Terratec Hybrid usb key working in DVB-T mode.

Basically I modified em28xx-cards.c, and used the settings of a WINTV
HVR-900 for my card.

      [EM2882_BOARD_TERRATEC_HYBRID_XS] = {
	          .name         = "Terratec Hybrid XS (em2882)",
	          .valid        = EM28XX_BOARD_NOT_VALIDATED,
	          .tuner_type   = TUNER_XC2028,
		  .tuner_gpio = default_tuner_gpio,
  		  //.mts_firmware = 1, with or without same results
    		  .has_dvb      = 1,
      		  .dvb_gpio     = hauppauge_wintv_hvr_900_digital,
      
It nearly works: only the 1st tuning works, then that's as if the
tuner is locked up.

For example scan, tunes properly for the 1st frequency:

--------------------
# scan /usr/share/dvb/dvb-t/fr-Metz
scanning /usr/share/dvb/dvb-t/fr-Metz
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 570166000 0 2 9 3 1 0 0
initial transponder 594166000 0 2 9 3 1 0 0
initial transponder 754166000 0 2 9 3 1 0 0
initial transponder 770166000 0 2 9 3 1 0 0
initial transponder 498166000 0 2 9 3 1 0 0
initial transponder 794166000 0 2 9 3 1 0 0
>>> tune to:
570166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
Network Name 'F'
0x0000 0x0101: pmt_pid 0x006e GR1 -- France 2 (running)
0x0000 0x0104: pmt_pid 0x0136 GR1 -- France 5 (running)
0x0000 0x0105: pmt_pid 0x01fe GR1 -- ARTE (running)
0x0000 0x0106: pmt_pid 0x0262 GR1 -- LCP (running)
0x0000 0x0111: pmt_pid 0x00d2 National -- France 3 (running)
0x0000 0x01ff: pmt_pid 0x03f2 (null) -- (null) (running)
>>> tune to:
594166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
754166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
--------------------

If I change the 1st freq in the config file and restart scan it works.
So only the 1st tuning works when the FE is opened only one time,
after the firmware is sent:

-------------------
xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
xc2028 4-0061: Loading firmware for type=D2633 DTV8 (210), id 0000000000000000.
xc2028 4-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
-------------------

How could I solve this stupid tuning problem ?

(BTW, this usb device seems to work properly in analog mode)

Cheers,

-- 
Ludovic Drolez.

http://www.geeksback.com          - Secure File Backups for Geeks
http://www.palmopensource.com     - The WebOS Open Source Portal
