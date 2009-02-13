Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbZBMTeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbZBMTeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 14:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbZBMTeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 14:34:10 -0500
Received: from www.tglx.de ([62.245.132.106]:59960 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbZBMTeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 14:34:09 -0500
To: Jan Engelhardt <jengelh@medozas.de>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       malware-list@lists.printk.net, eparis@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCHv2 1/5] VFS: DazukoFS, stackable-fs, file access control
From: John Ogness <dazukocode@ogness.net>
References: <8663jrgwo4.fsf@johno.fn.ogness.net>
	<861vufgwlt.fsf@johno.fn.ogness.net>
	<alpine.LSU.2.00.0902121618500.5658@fbirervta.pbzchgretzou.qr>
Date: Fri, 13 Feb 2009 20:31:03 +0100
In-Reply-To: <alpine.LSU.2.00.0902121618500.5658@fbirervta.pbzchgretzou.qr> (Jan Engelhardt's message of "Thu\, 12 Feb 2009 16\:27\:14 +0100 \(CET\)")
Message-ID: <86y6wagmmg.fsf@johno.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-02-12, Jan Engelhardt <jengelh@medozas.de> wrote:
>>+DazukoFS is typically mounted on top of an existing directory. For example,
>>+to stack DazukoFS on top of the /opt directory, the following mount(8)
>>+command can be given:
>>+
>>+# mount -t dazukofs /opt /opt
> [...]
>>+# mount -t dazukofs /opt /mnt
>>+
>>+When accessing files within /mnt, you will be accessing files in /opt
>>+(through DazukoFS). When accessing files directly in /opt, DazukoFS will not
>>+be involved.
>>+
>>+THIS HAS POTENTIAL PROBLEMS!
>
> This ought to be done better in light of the problem that one
> could issue `mount -t dazukofs /mnt /opt`
> In kernel code, I'm thinking something like
>
> static int foofs_dothis(...)
> {
> 	buf = call d_path on sb->s_root
> 	call namei_lookup on buf
> 	use lookup's resulting dentry as source directory
> }
>
> This assumes at least that namei_lookup will not return the new SB's
> dentry for the given path.
> Iff that works out somehow, the 'device' part in the mount command
> line is practically ignored like it is for like procfs.

If we want to forbid users from being able to do this, I think it
would be simpler just to fail the mount if it is _not_ specified for
direct stacking. This forces users to use a syntax that makes it very
clear what they are doing.

Since mounting to a different directory could cause problems, I think
it will be good to forbid it. I will make this change for the next
patch series.

John Ogness
