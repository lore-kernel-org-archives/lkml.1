Return-Path: <linux-kernel-owner+w=401wt.eu-S1761642AbXKNXpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642AbXKNXpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 18:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbXKNXpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 18:45:30 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:48488 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbXKNXpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 18:45:30 -0500
Date: Wed, 14 Nov 2007 15:44:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Willy Tarreau <w@1wt.eu>, "Julio M. Merino Vidal" <jmerino@ac.upc.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove bashisms from scripts/extract-ikconfig
Message-Id: <20071114154426.2443eb50.randy.dunlap@oracle.com>
In-Reply-To: <alpine.DEB.0.99.0706092211210.8312@foobar-g4>
References: <alpine.DEB.0.99.0706092117580.8312@foobar-g4>
	<2F6FAF9E-8997-4FC1-8310-4A7D17C659E4@ac.upc.edu>
	<alpine.DEB.0.99.0706092132200.8312@foobar-g4>
	<20070609195333.GR943@1wt.eu>
	<alpine.DEB.0.99.0706092211210.8312@foobar-g4>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian,

Does the patch below satisfy your needs here?

Thanks,
~Randy

---

From: Christian Kujau <lists@nerdbynature.de>

Remove bashisms from scripts/extract-ikconfig (function and
typeset words).

Tested under dash v0.5.4 (latest/current).

Signed-off-by: Christian Kujau <lists@nerdbynature.de>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/extract-ikconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.24-rc2-git2.orig/scripts/extract-ikconfig
+++ linux-2.6.24-rc2-git2/scripts/extract-ikconfig
@@ -8,8 +8,9 @@ test -e $binoffset || cc -o $binoffset .
 
 IKCFG_ST="0x49 0x4b 0x43 0x46 0x47 0x5f 0x53 0x54"
 IKCFG_ED="0x49 0x4b 0x43 0x46 0x47 0x5f 0x45 0x44"
-function dump_config {
-    typeset file="$1"
+
+dump_config() {
+    file="$1"
 
     start=`$binoffset $file $IKCFG_ST 2>/dev/null`
     [ "$?" != "0" ] && start="-1"
@@ -27,7 +28,6 @@ function dump_config {
     exit 0
 }
 
-
 usage()
 {
 	echo "  usage: extract-ikconfig [b]zImage_filename"

