Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbZLBBLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbZLBBLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 20:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbZLBBLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 20:11:47 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43350 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbZLBBLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 20:11:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=lic4bXeKvffLuA+9dK33crB6KlkcXcsQQXdPBIwrzah+EUeuEWuLI/PSjk4h9nawje
         Y5P5KdKI42NYoLmOssuz3OYEP7Rp+4B/Bof3ZPjHVqG6IylTFNUI5GcXYPzSW3qtdklA
         Lx7jsUtwmeCJ5ai1AzWr/diHEEGI68Hs/h6kE=
MIME-Version: 1.0
Date: Wed, 2 Dec 2009 04:11:52 +0300
Message-ID: <a4423d670912011711s584f46d2y8a583618abe4a620@mail.gmail.com>
Subject: 2.6.32-rc8: pohmelfs: NULL pointer dereference
From: Alexander Beregalov <a.beregalov@gmail.com>
To: zbr@ioremap.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jens.axboe@oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

BUG: unable to handle kernel NULL pointer dereference at 000000b8
IP: [<c10a96f9>] bdi_queue_work+0x9/0xa0

 [<c10a97e6>] ? sync_inodes_sb+0x46/0x120
 [<c13cbafd>] ? printk+0x18/0x1b
 [<f840d8cb>] ? pohmelfs_kill_super+0xb/0x20 [pohmelfs]
 [<c1090b8a>] ? deactivate_locked_super+0x4a/0x70
 [<c1090ccf>] ? get_sb_nodev+0x6f/0x80
 [<f840d8fc>] ? pohmelfs_get_sb+0x1c/0x20 [pohmelfs]
 [<f840e120>] ? pohmelfs_fill_super+0x0/0x530 [pohmelfs]
 [<c108fe50>] ? vfs_kern_mount+0x40/0xd0


The problem is that pohmelfs_fill_super() does not set sb->s_bdi.
Behavior was changed by
b6e51316da writeback: separate starting of sync vs opportunistic writeback
d8a8559cd7 writeback: get rid of generic_sync_sb_inodes() export
