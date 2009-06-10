Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbZFJBsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbZFJBsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 21:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbZFJBsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 21:48:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62711 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754893AbZFJBsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 21:48:00 -0400
Message-ID: <4A2F1126.5010306@cn.fujitsu.com>
Date: Wed, 10 Jun 2009 09:49:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing/events/ring-buffer: block trace
 points and fix
References: <20090609163657.557589106@goodmis.org> <20090609234655.GA24118@elte.hu> <4A2F0C4A.8020109@cn.fujitsu.com> <alpine.DEB.2.00.0906092131190.30552@gandalf.stny.rr.com> <4A2F0E26.9010203@cn.fujitsu.com> <alpine.DEB.2.00.0906092140350.30552@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0906092140350.30552@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 10 Jun 2009, Li Zefan wrote:
> 
>>>>> In file included from mm/highmem.c:30:
>>>>> include/linux/blktrace_api.h:223: warning: ?struct request? declared inside parameter list
>>>>> include/linux/blktrace_api.h:223: warning: its scope is only this definition or declaration, which is probably not what you want
>>>>> include/linux/blktrace_api.h: In function ?blk_cmd_buf_len?:
>>>>> include/linux/blktrace_api.h:225: error: implicit declaration of function ?blk_pc_request?
>>>>> include/linux/blktrace_api.h:225: error: dereferencing pointer to incomplete type
>>>>> include/linux/blktrace_api.h: At top level:
>>>>> include/linux/blktrace_api.h:228: warning: ?struct request? declared inside parameter list
>>>>> include/linux/blktrace_api.h:230: warning: ?struct request? declared inside parameter list
>>>>> distcc[15629] ERROR: compile mm/highmem.c on a/32 failed
>>>>>
>>>> I've fixed it. I'll post a new version after I've done some
>>>> more building tests.
>>> Ingo,
>>>
>>> Should Li post a delta fix, or should we just rebase?
>>>
>> I thought we should rebase it, since it causes building failure which
>> might hurt bisectability.
> 
> The failure happens when CONFIG_BLOCK is not defined. How many configs 
> really do that?
> 

Ah, I see. I'll post a delta fix.

btw, I found many includes of blktrace_api.h has become unneeded since
blktrace moved to trace points. I'll post another patch to remove those
includes later.

