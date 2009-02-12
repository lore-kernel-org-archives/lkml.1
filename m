Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbZBLP1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbZBLP1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 10:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbZBLP1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 10:27:16 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:58943 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbZBLP1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 10:27:15 -0500
Date: Thu, 12 Feb 2009 16:27:14 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: John Ogness <dazukocode@ogness.net>
cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       malware-list@lists.printk.net, eparis@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCHv2 1/5] VFS: DazukoFS, stackable-fs, file access control
In-Reply-To: <861vufgwlt.fsf@johno.fn.ogness.net>
Message-ID: <alpine.LSU.2.00.0902121618500.5658@fbirervta.pbzchgretzou.qr>
References: <8663jrgwo4.fsf@johno.fn.ogness.net> <861vufgwlt.fsf@johno.fn.ogness.net>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2009-02-03 20:15, John Ogness wrote:

>Patch 1: Introduces DazukoFS as a nullfs. This is the raw stackable
>         filesystem part of DazukoFS and does nothing except stack and
>         pass filesystem calls to the lower filesystem.
>
>Patched against 2.6.29-rc3.
>
>Index: linux-2.6.28/Documentation/filesystems/dazukofs.txt
>===================================================================
>--- /dev/null	1970-01-01 00:00:00.000000000 +0000
>+++ linux-2.6.28/Documentation/filesystems/dazukofs.txt	2009-02-03 18:07:44.000000000 +0100
>+
>+=====================
>+ MOUNTING/UNMOUNTING
>+=====================
>+
>+DazukoFS is typically mounted on top of an existing directory. For example,
>+to stack DazukoFS on top of the /opt directory, the following mount(8)
>+command can be given:
>+
>+# mount -t dazukofs /opt /opt
[...]
>+# mount -t dazukofs /opt /mnt
>+
>+When accessing files within /mnt, you will be accessing files in /opt
>+(through DazukoFS). When accessing files directly in /opt, DazukoFS will not
>+be involved.
>+
>+THIS HAS POTENTIAL PROBLEMS!

This ought to be done better in light of the problem that one
could issue `mount -t dazukofs /mnt /opt`
In kernel code, I'm thinking something like

static int foofs_dothis(...)
{
	buf = call d_path on sb->s_root
	call namei_lookup on buf
	use lookup's resulting dentry as source directory
}

This assumes at least that namei_lookup will not return the new SB's
dentry for the given path.
Iff that works out somehow, the 'device' part in the mount command
line is practically ignored like it is for like procfs.


