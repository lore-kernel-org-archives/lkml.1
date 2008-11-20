Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbYKTJTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbYKTJTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 04:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYKTJTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 04:19:19 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:37713 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751926AbYKTJTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 04:19:17 -0500
Date: Thu, 20 Nov 2008 18:20:53 +0900 (JST)
Message-Id: <20081120.182053.220301508585579959.ryov@valinux.co.jp>
To: vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       taka@valinux.co.jp, righi.andrea@gmail.com, s-uchida@ap.jp.nec.com,
       fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com,
       akpm@linux-foundation.org, menage@google.com, ngupta@google.com,
       riel@redhat.com, jmoyer@redhat.com, peterz@infradead.org,
       fchecconi@gmail.com, paolo.valente@unimore.it
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20081113221304.GH7542@redhat.com>
References: <20081113.180558.519459540419535699.ryov@valinux.co.jp>
	<20081113155834.GE7542@redhat.com>
	<20081113221304.GH7542@redhat.com>
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Sorry for late reply.

> > > Do you have any benchmark results?
> > > I'm especially interested in the followings:
> > > - Comparison of disk performance with and without the I/O controller patch.
> > 
> > If I dynamically disable the bio control, then I did not observe any
> > impact on performance. Because in that case practically it boils down
> > to just an additional variable check in __make_request().
> > 
> 
> Oh.., I understood your question wrong. You are looking for what's the 
> performance penalty if I enable the IO controller on a device.

Yes, that is what I want to know.

> I have not done any extensive benchmarking. If I run two dd commands
> without controller, I get 80MB/s from disk (roughly 40 MB for each task).
> With bio group enabled (default token=2000), I was getting total BW of
> roughly 68 MB/s.
>
> I have not done any performance analysis or optimizations at this point of
> time. I plan to do that once we have some sort of common understanding about
> a particular approach. There are so many IO controllers floating, right now
> I am more concerned if we can all come to a common platform.

I understood the reason of posting the patch well.

> Ryo, do you still want to stick to two level scheduling? Given the problem
> of it breaking down underlying scheduler's assumptions, probably it makes
> more sense to the IO control at each individual IO scheduler.

I don't want to stick to it. I'm considering implementing dm-ioband's
algorithm into the block I/O layer experimentally.

Thanks,
Ryo Tsuruta
