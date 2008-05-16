Return-Path: <linux-kernel-owner+w=401wt.eu-S1765072AbYEPPFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765072AbYEPPFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYEPOmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:42:01 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49181 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbYEPOl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:41:58 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 64/67] aufs pseudo-link helper
Date: Fri, 16 May 2008 23:33:18 +0900
Message-Id: <1210948403394-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <1210948402777-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp> <1210948!
 4013702-git-send-email-hooanon05@yahoo.co.jp> <12109484012871-git-send-email-hooanon05@yahoo.co.jp> <12109484013438-git-send-email-hooanon05@yahoo.co.jp> <12109484013559-git-send-email-hooanon05@yahoo.co.jp> <12109484012111-git-send-email-hooanon05@yahoo.co.jp> <1210948401543-git-send-email-hooanon05@yahoo.co.jp> <1210948401147-git-send-email-hooanon05@yahoo.co.jp> <12109484012904-git-send-email-hooanon05@yahoo.co.jp> <121094840127-git-send-email-hooanon05@yahoo.co.jp> <12109484011862-git-send-email-hooanon05@yahoo.co.jp> <12109484011143-git-send-email-hooanon05@yahoo.co.jp> <12109484011867-git-send-email-hooanon05@yahoo.co.jp> <12109484021033-git-send-email-hooanon05@yahoo.co.jp> <12109484021234-git-send-email-hooanon05@yahoo.co.jp> <12109484022680-git-send-email-hooanon05@yahoo.co.jp> <12109484021974-git-send-email-hooanon05@yahoo.co.jp> <12109484021281-git-send-email-hooanon05@yahoo.co.jp> <12109484022659-git-send-email-hooanon05@yahoo.co.jp> <12109484023036-git-send-ema!
 il-hooanon05@yahoo.co.jp> <12109484021939-git-send-email-hooanon05@yahoo.co.jp> <12109484022745-git-send-email-hooanon05@yahoo.co.jp> <12109484023224-git-send-email-hooanon05@yahoo.co.jp> <12109484023618-git-send-email-hooanon05@yahoo.co.jp> <12109484023820-git-send-email-hooanon05@yahoo.co.jp> <12109484021927-git-send-email
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs pseudo-link helper

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 Documentation/filesystems/aufs/auplink |  170 ++++++++++++++++++++++++++++++++
 1 files changed, 170 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/aufs/auplink b/Documentation/filesystems/aufs/auplink
new file mode 100755
index 0000000..52daf3f
--- /dev/null
+++ b/Documentation/filesystems/aufs/auplink
@@ -0,0 +1,170 @@
+#!/bin/sh
+
+# Copyright (C) 2006, 2007, 2008 Junjiro Okajima
+#
+# This program, aufs is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+
+# $Id: auplink,v 1.9 2008/03/31 07:44:10 sfjro Exp $
+
+#set -x; echo $0 $@
+tmp=/tmp/$$
+set -e
+
+Usage()
+{
+	cat <<- EOF 1>&2
+	usage: $0 aufs_mount_point list|cpup|flush
+	'list' shows the pseudo-linked inode numbers and filenames.
+	'cpup' copies-up all pseudo-link to the writeble branch.
+	'flush' calls 'cpup', and then "mount -o remount,clean_plink=inum"
+	and remove the whiteouted plink.
+	EOF
+	rm -f $tmp $tmp.*
+	exit 1
+}
+
+eecho() { echo "$@" 1>&2; }
+
+conv() # [escape]
+{
+	sed -r -e '
+	s/\\/\\134/g
+	s/$/\\012/
+	' |
+	tr -d '\n' |
+	sed -r -e '
+	s/ /\\040/g
+	s/\t/\\011/g
+	s/\r/\\015/g
+	s/\\012$//
+	' |
+	{ test "$1" = "escape" && sed -r -e 's/\\/\\\\/g' || cat; }
+	echo
+}
+
+Find() # dir [ find_args ]
+{
+	dir="$1"
+	shift
+	find "$dir" -xdev -noleaf $@
+}
+
+List()
+{
+	sed -e 's/^\([0-9]*\) .*$/-o -inum \1/' |
+	cut -c3- |
+	xargs -n 200 |
+	while read args
+	do Find "$mntpnt" \( $args \) $@
+	done
+}
+
+Cpup()
+{
+	List \( \( -type l -fprint $tmp.slink \) \
+		-o ! -type l -fprint $tmp.other  \)
+
+	# do nothing but update something. it causes copyup.
+	xargs -r touch -ac -r $tmp.other < $tmp.other
+	xargs -r aulchown < $tmp.slink
+}
+
+test $# -eq 2 || Usage
+cd "$1"
+mntpnt=`readlink -f "$PWD"`
+e_mntpnt=`echo "$mntpnt" | conv escape`
+cd "$OLDPWD"
+
+do_flush=0
+f=${AUPLINK_CONFIG:-/etc/default/auplink}
+if [ -r $f ]
+then
+	. $f
+	for i in $FLUSH
+	do
+		test "$i" = "$mntpnt" -o "$i" = "ALL" || continue
+		do_flush=1
+		break
+	done
+fi
+case $2 in
+cpup|flush) test $do_flush -eq 0 && exit 0;;
+esac
+
+ent=`grep " $e_mntpnt aufs .*,si=" /proc/mounts | tail -n 1`
+test ! "$ent" && exit 0
+eval `echo "$ent" | tr ',' '\n' | grep '^si='`
+test ! "$si" && eecho no such mount-point $e_mntpnt && exit 1
+
+si_dir=/sys/fs/aufs/si_$si
+if [ -r $si_dir/br0 ]
+then
+	cd $si_dir
+	ls -1 br* |
+	cut -c3- |
+	sort -n |
+	sed -e 's/^/br/' |
+	xargs -rn 200 cat
+	cd $OLDPWD
+else
+	echo "$ent" |
+	tr ',' '\n' |
+	sed -e 's/\\/\\\\/g' |
+	egrep '^(dirs=|br:)' |
+	tr ':' '\n'
+fi |
+grep '=rw$' |
+sed -e 's/=rw$//' |
+while read wbr
+do
+	d=`echo $wbr/.wh..wh.plink`
+	# -printf '%n %p\n'
+	test -d "$d" && Find "$d" -maxdepth 1 ! -type d -printf '%n\t%p\n'
+done |
+while read nlink pname
+do
+	inum=`basename "$pname" | cut -f1 -d.`
+	echo $inum $nlink "$pname"
+done > $tmp
+test -s $tmp || { rm -f $tmp $tmp.*; exit 0; }
+
+# debug
+#mount -o remount,list_plink "$mntpnt"
+
+case $2 in
+list)
+	cut -f1 -d' ' $tmp | tr '\n' ' '
+	echo
+	List < $tmp
+	;;
+cpup)
+	Cpup < $tmp
+	;;
+flush)
+	#echo -n Flushing pseudo-links on "$mntpnt"...
+	Cpup < $tmp
+
+	# all are copied-up, and then remove all pseudo-links.
+	mount -o remount,clean_plink "$mntpnt"
+	cut -f3- -d' ' $tmp | xargs -r rm
+	# debug
+	#mount -o remount,list_plink "$mntpnt"
+	#echo done.
+	;;
+*)
+	Usage;;
+esac
+
+rm -f $tmp $tmp.*
-- 
1.4.4.4

