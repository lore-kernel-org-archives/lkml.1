Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbYIZFio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbYIZFio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 01:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYIZFic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 01:38:32 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:52789 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbYIZFia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 01:38:30 -0400
Message-ID: <48DC7553.8040708@nttdata.co.jp>
Date: Fri, 26 Sep 2008 14:38:27 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.17) Gecko/20080914 Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       haradats@nttdata.co.jp,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [TOMOYO #9 (2.6.27-rc7-mm1) 1/6] LSM adapter functions.
References: <20080924090317.359685535@nttdata.co.jp> <20080924090338.407746083@nttdata.co.jp> <20080925165954.GA25587@us.ibm.com>
In-Reply-To: <20080925165954.GA25587@us.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Sep 2008 05:38:28.0125 (UTC) FILETIME=[1A2B74D0:01C91F9A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> > So IMO there is some major badness here in the form of copying all of
> > those functions out of fs/namei.c.  I think we need to discuss
> > case-by-case whether using the functions is appropriate (and hence
> > they should be made non-static in fs/namei.c), or whether the intended
> > goal should be met some other way.  For instance:
Indeed.

To perform DAC before MAC, cloning DAC code (like this patch) or some
modifications against existing kernel code (such as non-static
may_open()) are needed.

This posting is the result of our intention that all changes should
be within security/* . We are now aiming TOMOYO Linux to be merged
without messing up the existing kernel code. (Also we put the code of
singly linked list TOMOYO Linux uses not in include/linux/list.h but
in security/tomoyo/common.h to avoid recomplilation.)

We are ready to remove DAC code in TOMOYO Linux LSM module for now.
(But DAC should be performed before MAC, it's our future work.) Since
DAC is performed after security_path_*() hooks, this approach has no
impact to the semantics of TOMOYO Linux. Is it preferable?

> > likewise...  (except in the case of fifo/sock, devcgroup should not be
> > consulted as I'm not sure it'll handle that properly - have you tested
> > tis with the device cgroup enabled?)
Not tested yet... But I don't think problem occurs.

Regards,

