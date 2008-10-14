Return-Path: <linux-kernel-owner+w=401wt.eu-S1751438AbYJNNSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbYJNNSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 09:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbYJNNSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 09:18:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:16677 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbYJNNSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 09:18:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding:sender;
        b=E3X055oxlJHRursv9wYe6iYOXc8ZD8h6z/q6R0WI0/2ZW163yzB5YgEe52ab6Dc26y
         i3+NsnvvNBzn9kRoyamFAdZWSG2j8yH4X0O0vEK/DrhBJTZtpSWzGs6126FozWL2AAN0
         sUJBRvFGlwz3GT8sO0AhoZtxxIELkcBlOlUQg=
Message-ID: <48F49C0F.7050705@tuffmail.co.uk>
Date: Tue, 14 Oct 2008 14:18:07 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: =?ISO-8859-1?Q?=22Fr=E9d=E9ric_Weisbecker=22?= <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] fastboot: fix bootgraph.pl to run with "use strict"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a perl novice, I would prefer to have the benefit of the interpreters'
wisdom.  It turns out there were already some warnings, so let's fix them.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

diff --git a/scripts/bootgraph.pl b/scripts/bootgraph.pl
index 5e7316e..ea2b079 100644
--- a/scripts/bootgraph.pl
+++ b/scripts/bootgraph.pl
@@ -37,7 +37,10 @@
 # 	dmesg | perl scripts/bootgraph.pl > output.svg
 #
 
-my %start, %end;
+use strict;
+
+my %start;
+my %end;
 my $done = 0;
 my $maxtime = 0;
 my $firsttime = 100;
@@ -105,12 +108,14 @@ my $threshold = ($maxtime - $firsttime) / 60.0;
 my $stylecounter = 0;
 my %rows;
 my $rowscount = 1;
+my $key;
+my $value;
 while (($key,$value) = each %start) {
 	my $duration = $end{$key} - $start{$key};
 
 	if ($duration >= $threshold) {
-		my $s, $s2, $e, $y;
-		$pid = $pids{$key};
+		my ($s, $s2, $e, $w, $y, $y2, $style);
+		my $pid = $pids{$key};
 
 		if (!defined($rows{$pid})) {
 			$rows{$pid} = $rowscount;
@@ -140,9 +145,9 @@ while (($key,$value) = each %start) {
 my $time = $firsttime;
 my $step = ($maxtime - $firsttime) / 15;
 while ($time < $maxtime) {
-	my $s2 = ($time - $firsttime) * $mult;
+	my $s3 = ($time - $firsttime) * $mult;
 	my $tm = int($time * 100) / 100.0;
-	print "<text transform=\"translate($s2,89) rotate(90)\">$tm</text>\n";
+	print "<text transform=\"translate($s3,89) rotate(90)\">$tm</text>\n";
 	$time = $time + $step;
 }
 


