Return-Path: <linux-kernel-owner+w=401wt.eu-S932581AbZIDCo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbZIDCo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 22:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932491AbZIDCo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 22:44:26 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41042 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932500AbZIDCoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 22:44:25 -0400
X-Sasl-enc: 2QCmHeI5IEm3lRzsaC+z+h+PTqb1DUD/N1esWDhNwXY7 1252032265
Date: Fri, 4 Sep 2009 10:44:18 +0800 (WST)
From: Ian Kent <raven@themaw.net>
To: autofs mailing list <autofs@linux.kernel.org>
cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] autofs 5.0.5 release
Message-ID: <alpine.LFD.2.00.0909041042150.3124@zeus.themaw.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Its been a long time, I know, but finally here is release 5.0.5.
Once again there quite a lot of bug fixes.

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
  up. However, we have had reports mounts and umounts to down servers
  taking quite a while with recent kernels, I'm not sure how this will
  end up at this stage so we will need to persevere with this for now.

autofs
======

The package can be found at:

ftp://ftp.kernel.org/pub/linux/daemons/autofs/v5

It is autofs-5.0.5.tar.[gz|bz2]

No source rpm is there as it can be produced by using:

rpmbuild -ts autofs-5.0.5.tar.gz

and the binary rpm by using:

rpmbuild -tb autofs-5.0.5.tar.gz

See the INSTALL file for information about configure options and
kernel requirements.

Here are the entries from the CHANGELOG which outline the updates:

03/09/2009 autofs-5.0.5
-----------------------
- fix dumb libxml2 check
- fix nested submount expire deadlock.
- fix negative caching for non-existent map keys.
- use CLOEXEC flag.
- fix select(2) fd limit.
- make hash table scale to thousands of entries (Paul Wankadia,
  Valerie Aurora Henson).
- clear the quoted flag after each character from program map input.
- use CLOEXEC flag for setmntent also.
- fix hosts map use after free.
- fix uri list locking (again).
- check for stale SASL credentials upon connect fail.
- add "forcestart" and "forcerestart" init script options to allow
  use of 5.0.3 strartup behavior if required.
- always read entire file map into cache to speed lookups.
- make MAX_ERR_BUF and PARSE_MAX_BUF use easier to audit.
- make some easy alloca replacements (Valerie Aurora Henson).
- update to configure libtirpc if present.
- update to provide ipv6 name and address support.
- update to provide ipv6 address parsing.
- easy alloca replacements fix.
- add check for alternate libxml2 library for libxml2 tsd workaround.
- add check for alternate libtirpc library for libtirpc tsd workaround.
- cleanup configure defines for libtirpc.
- add WITH_LIBTIRPC to -V status report.
- add nfs mount protocol default configuration option.
- fix bad token declaration in master map parser.
- fix return start status on fail.
- fix double free in expire_proc().
- another easy alloca replacements fix.
- add LSB init script parameter block.
- fix file map lookup when reading included or nsswitch sources.
- use misc device ioctl interface by default, if available.
- fix call restorecon when misc device file doesn't exist.
- clear rpc client on lookup fail.
- fix lsb init script header.
- fix memory leak reading master map.
- fix st_remove_tasks() locking.
- reset flex scanner when setting buffer.
- zero s_magic is valid.
- use percent hack for master map keys.
- use intr option as hosts mount default.
- fix kernel includes.
- dont umount existing direct mount on master re-read.
- fix incorrect shutdown introduced by library relaod fixes.
- improve manual umount recovery.
- dont fail on ipv6 address when adding host.
- always read file maps multi map fix.
- always read file maps key lookup fixes.
- use srv query for domain dn.
- fix not releasing resources when using submounts.
- fix notify mount message path.
- remount we created mount point fix.
- fix double free in sasl_bind().
- mannual umount recovery fixes.
- fix map type info parse error.
- fix an RPC fd leak.
- don't block signals we expect to dump core.
- fix pthread push order in expire_proc_direct().
- fix libxml2 non-thread-safe calls.
- fix direct map cache locking.
- fix dont umount existing direct mount on reread.
- update kernel patches.

Ian
