Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbZDTPBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbZDTPBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 11:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbZDTPA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 11:00:58 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:60986 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663AbZDTPA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 11:00:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=MGx0aRnxPDHzdt5XlKxzOWhp8JKvYtmQtb+DsHggN3/X2j3KL4PdE0Lm03vHetw6rn
         DZqcLGHTuRoI2GBpjx4t35Pdkzs9MxtyVoUsyJk2g9llXlaN6bfvGlLovft59AvbBca1
         y7pNUU+kOYi/nUPA6YKgVqAAyJrx9XDmtcKuE=
Date: Mon, 20 Apr 2009 17:00:53 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com,
       balbir@linux.vnet.ibm.com, guijianfeng@cn.fujitsu.com,
       agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       baramsori72@gmail.com, chlunde@ping.uio.no, dave@linux.vnet.ibm.com,
       dpshah@google.com, eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       taka@valinux.co.jp, matt@bluehost.com, dradford@bluehost.com,
       ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
       s-uchida@ap.jp.nec.com, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] io-throttle documentation
Message-ID: <20090420150052.GC13307@linux>
Mail-Followup-To: Ryo Tsuruta <ryov@valinux.co.jp>, lizf@cn.fujitsu.com,
	kamezawa.hiroyu@jp.fujitsu.com, menage@google.com,
	balbir@linux.vnet.ibm.com, guijianfeng@cn.fujitsu.com,
	agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
	baramsori72@gmail.com, chlunde@ping.uio.no, dave@linux.vnet.ibm.com,
	dpshah@google.com, eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
	taka@valinux.co.jp, matt@bluehost.com, dradford@bluehost.com,
	ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
	s-uchida@ap.jp.nec.com, subrata@linux.vnet.ibm.com,
	yoshikawa.takuya@oss.ntt.co.jp,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20090417102417.88a0ef93.kamezawa.hiroyu@jp.fujitsu.com> <49E7E1CF.6060209@cn.fujitsu.com> <20090417102539.GA16838@linux> <20090420.183815.226804723.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420.183815.226804723.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 06:38:15PM +0900, Ryo Tsuruta wrote:
> Hi Andrea, 
> 
> > Implementing bio-cgroup functionality as pure infrastructure framework
> > instead of a cgroup subsystem would remove all this oddity and
> > complexity.
> > 
> > For example, the actual functionality that I need for the io-throttle
> > controller is just an interface to set and get the cgroup owner of a
> > page. I think it should be the same also for other potential users of
> > bio-cgroup.
> > 
> > So, what about implementing the bio-cgroup functionality as cgroup "page
> > tracking" infrastructure and provide the following interfaces:
> > 
> > /*
> >  * Encode the cgrp->css.id in page_group->flags
> >  */
> > void set_cgroup_page_owner(struct page *page, struct cgroup *cgrp);
> > 
> > /*
> >  * Returns the cgroup owner of a page, decoding the cgroup id from
> >  * page_cgroup->flags.
> >  */
> > struct cgroup *get_cgroup_page_owner(struct page *page);
> > 
> > This also wouldn't increase the size of page_cgroup because we can
> > encode the cgroup id in the unused bits of page_cgroup->flags, as
> > originally suggested by Kame.
> > 
> > And I think it could be used also by dm-ioband, even if it's not a
> > cgroup-based subsystem... but I may be wrong. Ryo what's your opinion?
> 
> I looked your page_cgroup patch in io-throttle v14, It can also be used
> by dm-ioband. But I'd like to eliminate lock_page_cgroup() to minimize
> overhead. I'll rearrange the bio-cgroup patch according to the functions.

It would be great! Anyway, I don't think it's a trivial task to
completely remove lock_page_cgroup(), especially if we decide to encode
the ID in page_cgroup->flags.

Thanks,
-Andrea
