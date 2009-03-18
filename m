Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbZCRRqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbZCRRqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 13:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757844AbZCRRqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 13:46:17 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:12245 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756376AbZCRRqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 13:46:15 -0400
Message-ID: <49C1331D.1080805@panasas.com>
Date: Wed, 18 Mar 2009 19:45:01 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>, Evgeniy Polyakov <zbr@ioremap.net>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCHSET 0/8 version 4] exofs for kernel 2.6.30
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Mar 2009 17:46:11.0822 (UTC) FILETIME=[6D39A0E0:01C9A7F1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What's new since last iteration:

* I completely re-wrote the [PATCH 4/8] exofs: address_space_operations
  in which we actually write/read to/from osd-storage. The difference is
  that now we try to accumulate as many contiguous pages as possible and
  send them as one large request. As opposed to writing each page at a
  time, in the previous patchset.

* [PATCH 5/8] exofs: dir_inode and directory operations received lots
  of love thanks to Evgeniy Polyakov's grate comments.

exofs is a file system that uses an OSD device as it's back store.

OSD is a new T10 command set that views storage devices not as a large/flat
array of sectors but as a container of objects, each having a length, quota,
time attributes and more. Each object is addressed by a 64bit ID, and is
contained in a 64bit ID partition. Each object has associated attributes
attached to it, which are integral part of the object and provide metadata about
the object. The standard defines some common obligatory attributes, but user
attributes can be added as needed.

Here is the list of patches
[PATCH 1/8] exofs: Kbuild, Headers and osd utils
[PATCH 2/8] exofs: file and file_inode operations
[PATCH 3/8] exofs: symlink_inode and fast_symlink_inode operations
[PATCH 4/8] exofs: address_space_operations
[PATCH 5/8] exofs: dir_inode and directory operations
[PATCH 6/8] exofs: super_operations and file_system_type
[PATCH 7/8] exofs: Documentation
[PATCH 8/8] fs: Add exofs to Kernel build

This patchset is also available on:
  git-clone git://git.open-osd.org/linux-open-osd.git linux-next
or on the web at:
  http://git.open-osd.org/gitweb.cgi?p=linux-open-osd.git;a=shortlog;h=refs/heads/linux-next

(Above tree is based on Linus v2.6.29-rc8-212-g8144737)

If anyone wants to actually run this code and test it
then please start reading at:
    http://open-osd.org
You will need to checkout the out-of-tree git (below) for the user-mode utilities.
Also the exofs.txt file in patch 7/8 should help

If you want to review the user-mode library and supporting plumbings,
  git-clone git://git.open-osd.org/open-osd.git
or on the web at:
  http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=summary

Boaz

