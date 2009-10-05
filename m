Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbZJERVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbZJERVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 13:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbZJERVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 13:21:39 -0400
Received: from claw.goop.org ([74.207.240.146]:47381 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbZJERVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 13:21:39 -0400
Message-ID: <4ACA2AFD.4080305@goop.org>
Date: Mon, 05 Oct 2009 10:21:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Bastian Blank <bastian@waldi.eu.org>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: Disable stack protector for irq helper
References: <20091004183013.GA26101@wavehammer.waldi.eu.org> <4AC92A65.40806@goop.org> <20091005013517.GA6081@wavehammer.waldi.eu.org>
In-Reply-To: <20091005013517.GA6081@wavehammer.waldi.eu.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/09 18:35, Bastian Blank wrote:
> On Sun, Oct 04, 2009 at 04:06:13PM -0700, Jeremy Fitzhardinge wrote:
>   
>> On 10/04/09 11:30, Bastian Blank wrote:
>>     
>>> The stack protector needs additional registers on x86_32, which are not
>>> saved in calls to the small paravirt interrupt handlers. This leads to
>>> early crashes as registers are overwritten and not saved by the caller
>>> as instructed.
>>>       
>> Thanks for the patch, but I don't think its quite right.  
>> PV_CALLEE_SAVE_REGS_THUNK() is responsible for generating a wrapper for
>> the functions to save/restore all the appropriate registers.  If it is
>> failing to do so, then the correct fix is to update
>> PV_SAVE/RESTORE_ALL_CALLER_REGS.
>>     
> Well, I did not understand this part of the code, but you seem right. So
> lets try the following. I have not yet run tested it.
>
> Save all caller-saved registers on x86_32 for the paravirt callee saved
> registers.
>   

That looks better, but it is still overkill.  We only need to save the
set of registers the ABI requires the callee to preserve.  What
additional register(s) gets clobbered by stack-protector that need to be
saved?

    J
