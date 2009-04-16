Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbZDPWly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbZDPWly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 18:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZDPWln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 18:41:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754536AbZDPWln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 18:41:43 -0400
Date: Thu, 16 Apr 2009 15:24:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: menage@google.com, balbir@linux.vnet.ibm.com, guijianfeng@cn.fujitsu.com,
       kamezawa.hiroyu@jp.fujitsu.com, agk@sourceware.org, axboe@kernel.dk,
       baramsori72@gmail.com, chlunde@ping.uio.no, dave@linux.vnet.ibm.com,
       dpshah@google.com, eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       taka@valinux.co.jp, lizf@cn.fujitsu.com, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, ryov@valinux.co.jp, s-uchida@ap.jp.nec.com,
       subrata@linux.vnet.ibm.com, yoshikawa.takuya@oss.ntt.co.jp,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] cgroup: io-throttle controller (v13)
Message-Id: <20090416152433.aaaba300.akpm@linux-foundation.org>
In-Reply-To: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com>
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 22:21:11 +0200
Andrea Righi <righi.andrea@gmail.com> wrote:

> Objective
> ~~~~~~~~~
> The objective of the io-throttle controller is to improve IO performance
> predictability of different cgroups that share the same block devices.

We should get an IO controller into Linux.  Does anyone have a reason
why it shouldn't be this one?

> Respect to other priority/weight-based solutions the approach used by
> this controller is to explicitly choke applications' requests

Yes, blocking the offending application at a high level has always
seemed to me to be the best way of implementing the controller.

> that
> directly or indirectly generate IO activity in the system (this
> controller addresses both synchronous IO and writeback/buffered IO).

The problem I've seen with some of the proposed controllers was that
they didn't handle delayed writeback very well, if at all.

Can you explain at a high level but in some detail how this works?  If
an application is doing a huge write(), how is that detected and how is
the application made to throttle?

Does it add new metadata to `struct page' for this?

I assume that the write throttling is also wired up into the MAP_SHARED
write-fault path?



Does this patchset provide a path by which we can implement IO control
for (say) NFS mounts?

