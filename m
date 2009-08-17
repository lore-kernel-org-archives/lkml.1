Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbZHQSrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbZHQSrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 14:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZHQSrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 14:47:32 -0400
Received: from relay8.uol.com.br ([187.17.116.6]:60672 "EHLO relay8.uol.com.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbZHQSrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 14:47:32 -0400
Date: Mon, 17 Aug 2009 15:45:37 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.31-rc5] Data loss with hfsplus
Message-ID: <20090817184537.GA15458@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SIG5: 5f75d087138dcce2c05e09ec6d76d978
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I am trying to package a new version of Apple's own fsck/mkfs for HFS+
filesystems so that they can be used in Linux as a way to transfer data
among computers, but I had quite a surprise when I was using the hfsplus
module.

I just created a 100MB file with nulls (dd if=/dev/null ...) and I
created an HFS+ filesystem on it.

Then, I loop mounted it and tried to use it a little bit (in particular,
applying patches with quilt on a source tree). The commands spit some
errors about not being able to create links (I never had that problem
before) and the directory where I was became empty!

Furthermore, here is a quite, quite strange directory listing:

,----
| rbrito@chagas:/media/usb7$ ls -lAF
| ls: hfsprogs_332.14-7.diff.gz: No such file or directory
| ls: hfsprogs_332.14-7.dsc: No such file or directory
| ls: hfsprogs_332.14.orig.tar.gz: No such file or directory
| ls: hfsprogs_332.18-1.diff.gz: No such file or directory
| ls: hfsprogs_332.18-1.dsc: No such file or directory
| ls: hfsprogs_332.18-1_amd64.changes: No such file or directory
| ls: hfsprogs_332.18-1_amd64.deb: No such file or directory
| ls: hfsprogs_332.18.orig.tar.gz: No such file or directory
| total 1636
| drwxr-xr-x 1 rbrito rbrito     39 Aug 17 08:13 hfsprogs-332.14/
| drwxr-xr-x 1 rbrito rbrito     45 Aug 17 15:30 hfsprogs-332.18/
| -rw-r--r-- 1 rbrito rbrito  35609 Aug 17 08:13 hfsprogs_332.14-7.diff.gz
| -rw-r--r-- 1 rbrito rbrito   1193 Aug 17 08:13 hfsprogs_332.14-7.dsc
| -rw-r--r-- 1 rbrito rbrito 714035 Aug 17 08:13 hfsprogs_332.14.orig.tar.gz
| -rw-r--r-- 1 rbrito rbrito  35342 Aug 17 15:26 hfsprogs_332.18-1.diff.gz
| -rw-r--r-- 1 rbrito rbrito    954 Aug 17 15:26 hfsprogs_332.18-1.dsc
| -rw-r--r-- 1 rbrito rbrito   2148 Aug 17 15:26 hfsprogs_332.18-1_amd64.changes
| -rw-r--r-- 1 rbrito rbrito 135398 Aug 17 15:26 hfsprogs_332.18-1_amd64.deb
| -rw-r--r-- 1 rbrito rbrito 732449 Aug 17 08:35 hfsprogs_332.18.orig.tar.gz
| rbrito@chagas:/media/usb7$ 
`----

I am using kernel 2.6.31-rc5-1rb.pre6 (that is, rc5 with git updates up
to one or two days before rc6).

There are no messages in the dmesg, besides these:

,----
| [30991.501804] loop: module loaded
| [30991.513337] hfs: create hidden dir...
| [39897.867830] hfs: create hidden dir...
| [39960.061622] hfs: splitting index node...
`----

No stack traces, no nothing. Oh, I still have the disk image that I
created, if it is of any interest.


Regards, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
