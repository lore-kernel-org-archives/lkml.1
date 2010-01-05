Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357Ab0AEC1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab0AEC1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 21:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218Ab0AEC05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:26:57 -0500
Received: from mga14.intel.com ([143.182.124.37]:40240 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab0AEC04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:26:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="229197837"
Date: Tue, 5 Jan 2010 10:26:50 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC][PATCH v4] readahead: introduce O_RANDOM for
	POSIX_FADV_RANDOM
Message-ID: <20100105022650.GB29428@localhost>
References: <20091225000717.GA26949@yahoo-inc.com> <87aax18xms.fsf@basil.nowhere.org> <20091230051540.GA16308@localhost> <20091230052402.GB26364@localhost> <873a2s8hmp.fsf@basil.nowhere.org> <20100104045020.GA21021@localhost> <20100104161719.a0bb35ad.sfr@canb.auug.org.au> <20100104073328.GA3422@infradead.org> <20100104125620.GB12266@localhost> <20100105130322.006c03ee.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105130322.006c03ee.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 10:03:22AM +0800, Stephen Rothwell wrote:
> On Mon, 4 Jan 2010 20:56:20 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> >
> > For now I'll use bit 040000000, which happen to equal to
> > FMODE_NONOTIFY and will be masked out by __dentry_open()
> > in the very beginning.
> 
> But also clashes with __O_SYNC on sparc, sorry.  I am not sure how we are
> meant to reasonably choose these values any more ...

Where is it? I cannot grep find one in arch/.
There is one defined in include/asm-generic/fcntl.h:

#ifndef O_SYNC
#define __O_SYNC        04000000
#define O_SYNC          (__O_SYNC|O_DSYNC)
#endif

However it has one less '0' :)

Thanks,
Fengguang
