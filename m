Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbYAJWFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbYAJWFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbYAJWEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:04:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:29603 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbYAJWEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:04:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=HflAF4nOmwYely4LSzKm6cva4+BpyRs6gWeTYg2PtOTjKu8HLapWRIWKZUmVFwdfNWwM2pVT3vkUUeGF5lxIEmWIOER7dRwtR4Jz93IcX6fvv1dPtynkjkFFtljE4E0iYqMVwOYYwqBMSUSQyNwfZIEDP2JHDwOVyfoZrQOyWaQ=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 00/16] udf: cleanup
Date: Thu, 10 Jan 2008 23:06:16 +0100
Message-Id: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patchset contains various UDF fs cleanups.
It deprecates two patchsets I sent lately:

http://lkml.org/lkml/2008/1/5/196 [PATCH 0/6] udf: improve code related to super_block v3
http://lkml.org/lkml/2008/1/5/211 [PATCH 0/7] udf: more cleanups

I hope I addressed all comments sent by Christoph Hellwig and Jan Kara.
Thanks for review!

[PATCH 01/16] udf: fix coding style of super.c
[PATCH 02/16] udf: remove some ugly macros
[PATCH 03/16] udf: convert UDF_SB_ALLOC_PARTMAPS macro to udf_sb_alloc_partition_maps function
[PATCH 04/16] udf: check if udf_load_logicalvol failed
[PATCH 05/16] udf: convert macros related to bitmaps to functions
[PATCH 06/16] udf: move calculating of nr_groups into helper function
[PATCH 07/16] udf: fix sparse warnings (shadowing & mismatch between declaration and definition)
[PATCH 08/16] udf: fix coding style
[PATCH 09/16] udf: create common function for tag checksumming
[PATCH 10/16] udf: create common function for changing free space counter
[PATCH 11/16] udf: replace loops coded with goto to real loops
[PATCH 12/16] udf: convert byte order of constant instead of variable
[PATCH 13/16] udf: remove UDF_I_* macros and open code them
[PATCH 14/16] udf: cache struct udf_inode_info

These patches are new:
[PATCH 15/16] udf: fix udf_debug macro
[PATCH 16/16] udf: improve readability of udf_load_partition

 fs/udf/balloc.c           |  491 ++++++++++++---------
 fs/udf/crc.c              |    2 +-
 fs/udf/dir.c              |    8 +-
 fs/udf/directory.c        |   94 +++--
 fs/udf/file.c             |   43 ++-
 fs/udf/ialloc.c           |   94 +++--
 fs/udf/inode.c            |  957 +++++++++++++++++++++++-----------------
 fs/udf/misc.c             |  146 ++++---
 fs/udf/namei.c            |  413 ++++++++++-------
 fs/udf/partition.c        |  197 ++++++---
 fs/udf/super.c            | 1081 ++++++++++++++++++++++++++++-----------------
 fs/udf/symlink.c          |    9 +-
 fs/udf/truncate.c         |  100 +++--
 fs/udf/udf_i.h            |   16 -
 fs/udf/udf_sb.h           |   88 +----
 fs/udf/udfdecl.h          |   11 +-
 fs/udf/udftime.c          |   59 ++--
 fs/udf/unicode.c          |   85 ++--
 include/linux/udf_fs.h    |    4 +-
 include/linux/udf_fs_sb.h |   12 +-
 20 files changed, 2261 insertions(+), 1649 deletions(-)

This patchset depends on udf patches in -mm.
Runtime tested: mount, open, read, seek, close, unmount.

Marcin Slusarz
