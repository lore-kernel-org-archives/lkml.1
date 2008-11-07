Return-Path: <linux-kernel-owner+w=401wt.eu-S1753051AbYKGXYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbYKGXYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbYKGXW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:22:56 -0500
Received: from kroah.org ([198.145.64.141]:59184 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753153AbYKGXWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:22:54 -0500
Date: Fri, 7 Nov 2008 15:15:21 -0800
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
       alan@lxorguk.ukuu.org.uk, Andrew Vasquez <andrew.vasquez@qlogic.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ferenc Wagner <wferi@niif.hu>
Subject: [patch 04/23] SCSI: qla2xxx: Skip FDMI registration on
	ISP21xx/22xx parts.
Message-ID: <20081107231521.GE1108@kroah.com>
References: <20081107224818.593212310@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-qla2xxx-skip-fdmi-registration-on-isp21xx-22xx-parts.patch"
In-Reply-To: <20081107231457.GA1108@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit 031e134e5f95233d80fb1b62fdaf5e1be587597c upstream

Firmware does not have the facilities to issue management server
IOCBs.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ferenc Wagner <wferi@niif.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla2xxx/qla_gs.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1661,6 +1661,12 @@ qla2x00_fdmi_register(scsi_qla_host_t *h
 {
 	int rval;
 
+	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
+		DEBUG2(printk("scsi(%ld): FDMI unsupported on "
+		    "ISP2100/ISP2200.\n", ha->host_no));
+		return QLA_SUCCESS;
+	}
+
 	rval = qla2x00_mgmt_svr_login(ha);
 	if (rval)
 		return rval;

-- 
