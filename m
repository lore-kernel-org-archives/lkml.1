Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbYDBN3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbYDBN3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 09:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbYDBN2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 09:28:55 -0400
Received: from nbd.name ([88.198.39.176]:38223 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735AbYDBN2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 09:28:55 -0400
X-Greylist: delayed 2315 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2008 09:28:54 EDT
Message-ID: <47F380FD.6010605@openwrt.org>
Date: Wed, 02 Apr 2008 14:50:05 +0200
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix unportability in gen_initramfs_list.sh
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a Mac OS X machine the output of ls -l is different from a standard 
Linux machine. Use readlink instead of parsing a hardcoded field number 
from the ls output.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>

diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
index 684fb9c..5f3415f 100644
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -135,7 +135,7 @@ parse() {
    			str="${ftype} ${name} ${str} ${dev} ${maj} ${min}"
    			;;
    		"slink")
-			local target=`field 11 $(LC_ALL=C ls -l "${location}")`
+			local target=`readlink "${location}"`
    			str="${ftype} ${name} ${target} ${str}"
    			;;
    		*)


