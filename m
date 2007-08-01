Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbXHAU7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbXHAU7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 16:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbXHAU7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 16:59:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44712 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbXHAU7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 16:59:02 -0400
Date: Thu, 2 Aug 2007 02:41:26 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Chris Rankin <rankincj@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux 2.6.22 - Atomic counter underflow in NFS
In-Reply-To: <272608.90315.qm@web52904.mail.re2.yahoo.com>
Message-ID: <alpine.LFD.0.999.0708020237090.8258@enigma.security.iitk.ac.in>
References: <272608.90315.qm@web52904.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,


On Wed, 1 Aug 2007, Chris Rankin wrote:

> I am running a 2.6.22 kernel on a dual P4 Xeon (HT enabled) with 2 GB RAM, and I have just found
> this BUG in my dmesg log:
> 
> nfsd: last server has exited
> nfsd: unexporting all filesystems
> BUG: atomic counter underflow at:
>  [<c01a382a>] kref_put+0x66/0x84
>  [<c0188bc2>] sysfs_hash_and_remove+0xb8/0x12d
>  [<c0188bca>] sysfs_hash_and_remove+0xc0/0x12d
>  [<c01522e2>] sysfs_slab_alias+0x19/0x5c
>  [<c0152438>] sysfs_slab_add+0x113/0x124
>  [<c01527de>] kmem_cache_create+0x12d/0x1d3
>  [<f8d9df1b>] nfs4_state_start+0x3b/0x1a7 [nfsd]
>  [<f8d8a485>] nfsd_svc+0x51/0x10d [nfsd]
>  [<f8d8ae76>] write_threads+0x65/0x96 [nfsd]
>  [<c016c279>] simple_transaction_get+0x70/0x82
>  [<f8d8ae11>] write_threads+0x0/0x96 [nfsd]
>  [<f8d8ab9f>] nfsctl_transaction_write+0x36/0x5c [nfsd]
>  [<f8d8ab69>] nfsctl_transaction_write+0x0/0x5c [nfsd]
>  [<c0155392>] vfs_write+0x8a/0x10c
>  [<c0155901>] sys_write+0x41/0x67
>  [<c010266e>] sysenter_past_esp+0x5f/0x85
>  =======================
> NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> NFSD: starting 90-second grace period

I expect this is easy to reproduce at will (when shutting down nfs
services, probably), right?

Please try the latest mainline -git kernel (say 2.6.23-rc1-git10 from
kernel.org) and let us know if this still occurs? There were some fixes
regarding sysfs symlink refcounting that went in recently, and this looks
like one of those cases to me.


Thanks,
Satyam
