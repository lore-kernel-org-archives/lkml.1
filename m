Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbYFVWua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbYFVWua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 18:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbYFVWuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 18:50:20 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:38580 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754409AbYFVWuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 18:50:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABdyXkh5LG+u/2dsb2JhbACtTA
X-IronPort-AV: E=Sophos;i="4.27,686,1204464600"; 
   d="scan'208";a="132509979"
Date: Mon, 23 Jun 2008 08:50:14 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, cmm@us.ibm.com,
       linux-ext4@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext2: Use page_mkwrite vma_operations to get mmap
	write notification.
Message-ID: <20080622225014.GC11558@disturbed>
Mail-Followup-To: Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, linux-ext4@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <1212685513-32237-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080605123045.445e380a.akpm@linux-foundation.org> <20080611150845.GA21910@skywalker> <20080611120749.d0c5a7de.akpm@linux-foundation.org> <20080612161706.GB12367@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612161706.GB12367@duck.suse.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 06:17:06PM +0200, Jan Kara wrote:
>   BTW: XFS, OCFS2 or GFS2 define page_mkwrite() in this manner so they do
> return SIGBUS when you run out of space when writing to mmapped hole. So
> it's not like this change is introducing completely new behavior... I can
> understand that we might not want to change the behavior for ext2 or ext3
> but ext4 is IMO definitely free to choose.

Yup, and it's the only sane behaviour, IMO. Letting the application
continue to oversubscribe filesystem space and then throwing away
the data that can't be written well after the fact (potentially
after the application has gone away) is a horrendously bad failure
mode.

This was one of the main publicised features of ->page_mkwrite() -
that it would allow up front detection of ENOSPC conditions during
mmap writes. I'm extremely surprised to see that this is being
considered undesirable after all this time....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
