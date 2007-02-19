Return-Path: <linux-kernel-owner+w=401wt.eu-S932275AbXBSOLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbXBSOLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:11:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932274AbXBSOLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:11:00 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:34500 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272AbXBSOLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:11:00 -0500
Message-ID: <45D9AFBE.5020107@in.ibm.com>
Date: Mon, 19 Feb 2007 19:40:06 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, svaidy@linux.vnet.ibm.com,
       devel@openvz.org
Subject: Re: [ckrm-tech] [RFC][PATCH][2/4] Add RSS accounting and control
References: <20070219065019.3626.33947.sendpatchset@balbir-laptop> <20070219065034.3626.2658.sendpatchset@balbir-laptop> <20070219005828.3b774d8f.akpm@linux-foundation.org> <45D97DF8.5080000@in.ibm.com> <20070219030141.42c65bc0.akpm@linux-foundation.org> <45D9856D.1070902@in.ibm.com> <20070219032352.2856af36.akpm@linux-foundation.org> <45D9906F.2090605@in.ibm.com> <6599ad830702190409x4f64e56ex4044a12d949e44af@mail.gmail.com>
In-Reply-To: <6599ad830702190409x4f64e56ex4044a12d949e44af@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On 2/19/07, Balbir Singh <balbir@in.ibm.com> wrote:
>>> More worrisome is the potential for use-after-free.  What prevents the
>>> pointer at mm->container from referring to freed memory after we're dropped
>>> the lock?
>>>
>> The container cannot be freed unless all tasks holding references to it are
>> gone,
> 
> ... or have been moved to other containers. If you're not holding
> task->alloc_lock or one of the container mutexes, there's nothing to
> stop the task being moved to another container, and the container
> being deleted.
> 
> If you're in an RCU section then you can guarantee that the container
> (that you originally read from the task) and its subsystems at least
> won't be deleted while you're accessing them, but for accounting like
> this I suspect that's not enough, since you need to be adding to the
> accounting stats on the correct container. I think you'll need to hold
> mm->container_lock for the duration of memctl_update_rss()
> 
> Paul
> 

Yes, that sounds like the correct thing to do.

-- 
	Warm Regards,
	Balbir Singh
