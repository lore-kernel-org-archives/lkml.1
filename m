Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbZGMOSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbZGMOSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 10:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZGMOSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 10:18:21 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:45750 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZGMOSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 10:18:20 -0400
Date: Mon, 13 Jul 2009 08:18:19 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix markup_oops to work with 32-bit userspace on a 64-bit
	kernel
Message-ID: <20090713141819.GG24310@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A 32-bit perl can't handle 64-bit addresses without using the BigInt package.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/scripts/markup_oops.pl b/scripts/markup_oops.pl
index 528492b..8977401 100644
--- a/scripts/markup_oops.pl
+++ b/scripts/markup_oops.pl
@@ -1,6 +1,7 @@
 #!/usr/bin/perl
 
 use File::Basename;
+use Math::BigInt;
 
 # Copyright 2008, Intel Corporation
 #
@@ -172,8 +173,8 @@ while (<STDIN>) {
 	parse_x86_regs($line);
 }
 
-my $decodestart = hex($target) - hex($func_offset);
-my $decodestop = hex($target) + 8192;
+my $decodestart = Math::BigInt->from_hex("0x$target") - Math::BigInt->from_hex("0x$func_offset");
+my $decodestop = Math::BigInt->from_hex("0x$target") + 8192;
 if ($target eq "0") {
 	print "No oops found!\n";
 	print "Usage: \n";

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
