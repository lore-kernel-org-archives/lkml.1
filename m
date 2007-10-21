Return-Path: <linux-kernel-owner+w=401wt.eu-S1752383AbXJUMHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbXJUMHw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 08:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbXJUMHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 08:07:45 -0400
Received: from il.qumranet.com ([82.166.9.18]:34337 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbXJUMHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 08:07:45 -0400
Message-ID: <471B40E4.4060204@qumranet.com>
Date: Sun, 21 Oct 2007 14:07:00 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] KVM updates for Linux 2.6.24-rc review
References: <1192964892617-git-send-email-avi@qumranet.com> <471B340C.5010800@qumranet.com> <471B3DD3.3080107@bull.net>
In-Reply-To: <471B3DD3.3080107@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
> Avi Kivity a écrit :
>> Avi Kivity wrote:
>>> The following patches fix fallout from the main 2.6.24 KVM merge.  An
>>> exception is the movnti emulation patch, which adds support for Linux
>>> 2.6.16 guests.
>>>
>>> The patches can be found in kvm.git in the branch kvm-updates-2.6.24.
>>> There is also a branch kvm-updates-2.6.25 which will form the basis of
>>> the next merge window submission.
>>>
>>> Please review the patches and let me know if something is wrong or if
>>> a patch is missing.
>>>
>>>   
>>
>>
>> Laurent, I believe the following patch (in kvm-updates-2.6.25) needs 
>> to go into 2.6.24 as well.  Can you comment on this?
>
> What kind of comment do you want ?

Well, whether it needs to go into .24.

> What are the requirements to go in 2.6.24 instead of 2.6.25 ?
>
> Is a bug correction enough ? :-P
>

It has to fix something real-life, in a real guest.

> This patch correct a bad behavior of x86_emulate_insn() in case of 
> error with a REP prefix.
>
> This patch is needed because, without it, when REP prefix is used with 
> an instruction failing for some reasons (like IO or page fault) we 
> don't restore all modified registers (like RSI and RDI), but only ECX 
> and EIP, so when we re-enter in x86_emulate_insn() we modify again an 
> already modified value. Moreover, this patch manages correctly the 
> case where the instruction fails in writeback().
>

Okay, I guess it is needed.  Can you backport it to the branch?  It's 
very different from kvm-updates-2.6.24...

-- 
error compiling committee.c: too many arguments to function

