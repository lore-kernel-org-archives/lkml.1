Return-Path: <linux-kernel-owner+w=401wt.eu-S1759637AbYACDWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637AbYACDWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 22:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbYACDV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 22:21:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbYACDV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 22:21:57 -0500
Message-ID: <477C5474.3040302@redhat.com>
Date: Wed, 02 Jan 2008 22:20:20 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, qbarnes <qbarnes@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, davem@davemloft.net,
       Keshavamurthy Anil S <anil.s.keshavamurthy@intel.com>
Subject: Re: [PATCH] x86: Use is_kprobe_fault to better match usage
References: <1199322323.6323.76.camel@brick>  <477C4A42.1010701@redhat.com> <1199329200.6323.97.camel@brick>
In-Reply-To: <1199329200.6323.97.camel@brick>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> On Wed, 2008-01-02 at 21:36 -0500, Masami Hiramatsu wrote:
>> Hi Harvey,
>>
>> Harvey Harrison wrote:
>>> Currently the notify_page_fault helper is used to test it the page
>>> fault was caused by a kprobe causing an early return from do_page_fault.
>>>
>>> Change the name of the helper to is_kprobe_fault to match the usage and
>>> remove the preempt_disable/enable pair around kprobe_running() with an
>>> explicit test for preemption.  The idea for this comes from a patch
>>> by Quentin Barnes to kprobes.c
>> Sure, that's right.
>> However, since other architectures also have notify_page_fault(),
>> I think all of those code might better be changed same time for
>> maintainability.
>>
> 
> How about a static inline in linux/kprobes.h with a big comment above
> about when/why the !preemptible() check is sufficient?

Hmm, fault handling depends on the architecture. But current
notify_page_fault()s are very similar. I think unifying it is good idea.
We will be happy to review that if you send it.

Many thanks!

> 
> Harvey
> 
> 
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

