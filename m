Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318Ab0AED1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab0AED1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 22:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040Ab0AED1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 22:27:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:32300 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973Ab0AED1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 22:27:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="229212194"
Date: Tue, 5 Jan 2010 11:27:15 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>, Eric Paris <eparis@redhat.com>
Subject: Re: [RFC][PATCH v5] readahead: introduce O_RANDOM for
	POSIX_FADV_RANDOM
Message-ID: <20100105032715.GA1044@localhost>
References: <20091230052402.GB26364@localhost> <873a2s8hmp.fsf@basil.nowhere.org> <20100104045020.GA21021@localhost> <20100104161719.a0bb35ad.sfr@canb.auug.org.au> <20100104073328.GA3422@infradead.org> <20100104125620.GB12266@localhost> <20100105130322.006c03ee.sfr@canb.auug.org.au> <20100105022650.GB29428@localhost> <20100105132824.e6c0fb7f.sfr@canb.auug.org.au> <20100105031801.GA591@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105031801.GA591@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 11:18:01AM +0800, Wu Fengguang wrote:
>  
> +/*
> + * usage of open(O_RANDOM) is disabled: __dentry_open() will nuke this bit
> + */
> +#ifndef O_RANDOM
> +#define O_RANDOM	0200000000	/* random access pattern hint */
> +#endif
> +

Tested with this program, output is

        flags=0x9001 O_SYNC=0x1000 O_RANDOM=0

My user space O_SYNC is still the old O_DSYNC. But should be OK to
test the sparc O_SYNC.

------------------------------------------------------------------------------
#include <fcntl.h>
#include <stdio.h>

#define O_RANDOM       040000000       /* random access pattern hint */

int main (void)
{
	int fd, flags;

	fd = open("/tmp/fcntl-test",
		  O_WRONLY | O_CREAT | O_SYNC | O_RANDOM, 0666);
	flags = fcntl(fd, F_GETFL, 0);
	printf("flags=%#lx O_SYNC=%#lx O_RANDOM=%#lx\n",
	       flags, flags & O_SYNC, flags & O_RANDOM);
}
------------------------------------------------------------------------------

Thanks,
Fengguang
