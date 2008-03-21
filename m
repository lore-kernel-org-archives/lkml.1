Return-Path: <linux-kernel-owner+w=401wt.eu-S932298AbYCUXNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298AbYCUXNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763147AbYCUWwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:52:33 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:41338 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207AbYCUWw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:52:28 -0400
Message-Id: <20080321224441.028170945@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:52 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Krzysztof Oledzki <olel@ans.pl>, Krzysztof Piotr Oledzki <ole@ans.pl>,
       Eric Moore <Eric.Moore@lsi.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 62/76] SCSI: mpt fusion: dont oops if NumPhys==0
Content-Disposition: inline; filename=scsi-mpt-fusion-don-t-oops-if-numphys-0.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Krzysztof Oledzki <olel@ans.pl>

Don't oops if NumPhys==0, instead return -ENODEV.
This patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=9909

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
Acked-by: Eric Moore <Eric.Moore@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/message/fusion/mptsas.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1699,6 +1699,11 @@ mptsas_sas_expander_pg0(MPT_ADAPTER *ioc
 	if (error)
 		goto out_free_consistent;
 
+	if (!buffer->NumPhys) {
+		error = -ENODEV;
+		goto out_free_consistent;
+	}
+
 	/* save config data */
 	port_info->num_phys = buffer->NumPhys;
 	port_info->phy_info = kcalloc(port_info->num_phys,

-- 
