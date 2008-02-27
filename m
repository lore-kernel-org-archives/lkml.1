Return-Path: <linux-kernel-owner+w=401wt.eu-S1758722AbYB0G4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbYB0G4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 01:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbYB0G4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 01:56:45 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3045 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbYB0G4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 01:56:44 -0500
Subject: Re: [PATCH] linux/fs.h - Convert debug functions declared inline
	__attribute__((format (printf,x,y) to statement expression macros
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Matthew Wilcox <matthew@wil.cx>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, gcc@gcc.gnu.org
In-Reply-To: <alpine.DEB.1.00.0802262140160.23764@chino.kir.corp.google.com>
References: <1204081722.19319.405.camel@localhost>
	 <1204084947.19319.411.camel@localhost>
	 <20080227041316.GA23188@parisc-linux.org>
	 <alpine.DEB.1.00.0802262140160.23764@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Tue, 26 Feb 2008 22:54:09 -0800
Message-Id: <1204095249.19319.444.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-26 at 21:44 -0800, David Rientjes wrote:
> I'm not seeing any change in text size with allyesconfig after applying 
> this patch with latest git:

This is just x86 defconfig

> Joe, what version of gcc are you using?

$ gcc --version
gcc (GCC) 4.2.2 20071128 (prerelease) (4.2.2-3.1mdv2008.0)

It's definitely odd.
The .o size changes are inconsistent.
Some get bigger, some get smaller.

The versioning ones I understand but I have no idea why
changes in drivers/ or mm/ or net/ exist.

I think it's gcc optimization changes, but dunno...
Any good ideas?

$ git reset --hard
HEAD is now at 7704a8b... Merge branch 'for-linus' of git://oss.sgi.com:8090/xfs/xfs-2.6
$ make mrproper ; make defconfig ; make > /dev/null
$ size vmlinux
   text    data     bss     dec     hex filename
4716770  474560  618496 5809826  58a6a2 vmlinux
$ size $(find -type f -print | grep "\.o$" | grep -vP "(vmlinux|built-in|piggy|allsyms.)\.o$") > size.default
$ patch -p1 < inline/fs.h.d
$ make > /dev/null
$ size vmlinux
   text    data     bss     dec     hex filename
4716706  474560  618496 5809762  58a662 vmlinux
$ size $(find -type f -print | grep "\.o$" | grep -vP "(vmlinux|built-in|piggy|allsyms.)\.o$") > size.inline_fs
$ diff --unified=0 size.default size.inline_fs
--- size.default        2008-02-26 22:18:33.000000000 -0800
+++ size.inline_fs      2008-02-26 22:33:27.000000000 -0800
@@ -21 +21 @@
-     79              0       0      79      4f ./arch/x86/boot/version.o
+     85              0       0      85      55 ./arch/x86/boot/version.o
@@ -335 +335 @@
-   5206             72      12    5290    14aa ./drivers/base/core.o
+   5201             72      12    5285    14a5 ./drivers/base/core.o
@@ -374 +374 @@
-  18192            104    1648   19944    4de8 ./drivers/char/tty_io.o
+  18184            104    1648   19936    4de0 ./drivers/char/tty_io.o
@@ -390 +390 @@
-   4293            560      24    4877    130d ./drivers/char/hpet.o
+   4287            560      24    4871    1307 ./drivers/char/hpet.o
@@ -473 +473 @@
-  38914             32     341   39287    9977 ./drivers/message/fusion/mptbase.o
+  38922             32     341   39295    997f ./drivers/message/fusion/mptbase.o
@@ -492 +492 @@
-  81665           2613       4   84282   1493a ./drivers/net/tg3.o
+  81659           2613       4   84276   14934 ./drivers/net/tg3.o
@@ -544 +544 @@
-  17508            845     552   18905    49d9 ./drivers/scsi/aic7xxx/aic79xx_osm.o
+  17510            845     552   18907    49db ./drivers/scsi/aic7xxx/aic79xx_osm.o
@@ -581 +581 @@
-     74           4480       0    4554    11ca ./drivers/scsi/scsi_wait_scan.mod.o
+     80           4480       0    4560    11d0 ./drivers/scsi/scsi_wait_scan.mod.o
@@ -774 +774 @@
-   1924              4       4    1932     78c ./fs/proc/kcore.o
+   1922              4       4    1930     78a ./fs/proc/kcore.o
@@ -776 +776 @@
-  41462            652      80   42194    a4d2 ./fs/proc/proc.o
+  41458            652      80   42190    a4ce ./fs/proc/proc.o
@@ -828 +828 @@
-   9583             80       0    9663    25bf ./fs/locks.o
+   9571             80       0    9651    25b3 ./fs/locks.o
@@ -870 +870 @@
-    277            396       4     677     2a5 ./init/version.o
+    281            396       4     681     2a9 ./init/version.o
@@ -926 +926 @@
-   8379            460       8    8847    228f ./kernel/sys.o
+   8381            460       8    8849    2291 ./kernel/sys.o
@@ -954 +954 @@
-  13337            188      73   13598    351e ./kernel/module.o
+  13341            188      73   13602    3522 ./kernel/module.o
@@ -1044 +1044 @@
-   1845              0       0    1845     735 ./mm/mremap.o
+   1841              0       0    1841     731 ./mm/mremap.o
@@ -1052 +1052 @@
-   8781             44    2196   11021    2b0d ./mm/swapfile.o
+   8777             44    2196   11017    2b09 ./mm/swapfile.o
@@ -1065 +1065 @@
-   2630              0       0    2630     a46 ./net/core/datagram.o
+   2631              0       0    2631     a47 ./net/core/datagram.o
@@ -1101 +1101 @@
-  13190             24       0   13214    339e ./net/ipv4/tcp_output.o
+  13192             24       0   13216    33a0 ./net/ipv4/tcp_output.o
@@ -1109 +1109 @@
-   6244            468       0    6712    1a38 ./net/ipv4/arp.o
+   6239            468       0    6707    1a33 ./net/ipv4/arp.o
@@ -1138 +1138 @@
-   4660            132      44    4836    12e4 ./net/ipv6/ip6_fib.o
+   4644            132      44    4820    12d4 ./net/ipv6/ip6_fib.o
@@ -1146 +1146 @@
-  16397             24       4   16425    4029 ./net/ipv6/mcast.o
+  16399             24       4   16427    402b ./net/ipv6/mcast.o
@@ -1159 +1159 @@
- 143799           7424    3036  154259   25a93 ./net/ipv6/ipv6.o
+ 143787           7424    3036  154247   25a87 ./net/ipv6/ipv6.o
@@ -1202 +1202 @@
-   2109            600       0    2709     a95 ./net/xfrm/xfrm_algo.o
+   2111            600       0    2711     a97 ./net/xfrm/xfrm_algo.o


