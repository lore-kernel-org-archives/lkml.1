Return-Path: <linux-kernel-owner+w=401wt.eu-S1762290AbYAKTFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762290AbYAKTFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 14:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761369AbYAKTFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 14:05:23 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:51202 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758288AbYAKTFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 14:05:22 -0500
Date: Fri, 11 Jan 2008 20:05:11 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] CRIS v10: Driver for ds1302 needs to include cris-specific i2c.h
Message-ID: <20080111190511.GH27482@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CRIS v10: Driver for ds1302 needs to include cris-specific i2c.h

This fixes compilation error where i2c_init wasn't defined.
Also, remove the CVS log and version tags, they are no longer useful.

---
 arch/cris/arch-v10/drivers/ds1302.c |  131 +----------------------------------
 1 files changed, 3 insertions(+), 128 deletions(-)

diff --git a/arch/cris/arch-v10/drivers/ds1302.c b/arch/cris/arch-v10/drivers/ds1302.c
index 88eff7f..1d1936a 100644
--- a/arch/cris/arch-v10/drivers/ds1302.c
+++ b/arch/cris/arch-v10/drivers/ds1302.c
@@ -6,136 +6,9 @@
 *!
 *! Functions exported: ds1302_readreg, ds1302_writereg, ds1302_init
 *!
-*! $Log: ds1302.c,v $
-*! Revision 1.18  2005/01/24 09:11:26  mikaelam
-*! Minor changes to get DS1302 RTC chip driver to work
-*!
-*! Revision 1.17  2005/01/05 06:11:22  starvik
-*! No need to do local_irq_disable after local_irq_save.
-*!
-*! Revision 1.16  2004/12/13 12:21:52  starvik
-*! Added I/O and DMA allocators from Linux 2.4
-*!
-*! Revision 1.14  2004/08/24 06:48:43  starvik
-*! Whitespace cleanup
-*!
-*! Revision 1.13  2004/05/28 09:26:59  starvik
-*! Modified I2C initialization to work in 2.6.
-*!
-*! Revision 1.12  2004/05/14 07:58:03  starvik
-*! Merge of changes from 2.4
-*!
-*! Revision 1.10  2004/02/04 09:25:12  starvik
-*! Merge of Linux 2.6.2
-*!
-*! Revision 1.9  2003/07/04 08:27:37  starvik
-*! Merge of Linux 2.5.74
-*!
-*! Revision 1.8  2003/04/09 05:20:47  starvik
-*! Merge of Linux 2.5.67
-*!
-*! Revision 1.6  2003/01/09 14:42:51  starvik
-*! Merge of Linux 2.5.55
-*!
-*! Revision 1.4  2002/12/11 13:13:57  starvik
-*! Added arch/ to v10 specific includes
-*! Added fix from Linux 2.4 in serial.c (flush_to_flip_buffer)
-*!
-*! Revision 1.3  2002/11/20 11:56:10  starvik
-*! Merge of Linux 2.5.48
-*!
-*! Revision 1.2  2002/11/18 13:16:06  starvik
-*! Linux 2.5 port of latest 2.4 drivers
-*!
-*! Revision 1.15  2002/10/11 16:14:33  johana
-*! Added CONFIG_ETRAX_DS1302_TRICKLE_CHARGE and initial setting of the
-*! trcklecharge register.
-*!
-*! Revision 1.14  2002/10/10 12:15:38  magnusmn
-*! Added support for having the RST signal on bit g0
-*!
-*! Revision 1.13  2002/05/29 15:16:08  johana
-*! Removed unused variables.
-*!
-*! Revision 1.12  2002/04/10 15:35:25  johana
-*! Moved probe function closer to init function and marked it __init.
-*!
-*! Revision 1.11  2001/06/14 12:35:52  jonashg
-*! The ATA hack is back. It is unfortunately the only way to set g27 to output.
-*!
-*! Revision 1.9  2001/06/14 10:00:14  jonashg
-*! No need for tempudelay to be inline anymore (had to adjust the usec to
-*! loops conversion because of this to make it slow enough to be a udelay).
-*!
-*! Revision 1.8  2001/06/14 08:06:32  jonashg
-*! Made tempudelay delay usecs (well, just a tad more).
-*!
-*! Revision 1.7  2001/06/13 14:18:11  jonashg
-*! Only allow processes with SYS_TIME capability to set time and charge.
-*!
-*! Revision 1.6  2001/06/12 15:22:07  jonashg
-*! * Made init function __init.
-*! * Parameter to out_byte() is unsigned char.
-*! * The magic number 42 has got a name.
-*! * Removed comment about /proc (nothing is exported there).
-*!
-*! Revision 1.5  2001/06/12 14:35:13  jonashg
-*! Gave the module a name and added it to printk's.
-*!
-*! Revision 1.4  2001/05/31 14:53:40  jonashg
-*! Made tempudelay() inline so that the watchdog doesn't reset (see
-*! function comment).
-*!
-*! Revision 1.3  2001/03/26 16:03:06  bjornw
-*! Needs linux/config.h
-*!
-*! Revision 1.2  2001/03/20 19:42:00  bjornw
-*! Use the ETRAX prefix on the DS1302 options
-*!
-*! Revision 1.1  2001/03/20 09:13:50  magnusmn
-*! Linux 2.4 port
-*!
-*! Revision 1.10  2000/07/05 15:38:23  bjornw
-*! Dont update kernel time when a RTC_SET_TIME is done
-*!
-*! Revision 1.9  2000/03/02 15:42:59  macce
-*! * Hack to make RTC work on all 2100/2400
-*!
-*! Revision 1.8  2000/02/23 16:59:18  torbjore
-*! added setup of R_GEN_CONFIG when RTC is connected to the generic port.
-*!
-*! Revision 1.7  2000/01/17 15:51:43  johana
-*! Added RTC_SET_CHARGE ioctl to enable trickle charger.
-*!
-*! Revision 1.6  1999/10/27 13:19:47  bjornw
-*! Added update_xtime_from_cmos which reads back the updated RTC into the kernel.
-*! /dev/rtc calls it now.
-*!
-*! Revision 1.5  1999/10/27 12:39:37  bjornw
-*! Disabled superuser check. Anyone can now set the time.
-*!
-*! Revision 1.4  1999/09/02 13:27:46  pkj
-*! Added shadow for R_PORT_PB_CONFIG.
-*! Renamed port_g_shadow to port_g_data_shadow.
-*!
-*! Revision 1.3  1999/09/02 08:28:06  pkj
-*! Made it possible to select either port PB or the generic port for the RST
-*! signal line to the DS1302 RTC.
-*! Also make sure the RST bit is configured as output on Port PB (if used).
-*!
-*! Revision 1.2  1999/09/01 14:47:20  bjornw
-*! Added support for /dev/rtc operations with ioctl RD_TIME and SET_TIME to read
-*! and set the date. Register as major 121.
-*!
-*! Revision 1.1  1999/09/01 09:45:29  bjornw
-*! Implemented a DS1302 RTC driver.
-*!
-*!
 *! ---------------------------------------------------------------------------
 *!
-*! (C) Copyright 1999, 2000, 2001, 2002, 2003, 2004  Axis Communications AB, LUND, SWEDEN
-*!
-*! $Id: ds1302.c,v 1.18 2005/01/24 09:11:26 mikaelam Exp $
+*! (C) Copyright 1999-2007 Axis Communications AB, LUND, SWEDEN
 *!
 *!***************************************************************************/
 
@@ -156,6 +29,8 @@
 #include <asm/rtc.h>
 #include <asm/arch/io_interface_mux.h>
 
+#include "i2c.h"
+
 #define RTC_MAJOR_NR 121 /* local major, change later */
 
 static const char ds1302_name[] = "ds1302";
-- 
1.5.3.6.970.gd25430


/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
