Return-Path: <linux-kernel-owner+w=401wt.eu-S935870AbYEBSke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935870AbYEBSke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765972AbYEBSkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:40:22 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:37096 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765283AbYEBSkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:40:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=i9pN8FLs14wAsShWjPkpyaRcDg+WQWIF07YXgPFA9CibzGils7uylCW7CB32jQw6NckTKoalZdJU8Y5P81v7R1p8nosO2Apo1wNmQdFSsAOBu+oCysN1y8mkhrcMilfAn2MOAvIqk1Eby2TaskBXggMwKcTJ6pXLpmybq73rMv0=
Message-ID: <f24d23310805021140r5704cb70ubd3d11ff60344d67@mail.gmail.com>
Date: Sat, 3 May 2008 00:10:19 +0530
From: "debian developer" <debiandev@gmail.com>
To: kernelnewbies@nl.linux.org, LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors@vger.kernel.org
Subject: Resend [Patch 1/1] Trivial - kernel/time/ntp.c: fix warning
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mailer spoilt the previous send... sorry for that
Hello,

On compiling on a Xeon machine i get the following warning

kernel/time/ntp.c: In function `do_adjtimex':
kernel/time/ntp.c:328: warning: comparison of distinct pointer types
lacks a cast
kernel/time/ntp.c:329: warning: comparison of distinct pointer types
lacks a cast

This is with gcc version 3.4.3. The following patch fixes this...

--- linux-2.6.25/kernel/time/ntp.c.orig 2008-05-03 04:27:20.000000000 +0530
+++ linux-2.6.25/kernel/time/ntp.c      2008-05-03 04:45:06.000000000 +0530
@@ -325,8 +325,8 @@ int do_adjtimex(struct timex *txc)
                    * Scale the phase adjustment and
                    * clamp to the operating range.
                    */
-                   time_offset = min(time_offset, (s64)MAXPHASE *
NSEC_PER_USEC);
-                   time_offset = max(time_offset, (s64)-MAXPHASE *
NSEC_PER_USEC);
+                   time_offset = min(time_offset, (s64)(MAXPHASE *
NSEC_PER_USEC));
+                   time_offset = max(time_offset, (s64)(-MAXPHASE *
NSEC_PER_USEC));

                   /*
                    * Select whether the frequency is to be controlled
