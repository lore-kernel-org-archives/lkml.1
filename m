Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbYFBTBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbYFBTBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 15:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYFBTBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 15:01:08 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12076 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbYFBTBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 15:01:07 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5308"; a="3441191"
Message-ID: <4844437C.2020700@qualcomm.com>
Date: Mon, 02 Jun 2008 12:01:16 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org
Subject: Re: [PATCH] sched: CPU hotplug events must not destroy scheduler
 domains created by the cpusets
References: <1212085023-22284-1-git-send-email-maxk@qualcomm.com> <20080602101902.cf8cdf11.pj@sgi.com>
In-Reply-To: <20080602101902.cf8cdf11.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:

> How about:
>  1) Defining arch_init_sched_domains() for all CONFIGs, CPUSET or not
>     (see for example how free_sched_groups() is defined, NUMA or not)
>  2) Then the ifndef can be removed from here.
>  3) Then the arch_init_sched_domains() can be moved comfortably inside
>     the switch statement.

Paul, I just realized that this won't work. We actually need the default
version of arch_init_sched_domains() which builds the default domain. It's
used during bootup. It's only the hotplug event handling where we do not want
the default.
I could still redo the switch() statement as you suggested but it seems that
it's not going to improve the readability that much at this point.

Max
