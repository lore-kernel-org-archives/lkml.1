Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933933Ab0BQC4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 21:56:41 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54398 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933664Ab0BQC4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 21:56:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 17 Feb 2010 11:53:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Leonidas ." <leonidas137@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Notification when a task is created/exits
Message-Id: <20100217115313.30de11fb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <f22d86811002152148t4f307184kb71757f4621f82db@mail.gmail.com>
References: <f22d86811002152148t4f307184kb71757f4621f82db@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010 11:18:25 +0530
"Leonidas ." <leonidas137@gmail.com> wrote:

> Hi folks,
> 
> Is it possible to register a set of callbacks from my module so that
> these call backs get called
> whenever a certain task is created or exits. Basically, I want to keep
> track of all the threads
> which are created and are exiting, my module should get notified of
> these events somehow.
> One way is to call my functions directly from the task creation and
> exit functions, but I personally
> do not like this approach since I dont want to mess with this core kernel code.
> 

AFAIK, there are no extensible notifier chain at task create/exit.
But I think you have 2 options.

 1. use NETLINK and catch task create/exit in userland.
    But this means "catch" is asyncronous.

 2. implement cgroup subsystem
    AFAIK, in the latest kernel, cgroup subsystem can be implemented as module. 
    cgroup has fork/exit handler.
    And you can implement some useful controls for tasks you watch via
    cgroup's control interface.

Thanks,
-Kame


> -Leo.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

