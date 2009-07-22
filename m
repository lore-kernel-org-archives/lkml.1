Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbZGVJ5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbZGVJ5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 05:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZGVJ5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 05:57:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64739 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbZGVJ47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 05:56:59 -0400
Message-ID: <4A66E261.2090105@cn.fujitsu.com>
Date: Wed, 22 Jul 2009 17:56:49 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: prasad@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/ksym_tracer: support quick clear for	ksym_trace_filter
References: <4A6685BB.2090809@cn.fujitsu.com> <4A66869A.9000106@cn.fujitsu.com> <20090722050636.GA9039@in.ibm.com>
In-Reply-To: <20090722050636.GA9039@in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



K.Prasad wrote:
> On Wed, Jul 22, 2009 at 11:25:14AM +0800, Xiao Guangrong wrote:
>> It's rather bored to clear symbol one by one in ksym_trace_filter
>> file, so, this patch can let ksym_trace_filter file support quick
>> clear, we can write "0" to this file, it can clear all symbols
>>
>> for example:
>>  # cat ksym_trace_filter
>>  ksym_filter_head:rw-
>>  global_trace:rw-
>>  # echo 0 > ksym_trace_filter
>>  # cat ksym_trace_filter
>>  #
>>
> 
> It's nice to have this feature added and the other patches fix issues in
> ksym tracer. Can you have this patch add the capability to clear all
> breakpoints in one-shot through wild-cards?
> 

It already can clear all breakpoints in one-shot by write "0" to
ksym_trace_filter file, do you means that we need to support other
way for it? like:

echo > ksym_trace_filter
echo "*:---" > ksym_trace_filter

IMHO, one way to clear all breakpoints is enough, no need to add
more code for the same function, for example, in trace events filter,
only echo 0 > filter can properly clear all filters.

Are you sure other way is necessary? 

Thanks,
Xiao

> Ingo wanted something like "echo "*:---" > ksym_trace_filter". The patch
> I sent here: http://lkml.org/lkml/2009/6/20/73 implements the same. You
> may want to implement something on those lines.
> 
> Thanks,
> K.Prasad
> 
> 
> 
