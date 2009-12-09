Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbZLIGvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbZLIGvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 01:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbZLIGvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 01:51:14 -0500
Received: from mail.perches.com ([173.55.12.10]:1029 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784AbZLIGvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 01:51:13 -0500
Subject: [PATCH] checkpatch.pl: Warn on pr_<level> or dev_<level> with
 KERN_<level>
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andy Whitcroft <apw@canonical.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Herrmann <herrmann.der.user@googlemail.com>
In-Reply-To: <20091209060538.GD2512@elte.hu>
References: <200912082259.nB8Mx2ih008207@hera.kernel.org>
	 <1260313613.27677.169.camel@Joe-Laptop.home>
	 <20091209060538.GD2512@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 22:51:19 -0800
Message-ID: <1260341479.27677.193.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 07:05 +0100, Ingo Molnar wrote:
> ( Andy: i suspect checkpatch could also grow a new warning perhaps, the
>   '\<pr_.*(KERN_.*' pattern will i suspect pinpoint something fishy in 
>   most cases. )

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bc4114f..ffd8210 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1832,6 +1832,12 @@ sub process {
 			}
 		}
 
+# pr_<level> and dev_<level> should not use KERN_* levels
+
+		if ($line =~ /\b(pr_|dev_)[a-z]+.*KERN_/) {
+			WARN("pr_<level>() and dev_<level> should not include KERN_ facility level\n" . $herecurr);
+		}
+
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
 		if (($line=~/$Type\s*$Ident\(.*\).*\s{/) and


