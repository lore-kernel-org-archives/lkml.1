Return-Path: <linux-kernel-owner+w=401wt.eu-S1760510AbXJYMRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760510AbXJYMRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 08:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbXJYMRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 08:17:23 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:52128 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbXJYMRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 08:17:21 -0400
To: arjan@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2.6.24-rc1]EXPORT_SYMBOL(__set_page_dirty_no_writeback);
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200710250015.FFG17175.LSHOMOFVJFOFtQ@I-love.SAKURA.ne.jp>
	<20071024091027.541d2e98@laptopd505.fenrus.org>
	<200710250636.JHG87098.VtOSQMFJOHLOFF@I-love.SAKURA.ne.jp>
	<20071024144147.7313d4c1@laptopd505.fenrus.org>
In-Reply-To: <20071024144147.7313d4c1@laptopd505.fenrus.org>
Message-Id: <200710252117.BCE17673.LFFMVQOOOHJFSt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Thu, 25 Oct 2007 21:17:15 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Arjan van de Ven wrote:
> when will you post this filesystem for inclusion into kernel.org kernel?
> (and please really consider posting the patch together with that patch)
> (also, if you can give a pointer to the source code of this filesystem
> you might even get early code review)

I have proposed this filesystem at http://lkml.org/lkml/2004/11/1/48 .

In short, the filesystem I'm developing is a trivial device filesystem
that provides protection mechanism against tampering.

Reasons I don't use devfs/udev or fuse or LSM for /dev are:

  The devfs/udev don't provide protection mechanism against tampering.
  I don't know implementation that can enforce filename and it's attributes.
  Label based access control like SELinux doesn't distinguish
  /dev/sda1 and /dev/sda2, do they?
  If a process who is permitted to unlink and create /dev/sda1 and /dev/sda2 is cracked,
  who can ensure that /dev/sda1 is block-8-1 and /dev/sda2 is block-8-2?
  A situation /dev/sda1 is block-8-2 and /dev/sda2 is block-8-1 can happen.

  /dev has to be valid throughout the lifetime of system
  (i.e. from /sbin/init till power failure).
  Filesystems using fuse will freeze when a system starts /usr/bin/killall at shutdown script,
  where it is too early to stop working of /dev partition.

  LSM is used by SELinux, thus there is unlikely chance to call my module
  to validate a device file's filename and it's attributes.

The latest snapshot (which is not following codingstyle) is at
http://svn.sourceforge.jp/cgi-bin/viewcvs.cgi/*checkout*/trunk/1.5.x/ccs-patch/include/linux/syaoran.h?content-type=text%2Fplain&rev=588&root=tomoyo
http://svn.sourceforge.jp/cgi-bin/viewcvs.cgi/*checkout*/trunk/1.5.x/ccs-patch/fs/syaoran_2.6.c?content-type=text%2Fplain&rev=614&root=tomoyo

If there is a chance for inclusion into kernel.org kernel, I'm willing to fix codingstyle and submit immediately.

Thank you.

