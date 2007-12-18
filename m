Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbXLRFsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbXLRFsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 00:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbXLRFs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 00:48:26 -0500
Received: from smtp112.plus.mail.re1.yahoo.com ([69.147.102.75]:28523 "HELO
	smtp112.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1764623AbXLRFsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 00:48:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=V8+ryltLq0aSvILwXVQ8dISC4PspNxxhuH/6SyEElJJKsurO88B/YuY4SrC9Bf1QI2Ng2waJt/zWWLFfvBPo6DwyiVaGDH1LIHVFb+Wlnj61f14/4P3xtlfaOmivsNStr2b9LGFktaM4g9SNTXK65uXXMV7p0IEcIoSJh9f9cEo=  ;
X-YMail-OSG: y8aQ9oEVM1nNNHODilbB3gii6Erpx8FdOQveKqOr0HeTndDhuZONJdpSaMl3N_HU1bawqJKD7qYW7iioS8c0sRenj.2_5SjUMhKt_wnhmg4wwBkYIg--
Date: Tue, 18 Dec 2007 06:46:41 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: apw@shadowen.org, rdunlap@xenotime.net, jschopp@austin.ibm.com,
       linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scripts/checkpatch.pl: add a check for the patch level
	(patch -p<num>)
Message-ID: <20071218054641.GA15994@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de, apw@shadowen.org, rdunlap@xenotime.net,
	jschopp@austin.ibm.com, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20071217071105.GA10869@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071217071105.GA10869@gollum.tnic>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 08:11:05AM +0100, Borislav Petkov wrote:

A slightly microoptimized version 1.1:

---
From: Borislav Petkov <bbpetkov@yahoo.de>


Check the patch level of the single hunks in a patch file, however only when
checkpatch.pl is called from within the kernel tree.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
--

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 579f50f..3eda27b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -653,6 +653,18 @@ sub CHK {
 	}
 }
 
+sub check_patchlevel {
+
+	if ($tree) {
+		my ($path) = @_;
+		$path =~ s![^/]*/!!;
+
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
