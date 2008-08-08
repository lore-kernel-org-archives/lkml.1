Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbYHHLl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbYHHLl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 07:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbYHHLlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 07:41:15 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:54220 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754215AbYHHLlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 07:41:14 -0400
Date: Fri, 08 Aug 2008 20:41:13 +0900 (JST)
Message-Id: <20080808.204113.39165145.ryov@valinux.co.jp>
To: yoshikawa.takuya@oss.ntt.co.jp
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, agk@sourceware.org
Subject: Re: [PATCH 6/7] bio-cgroup: Implement the bio-cgroup
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <489C150C.5040700@oss.ntt.co.jp>
References: <489BF14D.6050009@oss.ntt.co.jp>
	<20080808.173045.112614776.ryov@valinux.co.jp>
	<489C150C.5040700@oss.ntt.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yoshikawa-san,

> I wanted to test my own scheduler which uses bio tracking information.
> SO I tried your patch, especially, get_bio_cgroup_iocontext(), to get
> the io_context from bio.
>
> In my test, I made some threads with certain iopriorities run
> concurrently. To schedule these threads based on their iopriorities,
> I made BGROUP directories for each iopriorities.
> e.g. /cgroup/bio/be0 ... /cgroup/bio/be7
> Then, I tried to attach the processes to the appropriate groups.
> 
> But the processes stayed in the original group(id=0).

In the current implementation, when a process moves to an another cgroup:
  - Already allocated memory does not move to the cgroup, still remains.
  - Only allocated memory after move belongs to the cgroup.
This behavior follows the memory controller.

Memory does not move between cgroups since it is so heavy operation, 
but it would be worth under some sort of conditions.

Could you try to move a process between cgroups in the following way?

   # echo $$ > /cgroup/bio/be0
   # run_your_program
   # echo $$ > /cgroup/bio/be1
   # run_your_program
   ...

> I am sorry but I have to leave now and I cannot come here next week.
> --> I will take summer holidays.

Have a nice vacation!

Thanks,
Ryo Tsuruta
