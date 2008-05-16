Return-Path: <linux-kernel-owner+w=401wt.eu-S1758622AbYEPOoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622AbYEPOoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYEPOmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:42:09 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49190 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbYEPOmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:00 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 63/67] aufs mount helper
Date: Fri, 16 May 2008 23:33:17 +0900
Message-Id: <1210948402777-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484021127-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp> <1210948!
 4013702-git-send-email-hooanon05@yahoo.co.jp> <12109484012871-git-send-email-hooanon05@yahoo.co.jp> <12109484013438-git-send-email-hooanon05@yahoo.co.jp> <12109484013559-git-send-email-hooanon05@yahoo.co.jp> <12109484012111-git-send-email-hooanon05@yahoo.co.jp> <1210948401543-git-send-email-hooanon05@yahoo.co.jp> <1210948401147-git-send-email-hooanon05@yahoo.co.jp> <12109484012904-git-send-email-hooanon05@yahoo.co.jp> <121094840127-git-send-email-hooanon05@yahoo.co.jp> <12109484011862-git-send-email-hooanon05@yahoo.co.jp> <12109484011143-git-send-email-hooanon05@yahoo.co.jp> <12109484011867-git-send-email-hooanon05@yahoo.co.jp> <12109484021033-git-send-email-hooanon05@yahoo.co.jp> <12109484021234-git-send-email-hooanon05@yahoo.co.jp> <12109484022680-git-send-email-hooanon05@yahoo.co.jp> <12109484021974-git-send-email-hooanon05@yahoo.co.jp> <12109484021281-git-send-email-hooanon05@yahoo.co.jp> <12109484022659-git-send-email-hooanon05@yahoo.co.jp> <12109484023036-git-send-ema!
 il-hooanon05@yahoo.co.jp> <12109484021939-git-send-email-hooanon05@yahoo.co.jp> <12109484022745-git-send-email-hooanon05@yahoo.co.jp> <12109484023224-git-send-email-hooanon05@yahoo.co.jp> <12109484023618-git-send-email-hooanon05@yahoo.co.jp> <12109484023820-git-send-email-hooanon05@yahoo.co.jp> <12109484021927-git-send-email
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs mount helper

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 Documentation/filesystems/aufs/mount.aufs |  205 +++++++++++++++++++++++++++++
 1 files changed, 205 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/aufs/mount.aufs b/Documentation/filesystems/aufs/mount.aufs
new file mode 100755
index 0000000..28db51e
--- /dev/null
+++ b/Documentation/filesystems/aufs/mount.aufs
@@ -0,0 +1,205 @@
+#!/bin/sh -
+
+# Copyright (C) 2005, 2006, 2007 Junjiro Okajima
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
+# $Id: mount.aufs,v 1.17 2008/03/31 07:44:10 sfjro Exp $
+
+#
+# The main purpose of this script is updating /etc/mtab and calling auplilnk.
+# This script is highly depending on mount(8) in util-linux-2.12p package.
+# TODO: rewrite in C.
+# TODO: updating mtab for bind-mount is not fully supportetd.
+#
+
+PATH=/usr/bin:/usr/sbin:/bin:/sbin
+export PATH
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
+########################################
+
+set -e
+#set -x; echo $0 $@
+tmp=/tmp/$$
+fstype=`basename "$0" | cut -f2 -d.`
+
+########################################
+# mount(8) always passes the arguments in this order
+
+do_update=1
+verbose=0
+dev="$1"
+e_dev=`echo "$dev" | conv escape`
+cd "$2"
+mntpnt=`readlink -f "$PWD"`
+e_mntpnt=`echo "$mntpnt" | conv escape`
+cd "$OLDPWD"
+shift 2
+test "$1" = "-n" && do_update=0 && shift
+test "$1" = "-v" && verbose=1 && shift
+test "$1" = "-o" || { eecho Bad arg. "$@"; exit 1; }
+shift
+remount=0
+echo "$@" | grep -q ',remount[,$]' && remount=1
+
+f=/etc/mtab
+test ! -r $f -o \( $do_update -eq 1 -a ! -w $f \) &&
+eecho ${f}: Permission denied &&
+exit 1
+
+f=/proc/mounts
+test \( $do_update -eq 1 -o $verbose -eq 1 \) -a ! -r $f &&
+eecho ${f}: Permission denied. &&
+exit 1
+
+oldmtab=
+> $tmp.old_opt
+if [ $remount -eq 1 ]
+then
+oldmtab=`grep "^$e_dev $e_mntpnt $fstype .*,si=" $f | tail -n 1`
+echo "$oldmtab" |
+sed -e '
+s:^'"$dev $mntpnt $fstype"' ::
+s/\( [0-9]*\)\{2\}$//
+' | tr ',' '\n' > $tmp.old_opt
+#test -s $tmp.old_opt
+eval `grep '^si=' $tmp.old_opt`
+
+# append brs from sysfs
+si_dir=/sys/fs/aufs/si_$si
+if [ -r $si_dir/br0 ]
+then
+	cd $si_dir
+	{
+	ls -1 br* |
+	cut -c3- |
+	sort -n |
+	sed -e 's/^/br/' |
+	xargs -n 200 sed -e 's/^/:/' |
+	tr -d '\n' |
+	sed -e 's/^/br/'
+	echo # last newline
+	} >> $tmp.old_opt
+	cd $OLDPWD
+	#cat $tmp.old_opt; #rm -f $tmp $tmp.*; exit
+fi
+fi
+
+echo "$@" | tr ',' '\n' > $tmp.new_opt
+remount=
+fgrep -v remount $tmp.new_opt > $tmp #|| :
+diff -q $tmp.new_opt $tmp > /dev/null ||
+{
+	mv $tmp $tmp.new_opt
+	remount="remount,"
+}
+#cat $tmp.new_opt; rm -f $tmp $tmp.*; exit
+
+#more $tmp.old_opt $tmp.new_opt
+real_opt=`comm -13 $tmp.old_opt $tmp.new_opt | tee $tmp | paste -s -d, -`
+real_opt="${remount}${real_opt}"
+test "$real_opt" = "" &&
+eecho bad arg "$@" &&
+rm -f $tmp $tmp.* &&
+exit 1
+#echo ${real_opt}; exit
+
+test "$remount" &&
+egrep -q '^((add|ins|append|prepend|del)[:=]|(mod|imod)[:=][^,]*=ro|(noplink|ro)$)' $tmp &&
+auplink "$mntpnt" flush
+rm -f $tmp $tmp.*
+
+########################################
+# actual mount operation
+
+set +e
+mount -in -t $fstype -o "$real_opt" "$dev" "$mntpnt"
+err=$?
+set -e
+
+test $do_update -eq 0 -a $verbose -eq 0 && exit $err
+
+########################################
+# in order to handle '-v' option, keep going even if we failed
+
+failure()
+{
+	eecho failure "$1" $?
+	exit 1
+}
+
+newmtab=`{ grep "^$e_dev $e_mntpnt $fstype" /proc/mounts ||
+	failure "bad /proc/mounts"; } |
+	tail -n 1 | sed -e 's:^'"$e_dev $e_mntpnt $fstype"' ::'`
+digits=`echo "$newmtab" | rev | cut -f-2 -d' ' | rev`
+newmtab=`echo "$newmtab" | rev | cut -f3- -d' ' | rev | conv escape`
+newmtab="$e_dev $e_mntpnt $fstype $newmtab $digits"
+
+#if [ $do_update -eq 1 -a -w /etc -a -w /etc/mtab ]
+if [ $do_update -eq 1 ]
+then
+lock_pid=/etc/mtab~$$
+lock=/etc/mtab~
+f=/etc/mtab.aufs.tmp
+touch $lock_pid || failure "creating pid lockfile"
+
+# re-define
+failure()
+{
+	eecho failure "$1" $?
+	test $err -eq 0 && eecho failed updating /etc/mtab
+	exit 1
+}
+#trap "rm -f $lock; failure" `seq 32`
+
+ln $lock_pid $lock || failure "linking lockfile"
+rm $lock_pid || failure "removing pid lockfile"
+
+if [ "$oldmtab" = "" ]
+then
+	{ cat /etc/mtab; echo "$newmtab"; } |
+	dd of=$f 2> /dev/null || failure "appending $f"
+else
+	tac /etc/mtab |
+	awk -v new="$newmtab" -v mntpnt="$e_mntpnt" -v fstype="$fstype" '
+	!done && $2 == mntpnt && $3 == fstype {print new; done = 1; next}
+	{print}
+	' | tac > $f || failure "creating $f"
+fi
+mv $f /etc/mtab || failure "renaming from $f"
+rm $lock || failure "removing lockfile"
+fi
+
+test $verbose -eq 1 &&
+echo "$dev" on "$mntpnt" type "$fstype" \(`echo "$newmtab" | cut -f4 -d' '`\)
+exit $err
-- 
1.4.4.4

