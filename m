Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYHHOcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYHHOcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 10:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYHHObv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 10:31:51 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:44302 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751918AbYHHObv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 10:31:51 -0400
Date: Fri, 08 Aug 2008 23:31:50 +0900 (JST)
Message-Id: <20080808.233150.02266833.taka@valinux.co.jp>
To: fernando@oss.ntt.co.jp
Cc: dave@linux.vnet.ibm.com, ryov@valinux.co.jp,
       yoshikawa.takuya@oss.ntt.co.jp, uchida@ap.jp.nec.com, ngupta@google.com,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, agk@sourceware.org,
       righi.andrea@gmail.com
Subject: Re: RFC: I/O bandwidth controller
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20080808.152119.43521725.taka@valinux.co.jp>
References: <1217870433.20260.101.camel@nimitz>
	<1217985189.3154.57.camel@sebastian.kern.oss.ntt.co.jp>
	<20080808.152119.43521725.taka@valinux.co.jp>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Fernando,

> >   - Implement a block layer resource controller. dm-ioband is a working
> > solution and feature rich but its dependency on the dm infrastructure is
> > likely to find opposition (the dm layer does not handle barriers
> > properly and the maximum size of I/O requests can be limited in some
> > cases). In such a case, we could either try to build a standalone
> > resource controller based on dm-ioband (which would probably hook into
> > generic_make_request) or try to come up with something new.
> 
> I doubt about the maximum size of I/O requests problem. You can't avoid
> this problem as far as you use device mapper modules with such a bad
> manner, even if the controller is implemented as a stand-alone controller.
> There is no limitation if you only use dm-ioband without any other device
> mapper modules.

Ryo told me this isn't true anymore. The dm infrastructure introduced
a new feature to support multiple page-sized I/O requests, that was
just merged to the current linux tree. So you and me don't need to
worry about this stuff anymore.

Ryo said he was going to make dm-ioband support this new feature and
post the patches soon.

> And I think the device mapper team just started designing barriers support.
> I guess it won't take long. Right, Alasdair?
> We should know it is logically impossible to support barriers on some
> types of device mapper modules such as LVM. You can't avoid the barrier
> problem when you use this kind of multiple devices even if you implement
> the controller in the block layer.
> 
> But I think a stand-alone implementation will have a merit that it
> makes it easier to setup the configuration rather than dm-ioband.
> From this point of view, it would be good that you move the algorithm
> of dm-ioband into the block layer.
> On the other hand, we should know it will make it impossible to use
> the dm infrastructure from the controller, though it isn't so rich.
> 
> >   - If the I/O tracking patches make it into the kernel we could move on
> > and try to get the Cgroup extensions to CFQ and AS mentioned before (see
> > (1), (2), and (3) above for details) merged.
> >   - Delegate the task of controlling the rate at which a task can
> > generate dirty pages to the memory controller.
> > 
> > This RFC is somewhat vague but my feeling is that we build some
> > consensus on the goals and basic design aspects before delving into
> > implementation details.
> > 
> > I would appreciate your comments and feedback.
> > 
> > - Fernando

Thanks,
Hirokazu Takahashi.
