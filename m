Return-Path: <linux-kernel-owner+w=401wt.eu-S1762775AbYCUWqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762775AbYCUWqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762297AbYCUWpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:45:49 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34674 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762187AbYCUWps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:45:48 -0400
Message-Id: <20080321224355.272885001@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:17 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       FUJITA Tomonori <tomof@acm.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mark Salyzyn <Mark_Salyzyn@adaptec.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 27/76] SCSI ips: fix data buffer accessors conversion bug
Content-Disposition: inline; filename=scsi-ips-fix-data-buffer-accessors-conversion-bug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: FUJITA Tomonori <tomof@acm.org>

This fixes a bug that can't handle a passthru command with more than
two sg entries.

Big thanks to Tim Pepper for debugging the problem.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/ips.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1580,7 +1580,7 @@ ips_make_passthru(ips_ha_t *ha, struct s
 	METHOD_TRACE("ips_make_passthru", 1);
 
         scsi_for_each_sg(SC, sg, scsi_sg_count(SC), i)
-                length += sg[i].length;
+		length += sg->length;
 
 	if (length < sizeof (ips_passthru_t)) {
 		/* wrong size */

-- 
