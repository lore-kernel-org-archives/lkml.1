Return-Path: <linux-kernel-owner+w=401wt.eu-S1760828AbYDVDKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828AbYDVDKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 23:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756224AbYDVDJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 23:09:56 -0400
Received: from sandeen.net ([209.173.210.139]:27544 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbYDVDJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 23:09:56 -0400
Message-ID: <480D5702.2060107@sandeen.net>
Date: Mon, 21 Apr 2008 22:09:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: David Chinner <dgc@sgi.com>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] xfs: do not pass size into kmem_free, it's unused
References: <20080419142329.GA5339@elte.hu> <200804212151.02241.vda.linux@googlemail.com> <20080422012819.GT108924158@sgi.com> <200804220433.04030.vda.linux@googlemail.com>
In-Reply-To: <200804220433.04030.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> Hi David,
> 
>> Patches are welcome - I'd be over the moon if any of the known 4k
>> stack advocates sent a stack reduction patch for XFS, but it seems
>> that actually trying to fix the problems is much harder than
>> resending a one line patch every few months....
> 
> kmem_free() function takes (ptr, size) arguments but doesn't
> actually use second one.
> 
> This patch removes size argument from all callsites.

I didn't expect it to but this does reduce a few things slightly.

On x86_64:

-xfs_attr_leaf_list_int 200
+xfs_attr_leaf_list_int 184

-xfs_dir2_sf_to_block 136
+xfs_dir2_sf_to_block 120

-xfs_ifree_cluster 136
+xfs_ifree_cluster 120

-xfs_inumbers 184
+xfs_inumbers 168

-xfs_mount_free 24

Thanks,
-Eric

