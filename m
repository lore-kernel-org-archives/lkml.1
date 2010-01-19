Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993Ab0ASUM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab0ASUM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 15:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268Ab0ASUM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 15:12:58 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:39921 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab0ASUM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 15:12:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=lS9IABNrXou9sDn1QxRqRw3ega6m3c9gc2DuwaQ5YKf8b1W2oU7Pst+t3tMq8G/Nyg
         ImM1E5peMRuF6LfPYa2jSNY/0kMzQVWgtQnH8YHKLpDBhjVBzzI0vxNKA359CM93vPS0
         XAqf30GozgwnPKgYeRWFu6uuVV4o0mFCT0BcI=
Message-ID: <4B56136F.3070709@gmail.com>
Date: Tue, 19 Jan 2010 21:17:51 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Jing Huang <huangj@brocade.com>, linux-scsi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] bfa: comparison with wrong msgtag in bfa_pport_isr()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compare it with the disable msgtag.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Was this maybe intended? otherwise in case BFI_PPORT_I2H_ENABLE_RSP:
the same code is executed. Please review.

diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
index aef648b..f00d07b 100644
--- a/drivers/scsi/bfa/bfa_fcport.c
+++ b/drivers/scsi/bfa/bfa_fcport.c
@@ -918,7 +918,7 @@ bfa_pport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
 		break;
 
 	case BFI_PPORT_I2H_DISABLE_RSP:
-		if (pport->msgtag == i2hmsg.enable_rsp->msgtag)
+		if (pport->msgtag == i2hmsg.disable_rsp->msgtag)
 			bfa_sm_send_event(pport, BFA_PPORT_SM_FWRSP);
 		break;
 
