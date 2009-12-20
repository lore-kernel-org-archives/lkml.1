Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007AbZLTToS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbZLTToS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 14:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbZLTToR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 14:44:17 -0500
Received: from mail.perches.com ([173.55.12.10]:1344 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbZLTToR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 14:44:17 -0500
Subject: [PATCH] scripts/checkpatch.pl: Add WARN on printk format split on
 multiple lines
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Andy Whitcroft <apw@canonical.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, peterz@infradead.org, efault@gmx.de,
       akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <20091220191531.GA17878@elte.hu>
References: <1261315437.4314.6.camel@laptop>
	 <tip-3df0fc5b2e9d8092dcaeb5ae0b6753d85c851d66@git.kernel.org>
	 <1261335300.30458.209.camel@Joe-Laptop.home>
	 <20091220191531.GA17878@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Dec 2009 11:44:15 -0800
Message-ID: <1261338255.30458.222.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 20:15 +0100, Ingo Molnar wrote:
> Checkpatch should warn about printk 
> lines that end with a '"', those are almost always a sign of some ill-advised 
> break-the-string artifact.

Perhaps something like this:

diff from Andy Whitcroft's testing script,
where logFunctions is defined.
http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

--- a/scripts/checkpatch.pl-testing	2009-12-20 11:35:28.000000000 -0800
+++ b/scripts/checkpatch.pl-testing	2009-12-20 11:35:46.000000000 -0800
@@ -1398,6 +1398,11 @@
 			WARN("line over 80 characters\n" . $herecurr);
 		}
 
+#Logging function format split over multiple lines
+		if ($line =~ /^\+\s*$logFunctions.*"\s*$/) {
+			WARN("Don't split logging function format\n" . $herecurr);
+		}
+
 # check for adding lines without a newline.
 		if ($line =~ /^\+/ && defined $lines[$linenr] && $lines[$linenr] =~ /^\\ No newline at end of file/) {
 			WARN("adding a line without newline at end of file\n" . $herecurr);


