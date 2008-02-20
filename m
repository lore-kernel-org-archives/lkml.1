Return-Path: <linux-kernel-owner+w=401wt.eu-S1764419AbYBTDBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764419AbYBTDBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 22:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbYBTDBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 22:01:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53373 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbYBTDBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 22:01:05 -0500
Message-ID: <47BB977D.5090406@cn.fujitsu.com>
Date: Wed, 20 Feb 2008 10:59:09 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/5] signal(x86_32): Improve the signal stack overflow
 check
References: <47B95C4D.6080000@cn.fujitsu.com>	<20080218134720.GA28851@elte.hu>	<47BA299A.3040207@cn.fujitsu.com>	<20080219185009.122ED2701BA@magilla.localdomain>	<47BB7922.1010400@cn.fujitsu.com>	<20080220011822.C510B2701BA@magilla.localdomain>	<47BB83E2.1030504@cn.fujitsu.com>	<20080220014419.B85D02701BA@magilla.localdomain>	<47BB8F05.3050001@cn.fujitsu.com> <20080220024928.0EE172701BA@magilla.localdomain>
In-Reply-To: <20080220024928.0EE172701BA@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote::
>> I spent some time read you mail carefully and dig into the code again.
>>
>> And yes, you are right. It's possible that SA_ONSTACK has been cleared
>> before the second signal on the same stack comes.
> 
> It's not necessary for SA_ONSTACK to have "been cleared", by which I assume
> you mean a sigaction call with SA_ONSTACK not set in sa_flags.  That is
> indeed possible, but it's not the only case your patch broke.  It can just
> be a different signal whose sigaction never had SA_ONSTACK, when you are
> still on the signal stack from an earlier signal that did have SA_ONSTACK.

Thanks for your explanation.

> 
>> So this patch is wrong  :( . I will revise the other 4 patches.
> 
> For 2 and 3, I would rather just wait until we unify signal.c anyway.

Ok. I see.

