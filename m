Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbZBDGtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbZBDGtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 01:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbZBDGto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 01:49:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54247 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbZBDGto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 01:49:44 -0500
Message-ID: <49893A5A.7000506@cn.fujitsu.com>
Date: Wed, 04 Feb 2009 14:48:58 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [-mm patch] Show memcg information during OOM (v3)
References: <20090203172135.GF918@balbir.in.ibm.com> <4988E727.8030807@cn.fujitsu.com> <20090204033750.GB4456@balbir.in.ibm.com> <20090204142455.83c38ad6.kamezawa.hiroyu@jp.fujitsu.com> <20090204064249.GC4456@balbir.in.ibm.com>
In-Reply-To: <20090204064249.GC4456@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> BTW, I wonder can't we show the path of mount point ?
>> /group_A/01 is /cgroup/group_A/01 and /group_A/ is /cgroup/group_A/ on this system.
>> Very difficult ?
>>
> 
> No, it is not very difficult, we just need to append the mount point.
> The reason for not doing it is consistency with output of
> /proc/<pid>/cgroup and other places where cgroup_path prints the path
> relative to the mount point. Since we are talking about memory, the
> administrator should know where it is mounted. Do you strongly feel
> the need to add mount point? My concern is consistency with other
> cgroup output (look at /proc/sched_debug) for example.
> 

Another reason to not do so is, we can mount a specific hierarchy to
multiple mount points.
	# mount -t cgroup -o memory /mnt
	# mount -t cgroup -o memory /cgroup
	# mkdir /mnt/0
Now, /mnt/0 is the same with /cgroup/0.

