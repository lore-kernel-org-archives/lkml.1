Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbZA1EGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbZA1EGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 23:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZA1EGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 23:06:42 -0500
Received: from smtp105.prem.mail.sp1.yahoo.com ([98.136.44.60]:33131 "HELO
	smtp105.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752182AbZA1EGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 23:06:42 -0500
X-YMail-OSG: bxziDmQVM1mUXgr9s50SyqY3LRDXHuGwQ8NRFYaueVwc9gWtpY6aQeGl9wKn1szoY6dkmHfMGnmJIb.qGcEnOzMEmhnDGrp92K70wP3Sos5l.Y4NE6x_cxkY38UhjxycamrhnmcV3cBLWdZ_0NnbsMIxuerdCzwt7zI3qzMHh7tNW9gTlQ4awdbj5eHDSBbEFqmxvF8SMaYH6gvmVNAeBvD6b.S0njZ8LhVP8GTAz8pL0QHHwAwkhUs-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <497FD9CD.1090202@schaufler-ca.com>
Date: Tue, 27 Jan 2009 20:06:37 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: LKLM <linux-kernel@vger.kernel.org>,
       LSM <linux-security-module@vger.kernel.org>, jmorris@namei.org
CC: "Ahmed S. Darwish" <darwish.07@gmail.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: [PATCH] smackfs load append mode fix - resend unmundged.
Content-Type: text/plain; charset=ISO-8859-1
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


