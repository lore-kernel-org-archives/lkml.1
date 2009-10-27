Return-Path: <linux-kernel-owner+w=401wt.eu-S1756493AbZJ0HEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbZJ0HEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbZJ0HEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:04:41 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:37652 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437AbZJ0HEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:04:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :x-operating-system:user-agent;
        b=rC36hF88o25erWvfkO22enScyH7sOvRpB+WIIbFUXbrRa8OB0ATDxO97dlirkBdFYU
         zHpj0ivDoq9kcyxuADGuoWwjelGRHQaOakGAOHP5gVmhqTBUcG+EmnrOXFCVLfzFBgD9
         H0zMBeDLbmhK6JqbBivoEzzuw85C5lM99V5JE=
Date: Tue, 27 Oct 2009 15:04:21 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] tracing: recordmcount.pl We won't use weak function as
	reference, remove the check
Message-ID: <20091027070421.GH22032@uhli>
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

>From 4433c78ca3c0319fd75d1fd6d64929fa101e38a4 Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi@gmail.com>
Date: Tue, 27 Oct 2009 13:25:39 +0800
Subject: [PATCH] tracing: recordmcount.pl We won't use weak function as reference, remove the check

Signed-off-by: Li Hong <lihong.hi@gmail.com>

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 490b4cd..867c24a 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -352,17 +352,6 @@ sub update_funcs
 {
     return unless ($ref_func and @offsets);
 
-    # A section only had a weak function, to represent it.
-    # Unfortunately, a weak function may be overwritten by another
-    # function of the same name, making all these offsets incorrect.
-    # To be safe, we simply print a warning and bail.
-    if (defined $weak{$ref_func}) {
-	print STDERR
-	    "$inputfile: WARNING: referencing weak function" .
-	    " $ref_func for mcount\n";
-	return;
-    }
-
     # is this function static? If so, note this fact.
     if (defined $locals{$ref_func}) {
 
-- 
1.6.0.4

