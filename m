Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbZKDTMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbZKDTMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757850AbZKDTMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:12:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757812AbZKDTMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:12:48 -0500
Date: Wed, 4 Nov 2009 14:12:32 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 11/20] blkio: Some CFQ debugging Aid
Message-ID: <20091104191232.GI2870@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <1257291837-6246-12-git-send-email-vgoyal@redhat.com> <x49hbtat94s.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49hbtat94s.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 01:52:51PM -0500, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > o Some CFQ debugging Aid.
> 
> Some CFQ debugging aids.  Sorry, I couldn't help myself.
> 

It thought this was all about IO controller and not english grammar. :-)

Will fix it.

> > +config DEBUG_BLK_CGROUP
> > +	bool
> > +	depends on BLK_CGROUP
> > +	default n
> > +	---help---
> > +	Enable some debugging help. Currently it stores the cgroup path
> > +	in the blk group which can be used by cfq for tracing various
> > +	group related activity.
> > +
> >  endif # BLOCK
> >  
> 
> > +config DEBUG_CFQ_IOSCHED
> > +	bool "Debug CFQ Scheduling"
> > +	depends on CFQ_GROUP_IOSCHED
> > +	select DEBUG_BLK_CGROUP
> 
> This seems wrong.  DEBUG_CFQ_IOSCHED sounds like it enables debugging of
> CFQ.  In your implementation, though, it only enables this in tandem
> with the blkio cgroup infrastructure.  Please decouple these things.
> 

What's wrong with this? We are emitting more debugging information for
CFQ like cgroup name and paths in blktrace output. That's a different
thing that internally that information is also dependent debugging being
enabled in blk io controller.

Important thing here is that blk io controller and its debugging option is
automatically selected depending on what user wants from end policies.

So I really can't see that what's wrong if CFQ debugging option internally
selects some other config option also.
 

> > +#ifdef CONFIG_DEBUG_BLK_CGROUP
> > +	/* Store cgroup path */
> > +	char path[128];
> > +#endif
> 
> Where does 128 come from?  What's wrong with PATH_MAX?

CFS influence (kernel/sched_debug.c)

Actually PATH_MAX will be 4096 bytes. Too long to display in blktrace
output? I have not check what's the blktrace limit but we don't want too
long a lines in output. 

Thanks
Vivek
