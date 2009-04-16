Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbZDPMAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbZDPMAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 08:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbZDPMAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 08:00:05 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:45249 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752618AbZDPMAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 08:00:03 -0400
Date: Thu, 16 Apr 2009 21:00:02 +0900 (JST)
Message-Id: <20090416.210002.193701676.ryov@valinux.co.jp>
To: righi.andrea@gmail.com
Cc: kamezawa.hiroyu@jp.fujitsu.com, menage@google.com,
       balbir@linux.vnet.ibm.com, guijianfeng@cn.fujitsu.com,
       agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       baramsori72@gmail.com, chlunde@ping.uio.no, dave@linux.vnet.ibm.com,
       dpshah@google.com, eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       taka@valinux.co.jp, lizf@cn.fujitsu.com, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, s-uchida@ap.jp.nec.com, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] bio-cgroup controller
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090416104234.GA6656@linux>
References: <20090415132356.GA19270@linux>
	<20090416085814.8b6d077f.kamezawa.hiroyu@jp.fujitsu.com>
	<20090416104234.GA6656@linux>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea and Kamezawa-san,

> > > +#ifdef CONFIG_CGROUP_BIO
> > > +/*
> > > + * use lower 16 bits for flags and reserve the rest for the bio-cgroup id
> > > + */
> > > +#define BIO_CGROUP_ID_SHIFT	(16)
> > > +#define BIO_CGROUP_ID_BITS (8 * sizeof(unsigned long) - BIO_CGROUP_ID_SHIFT)
> > > +
> > > +static inline unsigned long page_cgroup_get_bio_id(struct page_cgroup *pc)
> > > +{
> > > +	return pc->flags >> BIO_CGROUP_ID_SHIFT;
> > > +}
> > > +
> > > +static inline void page_cgroup_set_bio_id(struct page_cgroup *pc,
> > > +				unsigned long id)
> > > +{
> > > +	WARN_ON(id >= (1UL << BIO_CGROUP_ID_BITS));
> > > +	pc->flags &= (1UL << BIO_CGROUP_ID_SHIFT) - 1;
> > > +	pc->flags |= (unsigned long)(id << BIO_CGROUP_ID_SHIFT);
> > > +}
> > > +#endif
> > > +
> > Ah, there is "Lock" bit in pc->flags and above "set" code does read-modify-write
> > without lock_page_cgroup().
> > 
> > Could you use lock_page_cgroup() or cmpxchg ? (or using something magical technique ?)
> 
> If I'm not wrong this should guarantee atomicity without using
> lock_page_cgroup().

I'll consider carefully how is the best way to minimize the overhead
as far as possible.
First, I'll post the new bio-cgroup patches that use css_id as
bio_cgroup_id soon.

Thanks,
Ryo Tsuruta
