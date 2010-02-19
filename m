Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab0BSHCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 02:02:52 -0500
Received: from suva.vyatta.com ([76.74.103.44]:51986 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab0BSHCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 02:02:49 -0500
Message-Id: <20100219070130.858707103@vyatta.com>
References: <20100219070108.670062169@vyatta.com>
User-Agent: quilt/0.46-1
Date: Thu, 18 Feb 2010 23:01:11 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] get_maintainer: quote email address with period
Content-Disposition: inline; filename=get-maintainer-vger.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Picky mail systems won't accept email addresses where recipient
has period in name; ie. David S. Miller <davemloft.net> will not work.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/scripts/get_maintainer.pl	2010-02-18 22:57:00.614708380 -0800
+++ b/scripts/get_maintainer.pl	2010-02-18 22:57:00.634708417 -0800
@@ -551,7 +551,7 @@ sub parse_email {
     $name =~ s/^\"|\"$//g;
     $address =~ s/^\s+|\s+$//g;
 
-    if ($name =~ /[^a-z0-9 \.\-]/i) {    ##has "must quote" chars
+    if ($name =~ /[^\w \-]/i) {  	 ##has "must quote" chars
 	$name =~ s/(?<!\\)"/\\"/g;       ##escape quotes
 	$name = "\"$name\"";
     }
@@ -568,7 +568,7 @@ sub format_email {
     $name =~ s/^\"|\"$//g;
     $address =~ s/^\s+|\s+$//g;
 
-    if ($name =~ /[^a-z0-9 \.\-]/i) {    ##has "must quote" chars
+    if ($name =~ /[^\w \-]/i) {          ##has "must quote" chars
 	$name =~ s/(?<!\\)"/\\"/g;       ##escape quotes
 	$name = "\"$name\"";
     }

-- 

