Return-Path: <linux-kernel-owner+w=401wt.eu-S1752012AbZKCKlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbZKCKlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZKCKli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:41:38 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:36884 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbZKCKlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:41:37 -0500
To: Benjamin LaHaise <bcrl@lhnet.ca>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Octavian Purdila <opurdila@ixiacom.com>, netdev@vger.kernel.org,
       Cosmin Ratiu <cratiu@ixiacom.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sysfs directory scaling: rbtree for dirent name lookups
References: <20091101163130.GA7911@kvack.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Nov 2009 02:41:37 -0800
In-Reply-To: <20091101163130.GA7911@kvack.org> (Benjamin LaHaise's message of "Sun\, 1 Nov 2009 11\:31\:30 -0500")
Message-ID: <m1ocnjdh5q.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin LaHaise <bcrl@lhnet.ca> writes:

> Use an rbtree in sysfs_dirent to speed up file lookup times
>
> Systems with large numbers (tens of thousands and more) of network 
> interfaces stress the sysfs code in ways that make the linear search for 
> a name match take far too long.  Avoid this by using an rbtree.

Please take a look at the cleanups_scaling branch at:
kernel.org:/pub/scm/linux/kernel/git/ebiederm/linux-2.6.32-rc5-sysfs-enhancements

I haven't spent a lot of time on it but it is possible to get everything
except the rbtree without increasing the size of sysfs_dirent.  Also we
don't need the both the rbtree and a linked list.

In particular see:
commit 50623bbb82da3bd1d596b9173a91ed1b5aa168b8
Author: Eric W. Biederman <ebiederm@maxwell.aristanetworks.com>
Date:   Sat Oct 31 04:11:18 2009 -0700

    sysfs: Sort sysfs directories by name hash.
    
    This is a step in preparation for introducing a more efficient
    data structure than a linked list for sysfs entries.  By ordering
    by name hash instead of by inode sysfs_lookup can be speeded
    up as well as allowing restarting after seekdir.
    
    Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Meanwhile back to pushing the most important ones for real.

Eric
