Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbYBDUkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbYBDUkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 15:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbYBDUkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 15:40:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54903 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbYBDUkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 15:40:04 -0500
Message-ID: <47A777FD.7080208@zytor.com>
Date: Mon, 04 Feb 2008 12:39:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sam Ravnborg <sam@ravnborg.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: vmlinux_64.lds.S - use THREAD_SIZE instead of	numeric
 constant
References: <20080204171037.GA6743@cvg> <20080204202241.GA16919@uranus.ravnborg.org> <20080204203315.GA31341@elte.hu>
In-Reply-To: <20080204203315.GA31341@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
>> Hi Cyrill.
>> On Mon, Feb 04, 2008 at 08:10:37PM +0300, Cyrill Gorcunov wrote:
>>> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>> The patch looks simple but please explain why you do what you do. It 
>> took me some digging before I could convince mysleft this was indeed a 
>> correct change. And I am pretty sure you did the same investigation 
>> yourself.
>>
>> A comment like:
>>
>> arch/x866/kernel/inittask.c require all variables allocated in
>> the section .data.init_task to be aligned with THREAD_SIZE.
>>
>> would have made me happy.
> 
> Btw., given that on x86 we've moved away from the %esp based task stack 
> trick and use an %fs based Percpu-Data-Area (PDA) to access the current 
> task pointer, this alignment might not be necessary anymore. It's a 
> historic relic of the mask-%esp trick.
> 

Was that *ever* used on x86-64?  I thought x86-64 always used %gs for this.

	-hpa
