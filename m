Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbXJULNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbXJULNL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbXJULM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:12:58 -0400
Received: from il.qumranet.com ([82.166.9.18]:37630 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbXJULM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:12:57 -0400
Message-ID: <471B340C.5010800@qumranet.com>
Date: Sun, 21 Oct 2007 13:12:12 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] KVM updates for Linux 2.6.24-rc review
References: <1192964892617-git-send-email-avi@qumranet.com>
In-Reply-To: <1192964892617-git-send-email-avi@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> The following patches fix fallout from the main 2.6.24 KVM merge.  An
> exception is the movnti emulation patch, which adds support for Linux
> 2.6.16 guests.
>
> The patches can be found in kvm.git in the branch kvm-updates-2.6.24.
> There is also a branch kvm-updates-2.6.25 which will form the basis of
> the next merge window submission.
>
> Please review the patches and let me know if something is wrong or if
> a patch is missing.
>
>   


Laurent, I believe the following patch (in kvm-updates-2.6.25) needs to 
go into 2.6.24 as well.  Can you comment on this?

> commit 6de232e39be372f85bea96eb741962acc7fcb1f7
> Author: Laurent Vivier <Laurent.Vivier@bull.net>
> Date:   Mon Oct 1 11:01:06 2007 +0200
>
>     KVM: x86 emulator: Correct management of REP prefix
>
>     This patch corrects some errors appearing when we have an 
> emulation failure
>     on an operation using REP prefix.
>
>     When x86_emulate_insn() fails, saving EIP and ECX is not enough as 
> emulation
>     should have modified other registers like RSI or RDI. Moreover, 
> the emulation
>     can fail on the writeback, and in this case we are not able to restore
>     registers.
>
>     At beginning of x86_emulate_insn(), we restore registers from vcpu 
> as they were
>     not modified by x86d_decode_insn() and we save EIP to be able to 
> restore it
>     in case of failure.
>

-- 
error compiling committee.c: too many arguments to function

