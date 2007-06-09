Return-Path: <linux-kernel-owner+w=401wt.eu-S968169AbXFIAF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968169AbXFIAF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 20:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968792AbXFIAEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 20:04:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:48282 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968965AbXFIAEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 20:04:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Simon Arlott <simon@fire.lp0.eu>,
       Duncan Sands <duncan.sands@math.u-psud.fr>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/9] USB: cxacru: add Documentation file
Date: Fri,  8 Jun 2007 17:03:50 -0700
Message-Id: <11813474672336-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <118134746039-git-send-email-gregkh@suse.de>
References: <20070609000312.GA17574@kroah.com>
 <11813474343815-git-send-email-gregkh@suse.de>
 <1181347441440-git-send-email-gregkh@suse.de>
 <11813474492376-git-send-email-gregkh@suse.de>
 <118134746039-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Arlott <simon@fire.lp0.eu>

The sysfs attributes for exposing cxacru statistics/status information with
possible values is now explained in Documentation/networking/cxacru.txt
including information on the writable adsl_state attribute's commands and a
sample of the kernel log format.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Duncan Sands <duncan.sands@math.u-psud.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/networking/00-INDEX   |    2 +
 Documentation/networking/cxacru.txt |   84 +++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/networking/cxacru.txt

diff --git a/Documentation/networking/00-INDEX b/Documentation/networking/00-INDEX
index e06b6e3..153d84d 100644
--- a/Documentation/networking/00-INDEX
+++ b/Documentation/networking/00-INDEX
@@ -32,6 +32,8 @@ cops.txt
 	- info on the COPS LocalTalk Linux driver
 cs89x0.txt
 	- the Crystal LAN (CS8900/20-based) Ethernet ISA adapter driver
+cxacru.txt
+	- Conexant AccessRunner USB ADSL Modem
 de4x5.txt
 	- the Digital EtherWORKS DE4?? and DE5?? PCI Ethernet driver
 decnet.txt
diff --git a/Documentation/networking/cxacru.txt b/Documentation/networking/cxacru.txt
new file mode 100644
index 0000000..b074681
--- /dev/null
+++ b/Documentation/networking/cxacru.txt
@@ -0,0 +1,84 @@
+Firmware is required for this device: http://accessrunner.sourceforge.net/
+
+While it is capable of managing/maintaining the ADSL connection without the
+module loaded, the device will sometimes stop responding after unloading the
+driver and it is necessary to unplug/remove power to the device to fix this.
+
+Detected devices will appear as ATM devices named "cxacru". In /sys/class/atm/
+these are directories named cxacruN where N is the device number. A symlink
+named device points to the USB interface device's directory which contains
+several sysfs attribute files for retrieving device statistics:
+
+* adsl_controller_version
+
+* adsl_headend
+* adsl_headend_environment
+	Information about the remote headend.
+
+* downstream_attenuation (dB)
+* downstream_bits_per_frame
+* downstream_rate (kbps)
+* downstream_snr_margin (dB)
+	Downstream stats.
+
+* upstream_attenuation (dB)
+* upstream_bits_per_frame
+* upstream_rate (kbps)
+* upstream_snr_margin (dB)
+* transmitter_power (dBm/Hz)
+	Upstream stats.
+
+* downstream_crc_errors
+* downstream_fec_errors
+* downstream_hec_errors
+* upstream_crc_errors
+* upstream_fec_errors
+* upstream_hec_errors
+	Error counts.
+
+* line_startable
+	Indicates that ADSL support on the device
+	is/can be enabled, see adsl_start.
+
+* line_status
+	"initialising"
+	"down"
+	"attempting to activate"
+	"training"
+	"channel analysis"
+	"exchange"
+	"waiting"
+	"up"
+
+	Changes between "down" and "attempting to activate"
+	if there is no signal.
+
+* link_status
+	"not connected"
+	"connected"
+	"lost"
+
+* mac_address
+
+* modulation
+	"ANSI T1.413"
+	"ITU-T G.992.1 (G.DMT)"
+	"ITU-T G.992.2 (G.LITE)"
+
+* startup_attempts
+	Count of total attempts to initialise ADSL.
+
+To enable/disable ADSL, the following can be written to the adsl_state file:
+	"start"
+	"stop
+	"restart" (stops, waits 1.5s, then starts)
+	"poll" (used to resume status polling if it was disabled due to failure)
+
+Changes in adsl/line state are reported via kernel log messages:
+	[4942145.150704] ATM dev 0: ADSL state: running
+	[4942243.663766] ATM dev 0: ADSL line: down
+	[4942249.665075] ATM dev 0: ADSL line: attempting to activate
+	[4942253.654954] ATM dev 0: ADSL line: training
+	[4942255.666387] ATM dev 0: ADSL line: channel analysis
+	[4942259.656262] ATM dev 0: ADSL line: exchange
+	[2635357.696901] ATM dev 0: ADSL line: up (8128 kb/s down | 832 kb/s up)
-- 
1.5.2.1

