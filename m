Return-Path: <linux-kernel-owner+w=401wt.eu-S1763863AbYCUWvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763863AbYCUWvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759021AbYCUWqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:46:39 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34773 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762794AbYCUWqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:46:36 -0400
Message-Id: <20080321224454.847882820@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:44:04 -0700
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
       Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 74/76] SCSI advansys: Fix bug in AdvLoadMicrocode
Content-Disposition: inline; filename=scsi-advansys-fix-bug-in-advloadmicrocode.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Matthew Wilcox <matthew@wil.cx>

buf[i] can be up to 0xfd, so doubling it and assigning the result to an
unsigned char truncates the value.  Just use an unsigned int instead;
it's only a temporary.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/advansys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -6439,7 +6439,7 @@ static int AdvLoadMicrocode(AdvPortAddr 
 			i += 2;
 			len += 2;
 		} else {
-			unsigned char off = buf[i] * 2;
+			unsigned int off = buf[i] * 2;
 			unsigned short word = (buf[off + 1] << 8) | buf[off];
 			AdvWriteWordAutoIncLram(iop_base, word);
 			len += 2;

-- 
