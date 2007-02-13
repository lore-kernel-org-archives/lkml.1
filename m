Return-Path: <linux-kernel-owner+w=401wt.eu-S1750835AbXBMTjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750835AbXBMTjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 14:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbXBMTjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 14:39:24 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:20275 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbXBMTjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 14:39:24 -0500
Date: Tue, 13 Feb 2007 11:35:22 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>
Subject: [PATCH v2] kernel-doc: include struct short description in title
 output
Message-Id: <20070213113522.8490ddaf.randy.dunlap@oracle.com>
In-Reply-To: <1171394317.10344.111.camel@johannes.berg>
References: <20070213111042.e10a4234.randy.dunlap@oracle.com>
	<1171394317.10344.111.camel@johannes.berg>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yup, that fixes it for structs. I guess I forgot to mention this earlier
> because I didn't notice it until now... the same bug exists for
> functions as well.

updated patch.  Thanks.
---

From: Randy Dunlap <randy.dunlap@oracle.com>

Output of a function or struct in html mode needs to include the short
description from the function/struct name line in the output title line.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.20-git7.orig/scripts/kernel-doc
+++ linux-2.6.20-git7/scripts/kernel-doc
@@ -452,7 +452,7 @@ sub output_struct_html(%) {
     my %args = %{$_[0]};
     my ($parameter);
 
-    print "<h2>".$args{'type'}." ".$args{'struct'}."</h2>\n";
+    print "<h2>".$args{'type'}." ".$args{'struct'}. " - " .$args{'purpose'}."</h2>\n";
     print "<b>".$args{'type'}." ".$args{'struct'}."</b> {<br>\n";
     foreach $parameter (@{$args{'parameterlist'}}) {
 	if ($parameter =~ /^#/) {
@@ -498,8 +498,8 @@ sub output_function_html(%) {
     my %args = %{$_[0]};
     my ($parameter, $section);
     my $count;
-    print "<h2>Function</h2>\n";
 
+    print "<h2>" .$args{'function'}." - ".$args{'purpose'}."</h2>\n";
     print "<i>".$args{'functiontype'}."</i>\n";
     print "<b>".$args{'function'}."</b>\n";
     print "(";
