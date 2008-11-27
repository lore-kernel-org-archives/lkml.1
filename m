Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbYK0KF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbYK0KF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYK0KFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:05:05 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:52292 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbYK0KFC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:05:02 -0500
Message-ID: <492E70B6.70108@cosmosbay.com>
Date: Thu, 27 Nov 2008 11:04:38 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 6/6] fs: Introduce kern_mount_special() to mount	special
 vfs
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com> <20081121083044.GL16242@elte.hu> <49267694.1030506@cosmosbay.com> <20081121.010508.40225532.davem@davemloft.net> <4926AEDB.10007@cosmosbay.com> <4926D022.5060008@cosmosbay.com> <20081121152148.GA20388@elte.hu> <4926D39D.9050603@cosmosbay.com> <20081121153453.GA23713@elte.hu> <492DDCAB.1070204@cosmosbay.com> <20081127095321.GE13860@infradead.org>
In-Reply-To: <20081127095321.GE13860@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 27 Nov 2008 11:04:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig a écrit :
> On Thu, Nov 27, 2008 at 12:32:59AM +0100, Eric Dumazet wrote:
>> This function arms a flag (MNT_SPECIAL) on the vfs, to avoid
>> refcounting on permanent system vfs.
>> Use this function for sockets, pipes, anonymous fds.
> 
> special is not a useful name for a flag, by definition everything that
> needs a flag is special compared to the version that doesn't need a
> flag.
> 
> The general idea of skippign the writer counts makes sense, but please
> give it a descriptive name that explains the not unmountable thing.
> And please kill your kern_mount wrapper and just set the flag manually.
> 
> Also I think it should be a superblock flag, not a mount flag as you
> don't want thse to differ for multiple mounts of the same filesystem.
> 
> 

Hum.. we have a superblock flag already, but testing it in mntput()/mntget()
is going to be a litle bit expensive if we add a derefence ?

if (mnt && mnt->mnt_sb->s_flags & MS_SPECIAL) {
   ...
}

