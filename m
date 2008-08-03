Return-Path: <linux-kernel-owner+w=401wt.eu-S1759926AbYHCVI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759926AbYHCVI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 17:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbYHCVIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 17:08:20 -0400
Received: from vs13.mail.saunalahti.fi ([195.197.172.103]:57465 "EHLO
	vs13.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956AbYHCVIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 17:08:19 -0400
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Aug 2008 17:08:19 EDT
Message-ID: <48961C6E.50000@iki.fi>
Date: Mon, 04 Aug 2008 00:00:30 +0300
From: Erkki Lintunen <ebirdie@iki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: rdunlap@xenotime.net
CC: linux-kernel@vger.kernel.org
Subject: bugfix for scripts/patch-kernel in 2.6 sublevel stepping
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

scripts/patch-kernel script can't patch a tree, say, from 2.6.25 to 
2.6.26.1, because of a wrong comparison in context of patching 2.6.x 
base. Following patch has a fix for it.

Erkki

--- linux-2.6.26/scripts/patch-kernel   2008-04-27 19:49:14.000000000 +0300
+++ linux-2.6.26.1/scripts/patch-kernel 2008-08-03 23:34:00.000000000 +0300
@@ -213,6 +213,7 @@
  if [ $stopvers != "default" ]; then
         STOPSUBLEVEL=`echo $stopvers | cut -d. -f3`
         STOPEXTRA=`echo $stopvers | cut -d. -f4`
+       STOPFULLVERSION=${stopvers%%.$STOPEXTRA}
         #echo "#___STOPSUBLEVEL=/$STOPSUBLEVEL/, STOPEXTRA=/$STOPEXTRA/"
  else
         STOPSUBLEVEL=9999
@@ -249,7 +250,7 @@
  do
      CURRENTFULLVERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL"
      EXTRAVER=
-    if [ $stopvers = $CURRENTFULLVERSION ]; then
+    if [ $STOPFULLVERSION = $CURRENTFULLVERSION ]; then
          echo "Stopping at $CURRENTFULLVERSION base as requested."
          break
      fi

