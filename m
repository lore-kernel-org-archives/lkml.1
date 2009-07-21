Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZGUJiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZGUJiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 05:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZGUJiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 05:38:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59265 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbZGUJiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 05:38:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 21 Jul 2009 18:36:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ebiederm@xmission.com, xiyou.wangcong@gmail.com, tao.ma@oracle.com,
       linux-kernel@vger.kernel.org, adobriyan@gmail.com,
       mtk.manpages@gmail.com, y-goto@jp.fujitsu.com
Subject: [RFC][PATCH 0/3] kcore: clean up and update ram information
 properly
Message-Id: <20090721183628.edbb7b99.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090717152955.6585cbf9.akpm@linux-foundation.org>
References: <m11vpqvozl.fsf@fess.ebiederm.org>
	<20090613040958.GA2959@cr0>
	<m17hzdhkr8.fsf@fess.ebiederm.org>
	<2375c9f90906160829g3d605836yb4c5b9beeac50c5f@mail.gmail.com>
	<m1my88568n.fsf@fess.ebiederm.org>
	<20090618030051.GA6133@cr0.nay.redhat.com>
	<m1tz2ei54r.fsf@fess.ebiederm.org>
	<20090618044055.GB6133@cr0.nay.redhat.com>
	<m1prd2rtdf.fsf@fess.ebiederm.org>
	<20090622085405.GA6499@cr0.nay.redhat.com>
	<20090630100850.GD5873@cr0.nay.redhat.com>
	<20090701144742.6ce3535b.akpm@linux-foundation.org>
	<m14otwq94e.fsf@fess.ebiederm.org>
	<20090701171249.004968e8.akpm@linux-foundation.org>
	<20090702094138.f86ead92.kamezawa.hiroyu@jp.fujitsu.com>
	<20090717152955.6585cbf9.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now, /proc/kcore is built on kclist information which is constructed at boot.
This kclist includes physical memory range information but not updated at
memory hotplug. And, this information tends to includes big memory hole.

On the other hand, /proc/iomem includes all physical memory information as
"System RAM" and this is updated properly and kdump use this, IIUC. 
(I hope all archtecuture stores necessary information...)

This patch tries to build kclist for physical memory(direct map) on
/proc/iomem info. It's refreshed at open("/proc/kcore",) if necesasry.

This is just a RFC. Any comments are welcome.

[1/3] ... clean up kclist handling.
[2/3] ... clean up kclist_add()
[3/3] ... use /proc/iomem information for /proc/kcore.


I can only test x86-64. 

Thanks,
-Kame

