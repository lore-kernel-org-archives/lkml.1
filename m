Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab0CCRzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:55:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45657
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755406Ab0CCRzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:55:35 -0500
Date: Wed, 03 Mar 2010 09:55:53 -0800 (PST)
Message-Id: <20100303.095553.105186917.davem@davemloft.net>
To: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       paulus@samba.org, robert.richter@amd.com, fweisbec@gmail.com
Subject: Re: [RFC][PATCH 07/11] perf: Provide PERF_SAMPLE_REGS
From: David Miller <davem@davemloft.net>
In-Reply-To: <bd4cb8901003030949v3db2db41o9cc1a65d53c370@mail.gmail.com>
References: <bd4cb8901003030930q4050d074k11a45c3583b96502@mail.gmail.com>
	<1267637995.25158.96.camel@laptop>
	<bd4cb8901003030949v3db2db41o9cc1a65d53c370@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>
Date: Wed, 3 Mar 2010 09:49:33 -0800

> On Wed, Mar 3, 2010 at 9:39 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Wed, 2010-03-03 at 09:30 -0800, Stephane Eranian wrote:
>>> This assumes struct pt_regs is somehow exported to userland.
>>> Is that the case?
>>
>> I seems to have understood they were, and asm/ptrace.h seems to agree
>> with that, it has !__KERNEL__ definitions for struct pt_regs.
>>
> Seems to be the case, indeed.

BTW, how are you going to cope with compat systems?

If I build 'perf' on a sparc64 kernel build, it's going to get the
64-bit pt_regs.  So I can't then use that binary on a sparc box
running a 32-bit kernel.

And vice versa.

And more generally aren't we supposed to be able to eventually analyze
perf dumps on any platform not just the one 'perf' was built under?

We'll need to do something about the encoding of pt_regs, therefore.
