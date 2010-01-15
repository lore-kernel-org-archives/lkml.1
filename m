Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab0AOPSI (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 10:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856Ab0AOPSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 10:18:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:53159 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802Ab0AOPSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 10:18:02 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/2] perf archive: Add helper script to package files needed to do analysis
Date: Fri, 15 Jan 2010 13:17:52 -0200
Message-Id: <1263568672-30323-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1263568672-30323-1-git-send-email-acme@infradead.org>
References: <1263568672-30323-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It uses 'perf buildid-list --with-hits' to create a tarball with what is
needed to have in the destination machine ~/.debug hierarchy to properly
decode the perf.data file specified.

Here is an example where a perf.data file collected on a x86-64 machine
running Fedora 12 is used and then the data is packaged, transferred and
decoded on a PARISC64 machine running Debian Testing, 32-bit userspace:

[root@doppio linux-2.6-tip]# uname -a
Linux doppio.ghostprotocols.net 2.6.33-rc4-tip+ #3 SMP Wed Jan 13 11:58:15 BRST 2010 x86_64 x86_64 x86_64 GNU/Linux
[root@doppio linux-2.6-tip]# perf archive
[root@doppio linux-2.6-tip]# ls -la perf.data*
-rw------- 1 root root  737696 2010-01-14 23:36 perf.data
-rw-r--r-- 1 root root 8840025 2010-01-15 12:27 perf.data.tar.bz2
[root@doppio linux-2.6-tip]# scp perf.data.* parisc64:.
Password:
perf.data.tar.bz2                                      100% 8633KB   1.4MB/s   00:06
[root@doppio linux-2.6-tip]# ssh parisc64
Password:
Linux parisc 2.6.19-g2bbf29ac-dirty #1 Sun Dec 3 17:24:04 BRST 2006 parisc64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Thu Jan 14 11:23:24 2010 from d
parisc:~# uname -a
Linux parisc 2.6.19-g2bbf29ac-dirty #1 Sun Dec 3 17:24:04 BRST 2006 parisc64 GNU/Linux
parisc:~# mkdir .debug
parisc:~# tar xvf perf.data.tar.bz2 -C ~/.debug
tar: Record size = 8 blocks
.build-id/74/f9930ee94475b6b3238caf3725a50d59cb994b
[kernel.kallsyms]/74f9930ee94475b6b3238caf3725a50d59cb994b
.build-id/9f/fdcac0a7935922d1f04b6cc9029dfef0f066ef
lib/modules/2.6.33-rc4-tip+/kernel/arch/x86/crypto/aes-x86_64.ko/9ffdcac0a7935922d1f04b6cc9029dfef0f066ef
.build-id/3a/af89c32ebfc438ff546c93597d41788e3e65f3
lib/modules/2.6.33-rc4-tip+/kernel/drivers/net/wireless/iwlwifi/iwl3945.ko/3aaf89c32ebfc438ff546c93597d41788e3e65f3
.build-id/19/f46033f73e1ec612937189bb118c5daba5a0c8
lib/modules/2.6.33-rc4-tip+/kernel/net/mac80211/mac80211.ko/19f46033f73e1ec612937189bb118c5daba5a0c8
.build-id/17/72f014a7a7272859655acb0c64a20ab20b75ee
lib/modules/2.6.33-rc4-tip+/kernel/drivers/net/e1000e/e1000e.ko/1772f014a7a7272859655acb0c64a20ab20b75ee
.build-id/eb/4ec8fa8b2a5eb18cad173c92f27ed8887ed1c1
lib64/libc-2.10.2.so/eb4ec8fa8b2a5eb18cad173c92f27ed8887ed1c1
.build-id/5c/68f7afeb33309c78037e374b0deee84dd441f6
lib64/libpthread-2.10.2.so/5c68f7afeb33309c78037e374b0deee84dd441f6
.build-id/e9/c9ad5c138ef882e4507d2605645b597da43873
bin/dbus-daemon/e9c9ad5c138ef882e4507d2605645b597da43873
.build-id/bc/da7d09eb6c9ee380dae0ed3d591d4311decc31
lib64/libdbus-1.so.3.4.0/bcda7d09eb6c9ee380dae0ed3d591d4311decc31
.build-id/7c/c449a77f48b85d6088114000e970ced613bed8
usr/lib64/libcrypto.so.0.9.8k/7cc449a77f48b85d6088114000e970ced613bed8
.build-id/fd/d1ccd1ff7917ab020653147ab3bacf0a85b5b9
lib64/libglib-2.0.so.0.2000.5/fdd1ccd1ff7917ab020653147ab3bacf0a85b5b9
.build-id/e4/417ebb8762e5f2eee93c8011a71115ff5edad8
lib64/libgobject-2.0.so.0.2000.5/e4417ebb8762e5f2eee93c8011a71115ff5edad8
.build-id/93/1e49461f6df99104f0febcc52f6fed5e2efce6
usr/sbin/sshd/931e49461f6df99104f0febcc52f6fed5e2efce6
.build-id/da/b5f724c088f89fbd8304da553ed6cb30bbec96
usr/lib64/libgdk-x11-2.0.so.0.1600.6/dab5f724c088f89fbd8304da553ed6cb30bbec96
.build-id/f2/037a091ef36b591187a858d75e203690ea9409
usr/sbin/openvpn/f2037a091ef36b591187a858d75e203690ea9409
.build-id/a8/e4f743b40fb1fd8b85e2f9b88d93b661472b8f
bin/find/a8e4f743b40fb1fd8b85e2f9b88d93b661472b8f
.build-id/81/120aada06e68b1e85882925a0fc6d7345ef59a
home/acme/bin/perf/81120aada06e68b1e85882925a0fc6d7345ef59a
parisc:~# perf report 2> /dev/null | head -25
     9.07%             find  find                               [.] 0x0000000000fb0e
     3.29%             perf  libc-2.10.2.so                     [.] __GI_strcmp
     3.19%             find  [kernel.kallsyms]                  [k] _raw_spin_unlock_irqrestore
     2.70%             find  libc-2.10.2.so                     [.] __GI_memmove
     2.62%             perf  [kernel.kallsyms]                  [k] vsnprintf
     2.03%             find  libc-2.10.2.so                     [.] _int_malloc
     2.02%             perf  [kernel.kallsyms]                  [k] format_decode
     1.70%             find  [kernel.kallsyms]                  [k] n_tty_write
     1.70%             find  [kernel.kallsyms]                  [k] half_md4_transform
     1.67%             find  libc-2.10.2.so                     [.] _IO_vfprintf_internal
     1.66%             perf  [kernel.kallsyms]                  [k] audit_free_aux
     1.62%          swapper  [kernel.kallsyms]                  [k] mwait_idle_with_hints
     1.58%             find  [kernel.kallsyms]                  [k] __kmalloc
     1.35%             find  [kernel.kallsyms]                  [k] sched_clock_local
     1.35%             find  [kernel.kallsyms]                  [k] ext4_check_dir_entry
     1.35%             find  [kernel.kallsyms]                  [k] ext4_htree_store_dirent
     1.35%             find  [kernel.kallsyms]                  [k] sys_write
     1.35%             find  [e1000e]                           [k] e1000_clean
     1.35%             find  [kernel.kallsyms]                  [k] _atomic_dec_and_lock
     1.34%             find  [kernel.kallsyms]                  [k] __d_lookup
parisc:~#

Probably the next step is to have 'perf report' notice that there is a
perf.data.tar.bz2 file in the same directory and look if it was already
added to ~/.debug/.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile         |   10 ++--------
 tools/perf/command-list.txt |    1 +
 tools/perf/perf-archive.sh  |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 8 deletions(-)
 create mode 100755 tools/perf/perf-archive.sh

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2c03a94..d739552 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -286,11 +286,7 @@ SCRIPT_PERL =
 SCRIPT_SH =
 TEST_PROGRAMS =
 
-#
-# No scripts right now:
-#
-
-# SCRIPT_SH += perf-am.sh
+SCRIPT_SH += perf-archive.sh
 
 #
 # No Perl scripts right now:
@@ -315,9 +311,7 @@ PROGRAMS += perf
 # List built-in command $C whose implementation cmd_$C() is not in
 # builtin-$C.o but is linked in as part of some other command.
 #
-# None right now:
-#
-# BUILT_INS += perf-init $X
+BUILT_INS += perf-archive
 
 # what 'all' will build and 'install' will install, in perfexecdir
 ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS)
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 71dc7c3..f73d1d9 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -3,6 +3,7 @@
 # command name			category [deprecated] [common]
 #
 perf-annotate			mainporcelain common
+perf-archive			mainporcelain
 perf-bench			mainporcelain common
 perf-buildid-list		mainporcelain common
 perf-diff			mainporcelain common
diff --git a/tools/perf/perf-archive.sh b/tools/perf/perf-archive.sh
new file mode 100755
index 0000000..45fbe2f
--- /dev/null
+++ b/tools/perf/perf-archive.sh
@@ -0,0 +1,32 @@
+#!/bin/bash
+# perf archive
+# Arnaldo Carvalho de Melo <acme@redhat.com>
+
+PERF_DATA=perf.data
+if [ $# -ne 0 ] ; then
+	PERF_DATA=$1
+fi
+
+DEBUGDIR=~/.debug/
+BUILDIDS=$(mktemp /tmp/perf-archive-buildids.XXXXXX)
+
+perf buildid-list -i $PERF_DATA --with-hits > $BUILDIDS
+if [ ! -s $BUILDIDS ] ; then
+	echo "perf archive: no build-ids found"
+	rm -f $BUILDIDS
+	exit 1
+fi
+
+MANIFEST=$(mktemp /tmp/perf-archive-manifest.XXXXXX)
+
+cut -d ' ' -f 1 $BUILDIDS | \
+while read build_id ; do
+	linkname=$DEBUGDIR.build-id/${build_id:0:2}/${build_id:2}
+	filename=$(readlink -f $linkname)
+	echo ${linkname#$DEBUGDIR} >> $MANIFEST
+	echo ${filename#$DEBUGDIR} >> $MANIFEST
+done
+
+tar cfj $PERF_DATA.tar.bz2 -C $DEBUGDIR -T $MANIFEST
+rm -f $MANIFEST $BUILDIDS
+exit 0
-- 
1.6.2.5

