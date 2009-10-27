Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbZJ0HFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbZJ0HFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756417AbZJ0HFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:05:49 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:62250 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802AbZJ0HFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:05:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :x-operating-system:user-agent;
        b=X7y9sDjr0K8cGTFEh9k9oeHAF+gTtTaeUnsAaxgaJVLG5YINUm5lX2gshNpYk6Tot6
         wXyN6ZoKluC7ynAcLNpHKHhd3cJVzyQvv/G4Vnb2DNi5z/JF+UGKAlyJbCGLfcPbqw9G
         3ABL9hWUA29+8U7wg0agCmXyeu7Uj7X4wO6bY=
Date: Tue, 27 Oct 2009 15:05:40 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] tracing: recordmcount.pl Remove the redundant code 
Message-ID: <20091027070540.GI22032@uhli>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org
References: <20091027065421.GA22032@uhli>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027065421.GA22032@uhli>
X-Operating-System: Linux uhli 2.6.28-11-generic 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d0aa71d523b6315fd3ea0ee66fddb020a625856f Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi@gmail.com>
Date: Tue, 27 Oct 2009 13:28:53 +0800
Subject: [PATCH] tracing: recordmcount.pl Remove the redundant code

If an object file has some local symbols and objcopy doesn't support local
reference, we have exited before the real work starts. So remove the redundant
check in update_funcs.

Signed-off-by: Li Hong <lihong.hi@gmail.com>

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 867c24a..ff3a9eb 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -353,14 +353,7 @@ sub update_funcs
     return unless ($ref_func and @offsets);
 
     # is this function static? If so, note this fact.
-    if (defined $locals{$ref_func}) {
-
-	# only use locals if objcopy supports globalize-symbols
-	if (!$can_use_local) {
-	    return;
-	}
-	$convert{$ref_func} = 1;
-    }
+    $convert{$ref_func} = 1 if $locals{$ref_func}; 
 
     # Loop through all the mcount caller offsets and print a reference
     # to the caller based from the ref_func.
-- 
1.6.0.4

