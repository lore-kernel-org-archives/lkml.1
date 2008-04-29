Return-Path: <linux-kernel-owner+w=401wt.eu-S933840AbYD2Aos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840AbYD2Aos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 20:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbYD2Aok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 20:44:40 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:49401 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751744AbYD2Aoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 20:44:39 -0400
Date: Tue, 29 Apr 2008 09:44:38 +0900 (JST)
Message-Id: <20080429.094438.48502686.ryov@valinux.co.jp>
To: fw@strlen.de
Cc: s-uchida@ap.jp.nec.com, vtaras@openvz.org, axboe@kernel.dk,
       m-takahashi@ex.jp.nec.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, tom-sugawara@ap.jp.nec.com,
       devel@openvz.org
Subject: Re: [Devel] Re: [RFC][v2][patch 0/12][CFQ-cgroup]Yet another I/O
 bandwidth controlling subsystem for CGroups based on CFQ
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20080425213702.GL19845@Chamillionaire.breakpoint.cc>
References: <005d01c89559$9e538200$dafa8600$@jp.nec.com>
	<20080425.185444.115924172.ryov@valinux.co.jp>
	<20080425213702.GL19845@Chamillionaire.breakpoint.cc>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

> Here are a few results.

Thank you very much.

> What i found surprising is that Satoshis scheduler has
> about twice of the io count...

Of my previous results, Satoshi's scheduler has about twice of the io
count on the write test, but both io counts on the read test are
nearly the same.

Here are another results. The test procedure is as follows:
  o Prepare 3 partitions sdc2, sdc3 and sdc4.
  o Run 50 processes for sdc2, 100 processes for sdc3 and 150 processes
    for sdc4. Apply I/O loads in inverse to the priority level.
  o Each process issuing random read/write direct I/O with 4KB data.
  o Count up the number of I/Os which have done in 60 seconds.

               The number of I/Os (percentage to total I/Os)
   -------------------------------------------------------------------
  | partition       |    sdc2     |    sdc3     |    sdc4     | total |
  | processes       |     50      |    100      |    150      |  I/Os |
  |-----------------+-------------+-------------+-------------|-------|
  | Normal          |  2281(18%)  |  4287(34%)  |  6005(48%)  | 12573 |
  |-----------------+-------------+-------------+-------------+-------|
  | Vasily's sched. |             |             |             |       |
  | cgroup priority |  7(highest) |     4       |  0(lowest)  |       |
  |                 |  3713(24%)  |  6587(42%)  |  5354(34%)  | 15654 |
  |-----------------+-------------+-------------+-------------+-------|
  | Satoshi's sched.|             |             |             |       |
  | cgroup priority |  0(highest) |     4       |  7(lowest)  |       |
  |                 |  5399(42%)  |  6506(50%)  |  1034( 8%)  | 12939 |
   -------------------------------------------------------------------

Satoshi's scheduler suppressed the I/O to the lowest priority
partition better than Vasily's one, but Vasily's scheduler got the
highest total I/Os.

Thanks,
Ryo Tsuruta
