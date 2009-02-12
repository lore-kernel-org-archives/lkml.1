Return-Path: <linux-kernel-owner+w=401wt.eu-S1759305AbZBLP7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305AbZBLP7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 10:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZBLP7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 10:59:44 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:56380 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbZBLP7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 10:59:43 -0500
Date: Thu, 12 Feb 2009 16:59:41 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: John Ogness <dazukocode@ogness.net>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, eparis@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCHv2 1/5] VFS: DazukoFS, stackable-fs, file access control
In-Reply-To: <20090212153146.GG28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LSU.2.00.0902121640580.5658@fbirervta.pbzchgretzou.qr>
References: <8663jrgwo4.fsf@johno.fn.ogness.net> <861vufgwlt.fsf@johno.fn.ogness.net> <alpine.LSU.2.00.0902121618500.5658@fbirervta.pbzchgretzou.qr> <20090212153146.GG28946@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2009-02-12 16:31, Al Viro wrote:
>On Thu, Feb 12, 2009 at 04:27:14PM +0100, Jan Engelhardt wrote:
>
>> This ought to be done better in light of the problem that one
>> could issue `mount -t dazukofs /mnt /opt`
>> In kernel code, I'm thinking something like
>> 
>> static int foofs_dothis(...)
>> {
>> 	buf = call d_path on sb->s_root
>
>Call what on what?  There is no such thing as the mountpoint of superblock.
>
In fs/namespace.c:do_new_mount there is 'path'. If 'path' was passed
down to the filesystem, path->dentry, I would assume, could be used
by the filesystem as a pointer to the original directory which
dazuko is going to shadow.
