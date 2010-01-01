Return-Path: <linux-kernel-owner+w=401wt.eu-S1751818Ab0AARZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab0AARZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 12:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468Ab0AARZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 12:25:19 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:35794 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab0AARZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 12:25:18 -0500
Date: Fri, 1 Jan 2010 12:24:41 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: spi-devel-general@lists.sourceforge.net
Subject: [PATCH] SPI: Fix apparently reversed args to time_before().
Message-ID: <alpine.LFD.2.00.1001011222400.24884@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  given that the macro this is contained in reads:

#define busy_wait(cond)                                           \
        ({                                                        \
        unsigned long end_jiffies = jiffies + STMP_SPI_TIMEOUT;   \
        bool succeeded = false;                                   \
        do {                                                      \
                if (cond) {                                       \
                        succeeded = true;                         \
                        break;                                    \
                }                                                 \
                cpu_relax();                                      \
        } while (time_before(jiffies, end_jiffies));              \
        succeeded;                                                \
        })

it seems obvious that those args are in the wrong order.

diff --git a/drivers/spi/spi_stmp.c b/drivers/spi/spi_stmp.c
index 2552bb3..fadff76 100644
--- a/drivers/spi/spi_stmp.c
+++ b/drivers/spi/spi_stmp.c
@@ -76,7 +76,7 @@ struct stmp_spi {
 			break;						\
 		}							\
 		cpu_relax();						\
-	} while (time_before(end_jiffies, jiffies));			\
+	} while (time_before(jiffies, end_jiffies));			\
 	succeeded;							\
 	})



========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
