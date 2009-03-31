Return-Path: <linux-kernel-owner+w=401wt.eu-S1764632AbZCaXZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764632AbZCaXZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761089AbZCaXUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:20:36 -0400
Received: from sous-sol.org ([216.99.217.87]:33154 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761311AbZCaXUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:20:31 -0400
Message-Id: <20090331231646.301581504@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:15 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch 30/45] ARM: cumana: Fix a long standing bogon
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=arm-cumana-fix-a-long-standing-bogon.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

upstream commit: ecbf61e7357d5c7047c813edd6983902d158688c

Should be using strncmp as the data from user space may be unterminated

(Bug #8004)

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/scsi/arm/cumana_2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -318,7 +318,7 @@ cumanascsi_2_set_proc_info(struct Scsi_H
 {
 	int ret = length;
 
-	if (length >= 11 && strcmp(buffer, "CUMANASCSI2") == 0) {
+	if (length >= 11 && strncmp(buffer, "CUMANASCSI2", 11) == 0) {
 		buffer += 11;
 		length -= 11;
 

