Return-Path: <linux-kernel-owner+w=401wt.eu-S965287AbXCAPih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965287AbXCAPih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965289AbXCAPih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:38:37 -0500
Received: from p02c11o145.mxlogic.net ([208.65.145.68]:34039 "EHLO
	p02c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965287AbXCAPig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:38:36 -0500
Subject: Re: wait_for_completion_timeout problem ???
From: Eli Cohen <eli@mellanox.co.il>
Reply-To: eli@mellanox.co.il
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <b647ffbd0703010714m5f8546ebw95ec607b38ba7e1@mail.gmail.com>
References: <1172755932.5175.37.camel@mtls03>
	 <b647ffbd0703010628u253a62cfi56cec22a1ee79d5f@mail.gmail.com>
	 <1172760574.5175.42.camel@mtls03>
	 <b647ffbd0703010714m5f8546ebw95ec607b38ba7e1@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Mellanox Technologies
Date: Thu, 01 Mar 2007 17:39:23 +0200
Message-Id: <1172763563.25580.5.camel@mtls03>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
X-Spam: [F=0.0100000000; S=0.010(2007010901)]
X-MAIL-FROM: <eli@mellanox.co.il>
X-SOURCE-IP: [194.90.237.34]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 16:14 +0100, Dmitry Adamushko wrote:

> Mea culpa. Don't know why I took it as 10 ms.. Yep, in case of seconds
> it rather becomes a mere theoretical possibility.
> 
> Are you sure there are no other "waiters" being blocked on the same
> "completion" at the same time? complete_all()?
> 
> Anyway, do "cat /proc/your_task_pid/status" and look at the "State: "
> field. It should be "R" in case wake_up_*() was called for this task.
> 

Thanks for your good advices. Right now it seems that increasing the
timeout to 60 sec did the trick :-)
The test I was running has many threads and maybe there is starvation of
tasks. The system is also not too responsive to say the least.
