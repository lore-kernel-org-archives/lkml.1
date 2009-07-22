Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbZGVSdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbZGVSdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 14:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZGVSdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 14:33:33 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:36751 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZGVSdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 14:33:32 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Wed, 22 Jul 2009 12:32:44 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
In-reply-to: <20090721235904.42e6cd35.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       dm-devel@redhat.com
Message-id: <20090722183244.GO4231@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <19041.4714.686158.130252@notabene.brown>
 <20090721235904.42e6cd35.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 21, 2009  23:59 -0700, Andrew Morton wrote:
> On Sat, 18 Jul 2009 10:08:10 +1000 Neil Brown <neilb@suse.de> wrote:
> I expect that the VFS could be made to work with 64-bit pgoff_t fairly
> easily.  The generated code will be pretty damn sad.
> 
> radix-trees use a ulong index, so we would need a new
> lib/radix_tree64.c or some other means of fixing that up.
> 
> The bigger problem is filesystems - they'll each need to be checked,
> tested, fixed and enabled.  It's probably not too bad for the
> mainstream filesystems which mostly bounce their operations into VFS
> libarary functions anyway.

I don't think this is a primary concern for most filesystems even today.
Filesystems that work correctly > 16TB on 64-bit platforms should continue
to work correctly on 32-bit platforms.  ext4 and XFS will be fine, and
we can slap a "refuse to mount > 16TB filesystem on 32-bit" check in
*_fill_super() for the other filesystems, ext3 included.  Maintainers can
veto that if they think it will work, and for the rest I don't think
anyone will even notice.

> There's perhaps a middle ground - support >16TB devices, but not >16TB
> partitions.  That way everything remains 32-bit and we just have to get
> the offsetting right (probably already the case).
> 
> So now /dev/sda1, /dev/sda2 etc are all <16TB.  The remaining problem
> is that /dev/sda is >16TB.  I expect that we could arrange for the
> kernel to error out if userspace tries to access /dev/sda beyond the
> 16TB point, and those very very few applications which want to touch
> that part of the disk will need to be written using direct-io, (or
> perhaps sgio) or run on 64-bit machines.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

