Return-Path: <linux-kernel-owner+w=401wt.eu-S1752485AbZIIBsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbZIIBsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 21:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZIIBsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 21:48:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57037 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbZIIBsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 21:48:38 -0400
Message-ID: <4AA7092C.4070706@cn.fujitsu.com>
Date: Wed, 09 Sep 2009 09:47:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing: Add sysctl to enable/disable tracing on
 oops
References: <4AA70198.9070500@cn.fujitsu.com>	 <1252460079.11070.1.camel@gandalf.stny.rr.com>	 <4AA706BE.1090204@cn.fujitsu.com> <1252460523.11070.3.camel@gandalf.stny.rr.com>
In-Reply-To: <1252460523.11070.3.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2009-09-09 at 09:37 +0800, Li Zefan wrote:
>> Steven Rostedt wrote:
>>> On Wed, 2009-09-09 at 09:15 +0800, Li Zefan wrote:
>>>> Currently we always disable tracing on oops, and this patch
>>>> adds a sysctl so one can choose to enable it.
>>> Hmm, we already have a way to enable it.
>>>
>>> # echo 1 > /debug/tracing/tracing_on
>>>
>> What I want is a way to not disable it when an oops happened. :)
>>
> 
> Ah, I misunderstood. May I ask a silly question?
> 
> Why?
> 

Otherwise we won't get trace output from trae_crash_kexec if
crash_kexec() is not called by panic(). For example:

  oops_begin()
->trace_off()
->panic_on_oops
->kexec_should_crash()
->crash_kexec()
