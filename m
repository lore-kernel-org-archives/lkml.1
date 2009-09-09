Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbZIIGFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbZIIGFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 02:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZIIGFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 02:05:10 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:41422 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbZIIGFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 02:05:09 -0400
Date: Wed, 09 Sep 2009 15:05:11 +0900 (JST)
Message-Id: <20090909.150511.112608142.ryov@valinux.co.jp>
To: dhaval@linux.vnet.ibm.com
Cc: vgoyal@redhat.com, riel@redhat.com, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com,
       akpm@linux-foundation.org, nauman@google.com,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com
Subject: Re: Regarding dm-ioband tests
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090908170649.GC8828@linux.vnet.ibm.com>
References: <20090908.120119.71095369.ryov@valinux.co.jp>
	<20090908134244.GA15974@redhat.com>
	<20090908170649.GC8828@linux.vnet.ibm.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > > - dm-ioband can use without cgroup. (I remember Vivek said it's not an
> > >   advantage.)
> > 
> > I think this is more of a disadvantage than advantage. We have a very well
> > defined functionality of cgroup in kernel to group the tasks. Now you are
> > coming up with your own method of grouping the tasks which will make life
> > even more confusing for users and application writers.

I know that cgroup is a very well defined functionality, that is why
dm-ioband also supports throttling per cgroup. But how are we supposed
to do throttling on the system which doesn't support cgroup?
As I wrote in another mail to Vivek, I would like to make use of
dm-ioband on RHEL 5.x. 
And I don't think that the grouping methods are not complicated, just
stack a new device on the existing device and assign bandwidth to it,
that is the same method as other device-mapper targets, if you would
like to assign bandwidth per thread, then register the thread's ID to
the device and assign bandwidth to it as well. I don't think it makes
users confused.

> I would tend to agree with this. With other resource management
> controllers using cgroups, having dm-ioband use something different will
> require a different set of userspace tools/libraries to be used.
> Something that will severly limit its usefulness froma programmer's
> perspective.

Once we create a dm-ioband device, the device can be configured
through the cgroup interface. I think it will not severly limit its
usefulness.

Thanks,
Ryo Tsuruta
