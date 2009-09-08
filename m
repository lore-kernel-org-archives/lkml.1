Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbZIHDBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbZIHDBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 23:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbZIHDBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 23:01:18 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:60607 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbZIHDBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 23:01:17 -0400
Date: Tue, 08 Sep 2009 12:01:19 +0900 (JST)
Message-Id: <20090908.120119.71095369.ryov@valinux.co.jp>
To: riel@redhat.com
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, agk@redhat.com, akpm@linux-foundation.org,
       nauman@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com
Subject: Re: Regarding dm-ioband tests
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <4AA51065.6050000@redhat.com>
References: <20090904231129.GA3689@redhat.com>
	<20090907.200222.193693062.ryov@valinux.co.jp>
	<4AA51065.6050000@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

Rik van Riel <riel@redhat.com> wrote:
> Ryo Tsuruta wrote:
> 
> > However, if you want to get fairness in a case like this, a new
> > bandwidth control policy which controls accurately according to
> > assigned weights can be added to dm-ioband.
> 
> Are you saying that dm-ioband is purposely unfair,
> until a certain load level is reached?

Not unfair, dm-ioband(weight policy) is intentionally designed to
use bandwidth efficiently, weight policy tries to give spare bandwidth
of inactive groups to active groups.

> > We regarded reducing throughput loss rather than reducing duration
> > as the design of dm-ioband. Of course, it is possible to make a new
> > policy which reduces duration.
> 
> ... while also reducing overall system throughput
> by design?

I think it reduces system throughput compared to the current
implementation, because it causes more overhead to do fine grained
control. 

> Why are you even bothering to submit this to the
> linux-kernel mailing list, when there is a codebase
> available that has no throughput or fairness regressions?
> (Vivek's io scheduler based io controler)

I think there are some advantages to dm-ioband. That's why I post
dm-ioband to the mailing list.

- dm-ioband supports not only proportional weight policy but also rate
  limiting policy. Besides, new policies can be added to dm-ioband if
  a user wants to control bandwidth by his or her own policy.
- The dm-ioband driver can be replaced without stopping the system by
  using device-mapper's facility. It's easy to maintain.
- dm-ioband can use without cgroup. (I remember Vivek said it's not an
  advantage.)

Thanks,
Ryo Tsuruta
