Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbZJ1FHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbZJ1FHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 01:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757354AbZJ1FHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 01:07:48 -0400
Received: from mail-px0-f180.google.com ([209.85.216.180]:63322 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353AbZJ1FHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 01:07:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :x-operating-system:user-agent;
        b=hp1+6Khmyl1y/a7UGi/qJH8aMaOUQsyAfGrqo3eTgru1bxCh/mkUsZI1k+BSa/AwCl
         Vol449aj3IFMP76o4FTSibSbh6N1wLbloH00fHdjB6e3ugffUTkjtdbvWXdzRJgWkB0a
         rANatXZfpjITp8aA+CaEK/ziQ2ty2xPbUIllY=
Date: Wed, 28 Oct 2009 13:07:43 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 8/8] tracing: recordmcount.pl Die if we use a weak
	function as reference
Message-ID: <20091028050743.GH30758@uhli>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org
References: <20091028045532.GA30036@uhli>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028045532.GA30036@uhli>
X-Operating-System: Linux uhli 2.6.28-11-generic 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From fef57ba56001830adaeea6aef479c623e3bce6c6 Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi@gmail.com>
Date: Tue, 27 Oct 2009 13:25:39 +0800
Subject: [PATCH] tracing: recordmcount.pl Die if we use a weak function as reference

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 scripts/recordmcount.pl |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index ffb1123..0f733c9 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -348,15 +348,11 @@ sub update_funcs
 {
     return unless ($ref_func and @offsets);
 
-    # A section only had a weak function, to represent it.
-    # Unfortunately, a weak function may be overwritten by another
-    # function of the same name, making all these offsets incorrect.
-    # To be safe, we simply print a warning and bail.
+    # Sanity check on weak function. A weak function may be overwritten by 
+    # another function of the same name, making all these offsets incorrect.
     if (defined $weak{$ref_func}) {
-	print STDERR
-	    "$inputfile: WARNING: referencing weak function" .
-	    " $ref_func for mcount\n";
-	return;
+        die "$inputfile: ERROR: referencing weak function" .
+            " $ref_func for mcount\n";
     }
 
     # is this function static? If so, note this fact.
-- 
1.6.0.4

