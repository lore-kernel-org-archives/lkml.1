Return-Path: <linux-kernel-owner+w=401wt.eu-S1762765AbZD3NVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762765AbZD3NVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761135AbZD3NVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:21:12 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:34875 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355AbZD3NVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:21:11 -0400
Message-ID: <49F9A5BA.9030100@hp.com>
Date: Thu, 30 Apr 2009 09:20:58 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Andrea Righi <righi.andrea@gmail.com>
CC: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
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
Subject: Re: [PATCH 0/9] cgroup: io-throttle controller (v13)
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com>
In-Reply-To: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea -

FYI: I ran a simple test using this code to try and gauge the overhead
incurred by enabling this technology. Using a single 400GB volume split
into two 200GB partitions I ran two processes in parallel performing a
mkfs (ext2) on each partition. First w/out cgroup io-throttle and then
with it enabled (with each task having throttling enabled to
400MB/second (much, much more than the device is actually capable of
doing)). The idea here is to see the base overhead of just having the
io-throttle code in the paths.

Doing 30 runs of each (w/out & w/ io-throttle enabled) shows very little
difference (time in seconds)

w/out: min=80.196 avg=80.585 max=81.030 sdev=0.215 spread=0.834
with:  min=80.402 avg=80.836 max=81.623 sdev=0.327 spread=1.221

So only around 0.3% overhead - and that may not be conclusive with the
standard deviations seen.

--

FYI: The test was run on 2.6.30-rc1+your patches on a 16-way x86_64 box
(128GB RAM) plus a single FC volume off of a 1Gb FC RAID controller.

Regards,
Alan D. Brunelle
Hewlett-Packard
