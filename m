Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbYAMWeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbYAMWeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 17:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbYAMWeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 17:34:03 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:7525 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbYAMWeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 17:34:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=hM3EUM4femv3PhsKipk6IClOvT6Xh4MmM7wNGwp/hpngBFe3xntU6qgrpqTMyG2vI+0nEdKO0S64D3MwQZJAFmfvBv5ayyZZAVj7A693v8U0TZhIKAwAwFQS29W5I3svSsz3iRCNT/6KrPXRoew2ig77DUIOZwpiPLfCWX5aNDY=
Date: Sun, 13 Jan 2008 23:34:05 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, apw@shadowen.org
Subject: checkpatch: add filename before the summary line
Message-ID: <20080113233405.5fcdaff5@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the patch applied the output of checkpatch.pl is as follow:
./arch/arm/mach-footbridge/ebsa285-pci.c 
total: 1 errors, 0 warnings, 48 lines checked

Adding the file name allowed me to collects stats running:
	find . -name *.c |xargs ./scripts/checkpatch.pl --file |grep -B 1 total
but I though it might me useful for other purposes to add the file name
after the list of errors and warnings and before the summary,
when the list is long I find handy to print out the filename as a reminder.
   
Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 579f50f..079c73c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1580,6 +1580,7 @@ sub process {
 
 	print report_dump();
 	if ($summary) {
+		print "$filename \n";
 		print "total: $cnt_error errors, $cnt_warn warnings, " .
 			(($check)? "$cnt_chk checks, " : "") .
 			"$cnt_lines lines checked\n";
