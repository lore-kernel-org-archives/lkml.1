Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbZDQJ4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbZDQJ4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 05:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757984AbZDQJ4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 05:56:04 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:52691 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757818AbZDQJ4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 05:56:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=jt2PURVTuV7Bu/JGlbuL6Rycs/KUFBUEsEXomnCfZZ2aAnqAQRsHI0hblS6OT1TB8C
         exBoKOdPgSsnY2FBqugmSG1P5GNcqqyHCDsb7pIY/5hef9PgjgFlYGa4R66EKoO5e42r
         ta2k9VijlEBzatyNaJ/SlqR4J1+3NJ4a+ofYo=
Date: Fri, 17 Apr 2009 11:55:56 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] io-throttle documentation
Message-ID: <20090417095555.GD8689@linux>
Mail-Followup-To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Paul Menage <menage@google.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Gui Jianfeng <guijianfeng@cn.fujitsu.com>, agk@sourceware.org,
	akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
	Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
	Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
	fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
	Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
	dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
	roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
	Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
	yoshikawa.takuya@oss.ntt.co.jp,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com> <1239740480-28125-2-git-send-email-righi.andrea@gmail.com> <20090417102417.88a0ef93.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417102417.88a0ef93.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 10:24:17AM +0900, KAMEZAWA Hiroyuki wrote:
> On Tue, 14 Apr 2009 22:21:12 +0200
> Andrea Righi <righi.andrea@gmail.com> wrote:
> 
> > +Example:
> > +* Create an association between an io-throttle group and a bio-cgroup group
> > +  with "bio" and "blockio" subsystems mounted in different mount points:
> > +  # mount -t cgroup -o bio bio-cgroup /mnt/bio-cgroup/
> > +  # cd /mnt/bio-cgroup/
> > +  # mkdir bio-grp
> > +  # cat bio-grp/bio.id
> > +  1
> > +  # mount -t cgroup -o blockio blockio /mnt/io-throttle
> > +  # cd /mnt/io-throttle
> > +  # mkdir foo
> > +  # echo 1 > foo/blockio.bio_id
> 
> Why do we need multiple cgroups at once to track I/O ?
> Seems complicated to me.
> 
> Thanks,
> -Kame

I totally agree. I could easily merge the bio-cgroup functionality in
io-throttle or implement this as an infrastructure framework, using a
single controller and remove this complication.

For now, since the decisions on IO controllers are not definitive at
all, I privileged flexibility and I simply decided to be a plain user of
bio-cgroup to quickly adapt my patch to the future bio-cgroup
development.

Thanks,
-Andrea
