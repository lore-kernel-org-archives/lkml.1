Return-Path: <linux-kernel-owner+w=401wt.eu-S1761975AbYJJQNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761975AbYJJQNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758844AbYJJQNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:13:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37751 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbYJJQNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:13:08 -0400
Message-ID: <48EF7EE7.6040409@zytor.com>
Date: Fri, 10 Oct 2008 09:12:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Anders Kaseorg <andersk@MIT.EDU>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: Make ftrace_test_p6nop disassembler-friendly
References: <alpine.DEB.2.00.0810092209460.21569@vinegar-pot.mit.edu> <20081010085429.GB319@elte.hu> <alpine.DEB.1.10.0810100927110.26408@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0810100927110.26408@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Fri, 10 Oct 2008, Ingo Molnar wrote:
> 
>> * Anders Kaseorg <andersk@MIT.EDU> wrote:
>>
>>> Commit 4c3dc21b136f8cb4b72afee16c3ba7e961656c0b in tip introduced the
>>> 5-byte NOP ftrace_test_p6nop:
>>>   jmp . + 5
>>>   .byte 0x00, 0x00, 0x00
>>> This is not friendly to disassemblers because an odd number of 0x00s
>>> ends in the middle of an instruction boundary.  This changes the 0x00s
>>> to 1-byte NOPs (0x90).
>>>
>>> Signed-off-by: Anders Kaseorg <andersk@mit.edu>
>> applied to tip/tracing/ftrace, good spotting Anders!
>>
>> Steve, any objections?
> 
> Nope, it's fine with me.
> 
> Acked-by: Steven Rostedt <srostedt@redhat.com>
> 

The (semi-)amusing thing is that it should never, ever, get there.
66 66 66 66 90 is used over this, which should always work.

	-hpa
