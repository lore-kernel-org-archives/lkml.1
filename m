Return-Path: <linux-kernel-owner+w=401wt.eu-S932094AbYD2Rds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094AbYD2Rds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759457AbYD2RWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:22:18 -0400
Received: from ns.suse.de ([195.135.220.2]:52650 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759447AbYD2RWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:22:16 -0400
Date: Tue, 29 Apr 2008 10:19:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andrew Vasquez <andrew.vasquez@qlogic.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [34/37] SCSI: qla2xxx: Correct regression in relogin code.
Message-ID: <20080429171919.GI14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-qla2xxx-correct-regression-in-relogin-code.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit: 666301e673e192c87a40e07a8357d6996b57b70f upstream


Commit 63a8651f2548c6bb5132c0b4e7dad4f57a9274db ([SCSI] qla2xxx:
Correct infinite-login-retry issue.) introduced a small
regression where a successful relogin would result in an fcport's
loop_id to be incorrectly reset to FC_NO_LOOP_ID.  Only clear-out
loopid, if retries have been 'truly' exhausted.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2357,7 +2357,7 @@ qla2x00_do_dpc(void *data)
 					} else {
 						fcport->login_retry = 0;
 					}
-					if (fcport->login_retry == 0)
+					if (fcport->login_retry == 0 && status != QLA_SUCCESS)
 						fcport->loop_id = FC_NO_LOOP_ID;
 				}
 				if (test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags))

-- 
