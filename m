Return-Path: <linux-kernel-owner+w=401wt.eu-S932432AbYHRTCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbYHRTCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762092AbYHRTAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:00:37 -0400
Received: from ns1.suse.de ([195.135.220.2]:43678 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762084AbYHRTAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:00:35 -0400
Date: Mon, 18 Aug 2008 11:44:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jean Delvare <khali@linux-fr.org>
Subject: [patch 39/60] i2c: Let users select algorithm drivers manually
	again
Message-ID: <20080818184450.GN29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i2c-let-users-select-algorithm-drivers-manually-again.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean Delvare <khali@linux-fr.org>

Already in Linus' tree:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8d24f8dcb7ead491704e274883b2c627062f6235

In kernel 2.6.26, the ability to select I2C algorithm drivers manually
was removed, as all in-kernel drivers do that automatically. However
there were some complaints that it was a problem for out-of-tree I2C
bus drivers. In order to address these complaints, let's allow manual
selection of these drivers again, but still hide them by default for
better general user experience.

This closes bug #11140:
http://bugzilla.kernel.org/show_bug.cgi?id=11140

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/Kconfig       |   14 ++++++++++++++
 drivers/i2c/algos/Kconfig |   11 ++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

--- a/drivers/i2c/algos/Kconfig
+++ b/drivers/i2c/algos/Kconfig
@@ -2,15 +2,20 @@
 # I2C algorithm drivers configuration
 #
 
+menu "I2C Algorithms"
+	depends on !I2C_HELPER_AUTO
+
 config I2C_ALGOBIT
-	tristate
+	tristate "I2C bit-banging interfaces"
 
 config I2C_ALGOPCF
-	tristate
+	tristate "I2C PCF 8584 interfaces"
 
 config I2C_ALGOPCA
-	tristate
+	tristate "I2C PCA 9564 interfaces"
 
 config I2C_ALGO_SGI
 	tristate
 	depends on SGI_IP22 || SGI_IP32 || X86_VISWS
+
+endmenu
--- a/drivers/i2c/Kconfig
+++ b/drivers/i2c/Kconfig
@@ -38,6 +38,20 @@ config I2C_CHARDEV
 	  This support is also available as a module.  If so, the module 
 	  will be called i2c-dev.
 
+config I2C_HELPER_AUTO
+	bool "Autoselect pertinent helper modules"
+	default y
+	help
+	  Some I2C bus drivers require so-called "I2C algorithm" modules
+	  to work. These are basically software-only abstractions of generic
+	  I2C interfaces. This option will autoselect them so that you don't
+	  have to care.
+
+	  Unselect this only if you need to enable additional helper
+	  modules, for example for use with external I2C bus drivers.
+
+	  In doubt, say Y.
+
 source drivers/i2c/algos/Kconfig
 source drivers/i2c/busses/Kconfig
 source drivers/i2c/chips/Kconfig

-- 
