Return-Path: <linux-kernel-owner+w=401wt.eu-S1763375AbYCGWLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763375AbYCGWLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 17:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761076AbYCGWLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 17:11:32 -0500
Received: from plexity.net ([206.123.115.38]:33811 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760737AbYCGWLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 17:11:31 -0500
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Mar 2008 17:11:31 EST
Date: Fri, 7 Mar 2008 14:03:52 -0800
From: Deepak Saxena <dsaxena@plexity.net>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH-stable] Make 2.6.24.y headers_install work again
Message-ID: <20080307220352.GA10387@plexity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This reverts commit 5fb7ba76544d95bfa05199f7394a442de5660be7.

>git-checkout v2.6.24.3
HEAD is now at 927684b... Linux 2.6.24.3
> make ARCH=arm INSTALL_HDR_PATH=/tmp headers_install
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  HOSTCC  scripts/basic/fixdep
....
  UNIFDEF include/linux/icmp.h
  UNIFDEF include/linux/icmpv6.h
  UNIFDEF include/linux/if_addr.h
make[2]: *** No rule to make target
`/home/dsaxena/src/mvista/mvista-git/include/linux/if_addrlabel.h', needed
by `/tmp/include/linux/if_addrlabel.h'.  Stop.
make[1]: *** [linux] Error 2
make: *** [headers_install] Error 2

Commit 5fb7ba76544d95bfa05199f7394a442de5660be7 in the 2.6.24.y git tree
adds if_addrlabel.h to the sanitized headers, but since this header was 
not merged into the kernel until 2.6.25-rc1, the change is not needed.

Signed-off-by: Deepak Saxena <dsaxena@mvista.com>

---
 include/linux/Kbuild |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 4b32bb1..f30fa92 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -217,7 +217,6 @@ unifdef-y += i2o-dev.h
 unifdef-y += icmp.h
 unifdef-y += icmpv6.h
 unifdef-y += if_addr.h
-unifdef-y += if_addrlabel.h
 unifdef-y += if_arp.h
 unifdef-y += if_bridge.h
 unifdef-y += if_ec.h
-- 
1.5.4.3.24.gabaa.dirty


-- 
   _____   __o  Deepak Saxena - Living CarFree and CareFree            (o>
------    -\<,  Towards Carfree Cities 2008 - www.carfreeportland.org  //\
 ----- ( )/ ( ) Linux Plumber's Conference - www.linuxplumbersconf.org V_/_
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
