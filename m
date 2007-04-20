Return-Path: <linux-kernel-owner+w=401wt.eu-S1751673AbXDTXuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbXDTXuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 19:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbXDTXuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 19:50:17 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:35414 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbXDTXuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 19:50:16 -0400
Message-ID: <462951B5.8000906@simon.arlott.org.uk>
Date: Sat, 21 Apr 2007 00:50:13 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] cxacru: Add Documentation file
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The sysfs attributes for exposing cxacru statistics/status information 
with possible values is now explained in Documentation/networking/cxacru.txt 
including information on the writable adsl_state attribute's commands and 
a sample of the kernel log format.

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
index 0000000..2623eaa
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
+several sysfs attribute files for retriving device statistics:
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
1.5.0.1

-- 
Simon Arlott
