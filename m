Return-Path: <linux-kernel-owner+w=401wt.eu-S933494AbXLQHMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494AbXLQHMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 02:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbXLQHMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 02:12:45 -0500
Received: from smtp108.plus.mail.re1.yahoo.com ([69.147.102.71]:32703 "HELO
	smtp108.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753787AbXLQHMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 02:12:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=eY9H+zNqLVxpYYoiS9/p6dADWuy8opGasbno9+VQmuh5gjVLH8cgT4FC/Q7eG3Mf+DrsfDVhyZzrxoNHL9JCfbrxSlqik6y/i7wws823c0mCb//Ssw5XVqXYrjn6yk7GM1ISP4kPaHONZgV5+DZ9UedT6rexqhPud/Dhc8oGsnw=  ;
X-YMail-OSG: QVWad6IVM1kLvT6mqwfN1ir339l6bHcm8xDmap3uzfNE1OsE4Ik.pmKV5z9hoIg0WxWLQkRgrzyfIx8nNKWySEfWzuGZrLsgkIew0o2l62fkNvtENQ--
Date: Mon, 17 Dec 2007 08:11:05 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: apw@shadowen.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/checkpatch.pl: add a check for the patch level
	(patch -p<num>)
Message-ID: <20071217071105.GA10869@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de, apw@shadowen.org, rdunlap@xenotime.net,
	jschopp@austin.ibm.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Being bitten by this several times myself here's a quick hack for checking the patch
level of the diffs in a patch file. It works only when checkpatch.pl is called
from within the kernel tree.

---
Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

--
 scripts/checkpatch.pl |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 579f50f..b1329fc 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -653,6 +653,18 @@ sub CHK {
 	}
 }
 
+sub check_patchlevel {
+
+	my ($path) = @_;
+	$path =~ s![^/]*/!!;
+
+	if ($tree) {
+		if (!stat($path)) {
+			WARN("Check the patchlevel (hint: patch option -p)");
+		}
+	}
+}
+
 sub process {
 	my $filename = shift;
 	my @lines = @_;
@@ -713,10 +725,16 @@ sub process {
 #extract the filename as it passes
 		if ($line=~/^\+\+\+\s+(\S+)/) {
 			$realfile=$1;
+
+			if ($realfile) {
+				check_patchlevel($realfile);
+			}
+
 			$realfile =~ s@^[^/]*/@@;
 			$in_comment = 0;
 			next;
 		}
+
 #extract the line range in the file after the patch is applied
 		if ($line=~/^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@/) {
 			$is_patch = 1;

-- 
Regards/Gruﬂ,
    Boris.
