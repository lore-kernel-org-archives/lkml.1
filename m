Return-Path: <linux-kernel-owner+w=401wt.eu-S2993345AbXEBPTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993345AbXEBPTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993347AbXEBPTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:19:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50892 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993345AbXEBPTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:19:12 -0400
Date: Wed, 2 May 2007 17:19:03 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: [RFC] Reorder Kconfig: General setup
Message-ID: <Pine.LNX.4.58.0705021549110.5442@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19nVD6Clc3Ak0zAEMm0mPmahrtWURx0M9/IQME
 AoYAvy9T99wHTaxfI+zkYkPVGIN7KYoUFdao5gDht0Nf8eDNIZ
 AsYBhUZ8ozJ5NeEt1eR9w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some Kconfig menus are very unsorted, so finding the option you want to 
change takes careful reading of the complete menu.

I'm about to change some of the menus to be more user-friendly, starting
with the general setup and working my way through the rest as time permits.


In order to make the correct changes, I need some ACK/NACK/comments to 
some of the changes:

1) Initrd/initramfs: This does add about 6 KB of init(?) memory.
   IMO, it could default to y and be moved to embedded.

2) There are many options that are only usefull with 
   vserver-virtualisation. I'd like to introduce a select (none/all/some)
   to get rid of these 1001 individual options.

3) UTS namespaces are a bad name while talking to non-programmers.
   Can you provide a better caption/description? Otherwise I'll try to 
   find something.

4) Is it usefull to have relay(fs) in this menu? IMO it should be
   selected by it's users and moved to libraries or filesystems.

5) Some entries in other menus say "Support (for) ..." or "... support"
   I'd like to remove that part.



This is how I'd like to change the order of the items in General Setup,
not including the changes above:

General Setup

Version information:
  ()  Local version - append to kernel release
  [*] Automatically append version information to the version string
  <*> Kernel .config support
  [*]   Enable access to .config through /proc/config.gz

Kernel features:
  [ ] Initial RAM filesystem and RAM disk (initramfs/initrd) support
  [*] UTS Namespaces
  [*] Support for paging of anonymous memory (swap)
  [*] System V IPC
  [*]   IPC Namespaces
  [*] POSIX Message Queues

Accounting:
  [ ] BSD Process Accounting
  [ ] Export task/process statistics through netlink (EXPERIMENTAL)
  [ ] Auditing support
  [ ] Kernel->user space relay support (formerly relayfs)

Extra settings
  [ ] Create deprecated sysfs files
  [*] Optimize for size (Look out for broken compilers!)
  [ ] Configure standard kernel features (for small systems)  --->
  [ ] Include all symbols in kallsyms
  [ ] Do an extra kallsyms pass


-- 
Top 100 things you don't want the sysadmin to say:
91. Well, it's doing _something_.....
