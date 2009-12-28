Return-Path: <linux-kernel-owner+w=401wt.eu-S1752125AbZL1RRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbZL1RRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 12:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbZL1RRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 12:17:43 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47952 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZL1RRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 12:17:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sCjxR2dOJ5+4r/PYRSBiyLvCnzLiCcnMRno4k/ICah7Mz6m2zQSSp+0j9j+61dpV3Y
         XbAoeLXfHZuIH+9E6uq8anO1xGu+t/A/GVph689yisD9TZs1YMt5u4ZdUxJVMBIN/U6B
         zu4dD4wpe2CHe1KarUL8swT9FzaXxmLZLV9zk=
Date: Mon, 28 Dec 2009 18:17:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33-rc0: reiserfs: inconsistent lock state
Message-ID: <20091228171733.GA5014@nowhere>
References: <a4423d670912111406g5967eb1fw93e49de242fbf54@mail.gmail.com> <20091214110921.GA5168@nowhere> <a4423d670912141211q3e63011ftfd526ec541b09d44@mail.gmail.com> <20091216224117.GA5014@nowhere> <a4423d670912200409w51690618i229b31c8c00f8dc4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670912200409w51690618i229b31c8c00f8dc4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 03:09:33PM +0300, Alexander Beregalov wrote:
> Hi Frederic
> 
> This is Linus's v2.6.33-rc1-96-gdd59f6c
> plus your 47376ceba5 "reiserfs: Fix reiserfs lock <-> inode mutex
> dependency inversion"
> 
> [ INFO: inconsistent lock state ]
> 2.6.33-rc1-00101-g476ef56 #1
> ---------------------------------
> inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
> kswapd0/313 [HC0[0]:SC0[0]:HE1:SE1] takes:
>  (&REISERFS_SB(s)->lock){+.+.?.}, at: [<c1111048>]
> reiserfs_write_lock_once+0x28/0x50
> {RECLAIM_FS-ON-W} state was registered at:
>   [<c104e522>] mark_held_locks+0x62/0x90
>   [<c104e5ea>] lockdep_trace_alloc+0x9a/0xc0
>   [<c108efa6>] kmem_cache_alloc+0x26/0xf0
>   [<c1085a0c>] __get_vm_area_node+0x6c/0xf0
>   [<c10860fe>] __vmalloc_node+0x7e/0xa0
>   [<c108629b>] vmalloc+0x2b/0x30
>   [<c110d4ba>] journal_init+0x2a/0x9f0



Oh right, I fixed a vmalloc under reiserfs lock
in the mount path but there are some others remaining.

Will fix, thanks!

