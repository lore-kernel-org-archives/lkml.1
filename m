Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbZI3U1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbZI3U1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbZI3U1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:27:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbZI3U1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:27:22 -0400
Date: Wed, 30 Sep 2009 16:24:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
Subject: Re: IO scheduler based IO controller V10
Message-ID: <20090930202447.GA28236@redhat.com>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com> <4ABC28DE.7050809@datenparkplatz.de> <20090925202636.GC15007@redhat.com> <1253976676.7005.40.camel@marge.simson.net> <1254034500.7933.6.camel@marge.simson.net> <20090927164235.GA23126@kernel.dk> <1254340730.7695.32.camel@marge.simson.net> <1254341139.7695.36.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254341139.7695.36.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 10:05:39PM +0200, Mike Galbraith wrote:
> 
>  
> >  		/*
> > +		 * We may have seeky queues, don't throttle up just yet.
> > +		 */
> > +		if (time_before(jiffies, cfqd->last_seeker + CIC_SEEK_THR))
> > +			return 0;
> > +
> 
> bzzzt.  Window too large, but the though is to let them overload, but
> not instantly.
> 

CIC_SEEK_THR is 8K jiffies so that would be 8seconds on 1000HZ system. Try
using one "slice_idle" period of 8 ms. But it might turn out to be too
short depending on the disk speed.

Thanks
Vivek
