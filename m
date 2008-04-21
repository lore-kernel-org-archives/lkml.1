Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYDUIHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYDUIHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbYDUIHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:07:05 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:44974 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbYDUIHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:07:03 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 4/5] IB/ehca: Make some module parameters bool, update descriptions
User-Agent: KMail/1.9.1
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200804211003.10695.fenkes@de.ibm.com>
In-Reply-To: <200804211003.10695.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3040
Date: Mon, 21 Apr 2008 09:06:58 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200804211006.59197.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_main.c |   37 +++++++++++++++----------------
 1 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index ab02ac8..45fe35a 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -69,41 +69,40 @@ int ehca_static_rate   = -1;
 int ehca_scaling_code  = 0;
 int ehca_lock_hcalls   = -1;
 
-module_param_named(open_aqp1,     ehca_open_aqp1,     int, S_IRUGO);
-module_param_named(debug_level,   ehca_debug_level,   int, S_IRUGO);
-module_param_named(hw_level,      ehca_hw_level,      int, S_IRUGO);
-module_param_named(nr_ports,      ehca_nr_ports,      int, S_IRUGO);
-module_param_named(use_hp_mr,     ehca_use_hp_mr,     int, S_IRUGO);
-module_param_named(port_act_time, ehca_port_act_time, int, S_IRUGO);
-module_param_named(poll_all_eqs,  ehca_poll_all_eqs,  int, S_IRUGO);
-module_param_named(static_rate,   ehca_static_rate,   int, S_IRUGO);
-module_param_named(scaling_code,  ehca_scaling_code,  int, S_IRUGO);
+module_param_named(open_aqp1,     ehca_open_aqp1,     bool, S_IRUGO);
+module_param_named(debug_level,   ehca_debug_level,   int,  S_IRUGO);
+module_param_named(hw_level,      ehca_hw_level,      int,  S_IRUGO);
+module_param_named(nr_ports,      ehca_nr_ports,      int,  S_IRUGO);
+module_param_named(use_hp_mr,     ehca_use_hp_mr,     bool, S_IRUGO);
+module_param_named(port_act_time, ehca_port_act_time, int,  S_IRUGO);
+module_param_named(poll_all_eqs,  ehca_poll_all_eqs,  bool, S_IRUGO);
+module_param_named(static_rate,   ehca_static_rate,   int,  S_IRUGO);
+module_param_named(scaling_code,  ehca_scaling_code,  bool, S_IRUGO);
 module_param_named(lock_hcalls,   ehca_lock_hcalls,   bool, S_IRUGO);
 
 MODULE_PARM_DESC(open_aqp1,
-		 "AQP1 on startup (0: no (default), 1: yes)");
+		 "Open AQP1 on startup (default: no)");
 MODULE_PARM_DESC(debug_level,
 		 "Amount of debug output (0: none (default), 1: traces, "
 		 "2: some dumps, 3: lots)");
 MODULE_PARM_DESC(hw_level,
-		 "hardware level"
-		 " (0: autosensing (default), 1: v. 0.20, 2: v. 0.21)");
+		 "Hardware level (0: autosensing (default), "
+		 "0x10..0x14: eHCA, 0x20..0x23: eHCA2)");
 MODULE_PARM_DESC(nr_ports,
 		 "number of connected ports (-1: autodetect, 1: port one only, "
 		 "2: two ports (default)");
 MODULE_PARM_DESC(use_hp_mr,
-		 "high performance MRs (0: no (default), 1: yes)");
+		 "Use high performance MRs (default: no)");
 MODULE_PARM_DESC(port_act_time,
-		 "time to wait for port activation (default: 30 sec)");
+		 "Time to wait for port activation (default: 30 sec)");
 MODULE_PARM_DESC(poll_all_eqs,
-		 "polls all event queues periodically"
-		 " (0: no, 1: yes (default))");
+		 "Poll all event queues periodically (default: yes)");
 MODULE_PARM_DESC(static_rate,
-		 "set permanent static rate (default: disabled)");
+		 "Set permanent static rate (default: no static rate)");
 MODULE_PARM_DESC(scaling_code,
-		 "set scaling code (0: disabled/default, 1: enabled)");
+		 "Enable scaling code (default: no)");
 MODULE_PARM_DESC(lock_hcalls,
-		 "serialize all hCalls made by the driver "
+		 "Serialize all hCalls made by the driver "
 		 "(default: autodetect)");
 
 DEFINE_RWLOCK(ehca_qp_idr_lock);
-- 
1.5.5


