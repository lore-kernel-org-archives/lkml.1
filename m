Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbZDQBzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbZDQBzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbZDQBzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:55:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59966 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbZDQBzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:55:45 -0400
Message-ID: <49E7E1CF.6060209@cn.fujitsu.com>
Date: Fri, 17 Apr 2009 09:56:31 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrea Righi <righi.andrea@gmail.com>, Paul Menage <menage@google.com>,
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
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com>	<1239740480-28125-2-git-send-email-righi.andrea@gmail.com> <20090417102417.88a0ef93.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090417102417.88a0ef93.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Tue, 14 Apr 2009 22:21:12 +0200
> Andrea Righi <righi.andrea@gmail.com> wrote:
> 
>> +Example:
>> +* Create an association between an io-throttle group and a bio-cgroup group
>> +  with "bio" and "blockio" subsystems mounted in different mount points:
>> +  # mount -t cgroup -o bio bio-cgroup /mnt/bio-cgroup/
>> +  # cd /mnt/bio-cgroup/
>> +  # mkdir bio-grp
>> +  # cat bio-grp/bio.id
>> +  1
>> +  # mount -t cgroup -o blockio blockio /mnt/io-throttle
>> +  # cd /mnt/io-throttle
>> +  # mkdir foo
>> +  # echo 1 > foo/blockio.bio_id
> 
> Why do we need multiple cgroups at once to track I/O ?
> Seems complicated to me.
> 

IIUC, it also disallows other subsystems to be binded with blockio subsys:
  # mount -t cgroup -o blockio cpuset xxx /mnt
  (failed)

and if a task is moved from cg1(id=1) to cg2(id=2) in bio subsys, this task
will be moved from CG1(id=1) to CG2(id=2) automatically in blockio subsys.

All these are odd, unexpected, complex and bug-prone I think..

