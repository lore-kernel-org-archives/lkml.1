Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbZDQKZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbZDQKZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 06:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbZDQKZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 06:25:46 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:58354 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122AbZDQKZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 06:25:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=UQyw11H9orKpCusZCmIaANo1f0WlPBMJSuorl2oG+KGZ8fiNy6Z1g7btgKxqZH8SYU
         0y09K2yaLjX1krJ/XljJzA4Wg/Ic9i8NcPmsPGo5qEcKDOoCJtZdRfvjDjqDNyj/eX52
         QrE29BH3mBfGCP6gE+AL0YJ6Zh8/rhZavXHXs=
Date: Fri, 17 Apr 2009 12:25:40 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       matt@bluehost.com, dradford@bluehost.com, ngupta@google.com,
       randy.dunlap@oracle.com, roberto@unbit.it,
       Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] io-throttle documentation
Message-ID: <20090417102539.GA16838@linux>
Mail-Followup-To: Li Zefan <lizf@cn.fujitsu.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Paul Menage <menage@google.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Gui Jianfeng <guijianfeng@cn.fujitsu.com>, agk@sourceware.org,
	akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
	Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
	Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
	fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
	matt@bluehost.com, dradford@bluehost.com, ngupta@google.com,
	randy.dunlap@oracle.com, roberto@unbit.it,
	Ryo Tsuruta <ryov@valinux.co.jp>,
	Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
	yoshikawa.takuya@oss.ntt.co.jp,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com> <1239740480-28125-2-git-send-email-righi.andrea@gmail.com> <20090417102417.88a0ef93.kamezawa.hiroyu@jp.fujitsu.com> <49E7E1CF.6060209@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E7E1CF.6060209@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 09:56:31AM +0800, Li Zefan wrote:
> KAMEZAWA Hiroyuki wrote:
> > On Tue, 14 Apr 2009 22:21:12 +0200
> > Andrea Righi <righi.andrea@gmail.com> wrote:
> > 
> >> +Example:
> >> +* Create an association between an io-throttle group and a bio-cgroup group
> >> +  with "bio" and "blockio" subsystems mounted in different mount points:
> >> +  # mount -t cgroup -o bio bio-cgroup /mnt/bio-cgroup/
> >> +  # cd /mnt/bio-cgroup/
> >> +  # mkdir bio-grp
> >> +  # cat bio-grp/bio.id
> >> +  1
> >> +  # mount -t cgroup -o blockio blockio /mnt/io-throttle
> >> +  # cd /mnt/io-throttle
> >> +  # mkdir foo
> >> +  # echo 1 > foo/blockio.bio_id
> > 
> > Why do we need multiple cgroups at once to track I/O ?
> > Seems complicated to me.
> > 
> 
> IIUC, it also disallows other subsystems to be binded with blockio subsys:
>   # mount -t cgroup -o blockio cpuset xxx /mnt
>   (failed)
> 
> and if a task is moved from cg1(id=1) to cg2(id=2) in bio subsys, this task
> will be moved from CG1(id=1) to CG2(id=2) automatically in blockio subsys.
> 
> All these are odd, unexpected, complex and bug-prone I think..

Implementing bio-cgroup functionality as pure infrastructure framework
instead of a cgroup subsystem would remove all this oddity and
complexity.

For example, the actual functionality that I need for the io-throttle
controller is just an interface to set and get the cgroup owner of a
page. I think it should be the same also for other potential users of
bio-cgroup.

So, what about implementing the bio-cgroup functionality as cgroup "page
tracking" infrastructure and provide the following interfaces:

/*
 * Encode the cgrp->css.id in page_group->flags
 */
void set_cgroup_page_owner(struct page *page, struct cgroup *cgrp);

/*
 * Returns the cgroup owner of a page, decoding the cgroup id from
 * page_cgroup->flags.
 */
struct cgroup *get_cgroup_page_owner(struct page *page);

This also wouldn't increase the size of page_cgroup because we can
encode the cgroup id in the unused bits of page_cgroup->flags, as
originally suggested by Kame.

And I think it could be used also by dm-ioband, even if it's not a
cgroup-based subsystem... but I may be wrong. Ryo what's your opinion?

-Andrea
