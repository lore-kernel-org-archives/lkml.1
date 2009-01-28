Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbZA1ED0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbZA1ED0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 23:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZA1EDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 23:03:17 -0500
Received: from smtp110.prem.mail.sp1.yahoo.com ([98.136.44.55]:39973 "HELO
	smtp110.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752180AbZA1EDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 23:03:17 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2009 23:03:17 EST
X-YMail-OSG: L5kNYjcVM1l7YA1UhvwV3SMe5Y0yyjQdh6BLVM3HLxzCoLCcDqHM9lSk3TmalK.MA89yI2fCzIBZ_nlJZxqDXxO_Rgc.DGgaagbwRUkesLnvxPiJw0jzm4mdLJi21STP.6M6Y1j5EEmXTstWgX87DG1uMQYBSUCFS8vKUvEyH.PPklexv4VkK6Q1fK0b3Y.VJMSOFUSbN_KlW7j.1KZ_ZRlgIRdpAFvxYUhNq7GZUN2dpCRHmsjrlZ4-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <497FD76E.1060909@schaufler-ca.com>
Date: Tue, 27 Jan 2009 19:56:30 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: LKLM <linux-kernel@vger.kernel.org>,
       LSM <linux-security-module@vger.kernel.org>, jmorris@namei.org
CC: "Ahmed S. Darwish" <darwish.07@gmail.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: [PATCH] smackfs load append mode fix
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

Given just how hard it is to find the code that uses MAY_APPEND
it's probably not a big surprise that this went unnoticed for so
long. The Smack rules loading code is incorrectly setting the
MAY_READ bit when MAY_APPEND is requested.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---

 security/smack/smackfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -uprN -X linux-2.6/Documentation/dontdiff linux-2.6/security/smack/smackfs.c linux-0112/security/smack/smackfs.c
--- linux-2.6/security/smack/smackfs.c	2009-01-09 21:43:42.000000000 -0800
+++ linux-0112/security/smack/smackfs.c	2009-01-19 11:05:09.000000000 -0800
@@ -334,7 +334,7 @@ static ssize_t smk_write_load(struct fil
 		break;
 	case 'a':
 	case 'A':
-		rule.smk_access |= MAY_READ;
+		rule.smk_access |= MAY_APPEND;
 		break;
 	default:
 		goto out;

