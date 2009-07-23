Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbZGWLge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbZGWLge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 07:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbZGWLgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 07:36:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:48832 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983AbZGWLgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 07:36:32 -0400
From: Ludwig Nussel <ludwig.nussel@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] implement uid mount option for ext2 and ext3
Date: Thu, 23 Jul 2009 13:36:29 +0200
Message-Id: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When using 'real' file systems on removable storage devices such as
hard disks or usb sticks people quickly face the problem that their
Linux users have different uids on different machines. Therefore one
cannot modify or even read files created on a different machine
without running chown as root or storing everything with mode 777.
Simple file systems such as vfat don't have that problem as they
don't store file ownership information and one can pass the uid
files should belong to as mount option.

The following two patches (for 2.6.31-rc4) therefore implement the
uid mount option for ext2 and ext3 to make them actually useful on
removable media. My implementation just writes uid 0 to disk for
files that are owned by the specified user. In read direction files
with uid 0 appear as being owned by the specified user.

In an ideal world this would probably be implemented as vfs feature
rather than having it in every single file system.

Anyways, AFAICT the method works just fine for ext2. I'm not sure
about the ext3 patch though as ext3 has that ext3_setattr() function
for journaling. I don't know if the uid should better be mangled
there instead.

cu
Ludwig

-- 
 (o_   Ludwig Nussel
 //\   
 V_/_  http://www.suse.de/
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nuernberg)
