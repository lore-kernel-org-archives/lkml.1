Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbYLSWQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbYLSWQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbYLSWQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:16:04 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:45286 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbYLSWQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:16:03 -0500
Message-ID: <494C1D20.9000008@ct.jp.nec.com>
Date: Fri, 19 Dec 2008 14:16:00 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Toshikazu Nakayama <nakayama.ts@ncos.nec.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: fix discarding message when recursion_bug
References: <494BE687.2040700@ct.jp.nec.com> <20081219215347.GG2351@elte.hu>
In-Reply-To: <20081219215347.GG2351@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> 
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> Impact: fix
>>
>> When recursion_bug is true, kernel discards original message because printk_buf
>> contains recursion_bug_msg with NULL terminator. The sizeof(recursion_bug_msg)
>> makes this, use strlen() to get correct length without NULL terminator.
>>
>> Reported-by: Toshikazu Nakayama <nakayama.ts@ncos.nec.co.jp>
>> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>> ---
>>  kernel/printk.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Good one - applied to tip/core/printk, thanks!
> 
> Btw., i'm curious: in what situation was such recursion observed, and how 
> did the kernel behave? You saw a truncated recursion message in dmesg - or 
> was it worse?

I'm not sure about the real situation. I've heard this issue was found in
printing messages in NMI handler, maybe with artificial kernel stuck.

Thanks,
Hiroshi
