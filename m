Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbZKCQlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbZKCQlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 11:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZKCQll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 11:41:41 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:32307 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750778AbZKCQll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 11:41:41 -0500
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/3] sysfs directory scaling: rbtree for dirent name lookups
Date: Tue, 3 Nov 2009 18:38:47 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-trunk-686; KDE/4.3.2; i686; ; )
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@xmission.com>, netdev@vger.kernel.org,
       Cosmin Ratiu <cratiu@ixiacom.com>, linux-kernel@vger.kernel.org
References: <20091101163130.GA7911@kvack.org> <4AEFCA49.4020305@gmail.com> <20091103160715.GD23857@kroah.com>
In-Reply-To: <20091103160715.GD23857@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911031838.47168.opurdila@ixiacom.com>
X-OriginalArrivalTime: 03 Nov 2009 16:41:44.0946 (UTC) FILETIME=[8765AD20:01CA5CA4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 November 2009 18:07:15 you wrote:

> > > What kind of test are you doing to reproduce this?
> >
> > Its curious because in my tests the biggest problems come from
> > kernel/sysctl.c (__register_sysctl_paths) consuming 80% of cpu
> > in following attempt to create 20.000 devices
> >
> > (disable hotplug before trying this, and ipv6 too !)
> > modprobe dummy numdummies=20000
> >
> > I believe we should address __register_sysctl_paths() scalability
> > problems too.
> 
> But registering 20000 devices is a far different problem from using
> those 20000 devices :)
> 
> I think the "use the device" path should be the one we care the most
> about fixing up, as that is much more common than the register path for
> all users.
> 

For sysctl in general probably, but I would argue that for dynamic network 
interfaces (ppp and other sorts of tunnels) the "use" and "register" paths are 
not that unbalanced.

For our case where we use up to 128K interfaces, sysctl entries per network 
interface is pretty much unusable - but I agree that is not a very common case 
:) 

However [1] is not so far fetched.

[1] http://www.spinics.net/lists/netdev/msg110392.html

Thanks,
tavi
