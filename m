Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbYLPKjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbYLPKjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 05:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYLPKi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 05:38:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48917 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbYLPKi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 05:38:57 -0500
Date: Tue, 16 Dec 2008 11:36:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: balbir@linux.vnet.ibm.com, hugh@veritas.com, jlan@sgi.com,
       jpirko@redhat.com, jlim@sgi.com, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RESEND] introduce get_mm_hiwater_xxx(), fix
	taskstats->hiwater_xxx accounting
Message-ID: <20081216103626.GA3964@redhat.com>
References: <20081212140524.GA29488@redhat.com> <20081215162148.87fd38a5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081215162148.87fd38a5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15, Andrew Morton wrote:
>
> On Fri, 12 Dec 2008 15:05:24 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > +#define get_mm_hiwater_rss(mm)	max((mm)->hiwater_rss, get_mm_rss(mm))
>
> This evaluates its argument thrice.
>
> > +#define get_mm_hiwater_vm(mm)	max((mm)->hiwater_vm, (mm)->total_vm)
>
> This evaluates its argument twice.

I thought that any user should be careful anyway...

OK, agreed, will send the cleanup.

> was sched.h the appropriate header in which to implement these?  Maybe...

Just because I'd like to put them near update_hiwater_xxx()

> But they're only ever _used_ in kernel/tsacct.c, so do they actually
> need to be implemented in any .h file?

Jiri cooks the patch which implements rusage->ru_maxrss accounting,
it will use the first helper.

Oleg.

