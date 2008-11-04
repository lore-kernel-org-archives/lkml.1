Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbYKDC0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbYKDC0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 21:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbYKDC0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 21:26:10 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:33555 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433AbYKDC0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 21:26:08 -0500
X-Greylist: delayed 1204 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Nov 2008 21:26:08 EST
X-Sasl-enc: vUjrs+n6dADetly6eHgKnxi0VqKswcMvW28K4EMqjw31 1225764362
Date: Tue, 4 Nov 2008 11:05:57 +0900 (WST)
From: Ian Kent <raven@themaw.net>
To: autofs mailing list <autofs@linux.kernel.org>
cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] autofs 5.0.4 release
Message-ID: <alpine.LFD.2.00.0811041102230.20494@zeus.themaw.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

Here is release 5.0.4.

Apart from numerous bug fixes, the main issue addressed with this release
is the active restart mentioned in the 5.0.3 release note. Please refer
to the file README.active-restart for a description of the problem and
information about using it. The kernel patches needed for this are
present in the 2.6.28-rc series as well as in the release tarball here.
The change has quite a bit of new code so I'd appreciate people testing
it out it so we can get any problems sorted out for 5.0.5. Note that,
as described in the README, autofs will use the old interface unless it
is explicitly configured to use the new interface, a kernel which supports
it is present and access to the autofs miscellaneous device is not denied
by selinux policy.

Known issues
============

- Quoted strings in the master map are still not yet handled.
- There is a problem with "mount --move" in some releases of SuSE
  (perhaps other distributions as well)  which can cause mounts to
  not be moved correctly resulting in /etc/mtab continually growing
  due to invalid entries.
- When the active restart is being used it will happily re-connect a
  mount that is unresponsive, perhaps because the server is not
  responding. A forced expire (USR1 signal) should be enough to clean
  up these unresponsive mounts, provided they aren't in use, so I'm
  not sure what will be done about this yet and and need feedback from
  people testing before deciding what to do about it, if anything at
  all.

autofs
======

The package can be found at:

ftp://ftp.kernel.org/pub/linux/daemons/autofs/v5

It is autofs-5.0.4.tar.[gz|bz2]

No source rpm is there as it can be produced by using:

rpmbuild -ts autofs-5.0.4.tar.gz

and the binary rpm by using:

rpmbuild -tb autofs-5.0.4.tar.gz

See the INSTALL file for information about configure options and
kernel requirements.

Here are the entries from the CHANGELOG which outline the updates:

4/11/2008 autofs-5.0.4
-----------------------
- correct configure test for ldapr page control functions.
- catch "-xfn" map type and issue "no supported" message.
- correction for handling of LDAP base dns with spaces.
- avoid using UDP for probing NFSv4 mount requests.
- use libldap instead of libldap_r (Guillaume Rousse).
- another fix for don't fail on empty master map.
- fix expire working harder than needed.
- fix unlink of mount tree incorrectly causing autofs mount fail.
- update kernel header file linux/auto_fs4.h.
- update fix expire working harder than needed.
- add missing check for zero length NIS key (Wengang Wang).
- init SASL callbacks on every ldap lookup library load.
- fix incorrect match of map type name when included in map name.
- fix incorrect pthreads condition handling for mount requests.
- add check for exports automatically mounted by NFS kernel client.
- update nsswitch parser to ignore nsswitch sources that aren't supported.
- check for map key in (possible) alternate map sources when doing lookup.
- eliminate redundant DNS name lookups.
- additional fix incorrect pthreads condition handling for mount requests.
- allow mount point directory creation for clients with an NFS root.
- fix direct mount path length not being checked.
- fix incorrect if check in get user info.
- fix couple of memory leaks.
- add command line option to override check for daemon already running.
- don't use proc file system when checking if the daemon is running.
- make handle_mounts startup condition distinct.
- fix submount shutdown recovery handling.
- avoid stat of possibly dead mount points and limit time to wait for
  umount during expire.
- make mount of multi-mounts wuth a root offset atomic.
- add replicated server selection debug logging.
- update replicated server selection documentation.
- use /dev/urandom instead of /dev/random.
- check for mtab pointing to /proc/mounts.
- dynamically allocate interface config buffer.
- update kernel patches.
- fix fd leak at multi-mount non-fatal mount fail.
- fix incorrect multi-mount mountpoint calcualtion.
- fix map out of order map re-read on hup signal.
- fix nisplus error return check and use after free error.
- fix rootless direct multi-mount expire.
- wait submount expire thread completion.
- add missing uris list locking.
- fix segv during library re-open.
- fix incorrect pthreads condition handling for expire requests.
- fix $mandir definition in Makefile.conf.in
- fix init script stop function.
- fix master map lexer eval order.
- fix bad alloca usage.
- add miscellaneous device node interface library.
- use miscellaneous device node, if available, for active restart.
- make is_mounted() use new ioctl interface, if available.

Ian
