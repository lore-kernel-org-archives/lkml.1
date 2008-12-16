Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbYLPKoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbYLPKoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 05:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYLPKoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 05:44:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49046 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbYLPKoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 05:44:12 -0500
Date: Tue, 16 Dec 2008 11:43:59 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, balbir@linux.vnet.ibm.com,
       hugh@veritas.com, jlan@sgi.com, jlim@sgi.com,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RESEND] introduce get_mm_hiwater_xxx(), fix
 taskstats->hiwater_xxx accounting
Message-ID: <20081216114359.50c83bb6@psychotron.englab.brq.redhat.com>
In-Reply-To: <20081215162148.87fd38a5.akpm@linux-foundation.org>
References: <20081212140524.GA29488@redhat.com>
	<20081215162148.87fd38a5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2008 16:21:48 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> > +#define get_mm_hiwater_rss(mm)	max((mm)->hiwater_rss, get_mm_rss(mm))
> 
> This evaluates its argument thrice.
> 
> > +#define get_mm_hiwater_vm(mm)	max((mm)->hiwater_vm, (mm)->total_vm)
> 
> This evaluates its argument twice.
> 
> 
> was sched.h the appropriate header in which to implement these?  Maybe...
I think it was. There are similar helpers at the same place.
> 
> But they're only ever _used_ in kernel/tsacct.c, so do they actually
> need to be implemented in any .h file?
Yes because my patch (ru_maxrss filling) will be using
get_mm_hiwater_rss() from kernel/exit.c and kernel/sys.c
> 
