Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbZKWLF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbZKWLF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbZKWLF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:05:57 -0500
Received: from znsun1.ifh.de ([141.34.1.16]:62072 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496AbZKWLF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:05:56 -0500
Date: Mon, 23 Nov 2009 12:05:57 +0100 (CET)
From: Patrick Boettcher <pboettcher@kernellabs.com>
X-X-Sender: pboettch@pub1.ifh.de
To: linux-kernel@vger.kernel.org
cc: Martin Habets <errandir_news@mph.eclipse.co.uk>
Subject: PATCH [2/2] - CHECKSTACK: simplify text-formatting for displaying
 the stacksize
In-Reply-To: <alpine.LRH.2.00.0911231148441.14263@pub1.ifh.de>
Message-ID: <alpine.LRH.2.00.0911231205080.14263@pub1.ifh.de>
References: <alpine.LRH.2.00.0911231148441.14263@pub1.ifh.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Report: ALL_TRUSTED,AWL,BAYES_00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Patrick Boettcher <pboettcher@kernellabs.com>

----
diff --git a/tools/checkstack.pl b/tools/checkstack.pl
index e0af9c7..4fed8c7 100755
--- a/tools/checkstack.pl
+++ b/tools/checkstack.pl
@@ -139,7 +139,7 @@ while (my $line = <STDIN>) {
  			$size += 0x80000000;
  			$size += 0x80000000;
  		}
-		next if ($size > 0x10000000);
+		next if ($size > 0x10000000) || ($size < 100);

  		next if $line !~ m/^($xs*)/;
  		my $addr = $1;
@@ -147,13 +147,7 @@ while (my $line = <STDIN>) {
  		$addr = "0x$addr";

  		my $intro = "$addr $func [$file]:";
-		my $padlen = 56 - length($intro);
-		while ($padlen > 0) {
-			$intro .= '	';
-			$padlen -= 8;
-		}
-		next if ($size < 100);
-		push @stack, "$intro$size\n";
+		push @stack, sprintf("%-64s %d\n", $intro, $size);
  	}
  	elsif (defined $dre && $line =~ m/$dre/) {
  		my $size = "Dynamic ($1)";
@@ -164,12 +158,7 @@ while (my $line = <STDIN>) {
  		$addr = "0x$addr";

  		my $intro = "$addr $func [$file]:";
-		my $padlen = 56 - length($intro);
-		while ($padlen > 0) {
-			$intro .= '	';
-			$padlen -= 8;
-		}
-		push @stack, "$intro$size\n";
+		push @stack, sprintf("%-64s %d\n", $intro, $size);
  	}
  }

