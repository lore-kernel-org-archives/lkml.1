Return-Path: <linux-kernel-owner+w=401wt.eu-S936544AbYEURYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936544AbYEURYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936150AbYEURUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:20:25 -0400
Received: from ns.km23152-01.keymachine.de ([87.118.114.125]:57696 "EHLO
	km23152-01.keymachine.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S936328AbYEURUX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:20:23 -0400
X-Greylist: delayed 1479 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2008 13:20:23 EDT
Subject: [PATCH 2.6.26-rc3] xfrm: Installing NULL encryption IPSec SAs fails
From: Martin Willi <martin@strongswan.org>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Wed, 21 May 2008 11:55:06 -0500
Message-Id: <1211388907.26331.10.camel@martin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8BIT
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed May 21 18:56:14 2008
X-DSPAM-Confidence: 0.9982
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4834542e325177255720262
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿Installing NULL encryption IPSec SAs works using the .compat name
"cipher_null", but fails with the .name "ecp(cipher_null)" due the
missing check in key length verification. 
﻿
Signed-off-by: Martin Willi <martin@strongswan.org>

--- a/net/xfrm/xfrm_user.c 2008-05-21 11:34:56.000000000 -0500
+++ b/net/xfrm/xfrm_user.c 2008-05-21 11:20:08.000000000 -0500
@@ -57,6 +57,7 @@
 
        case XFRMA_ALG_CRYPT:
                if (!algp->alg_key_len &&
+                   strcmp(algp->alg_name, "ecb(cipher_null)") != 0 &&
                    strcmp(algp->alg_name, "cipher_null") != 0)
                        return -EINVAL;
                break;



