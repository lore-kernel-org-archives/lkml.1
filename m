Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbZJSJPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbZJSJPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 05:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbZJSJPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 05:15:50 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:37433 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbZJSJPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 05:15:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=G9esJmmfzrGz2YNAUH+NkuH+0KNkF5nauJR5hH5eai8BGw1IuBPsVrvFedNN2w2Z7C
         SO669ViBvOQc1ox1y5bL0m86hzcN1n/y8LDpL7SS2PYQFTDLoiCKJmhvsMblj7jagona
         j66D3RLYoimpLGZOtepYqcKO0QQufdPE0WJMA=
MIME-Version: 1.0
In-Reply-To: <1255711285.3008.59.camel@pc1117.cambridge.arm.com>
References: <c4e36d110910150159j6092d0d1lb20434bd9d43d8ce@mail.gmail.com>
	 <4AD6EF65.6080602@cn.fujitsu.com>
	 <1255605778.10164.49.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910160045y52d80450g1d803dd2090a2bd8@mail.gmail.com>
	 <1255690674.3008.24.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910160632y4448475dp1ae66dfc01ff8448@mail.gmail.com>
	 <tnxbpk7a0ok.fsf@pc1117.cambridge.arm.com>
	 <c4e36d110910160728n5ceefaa8u6b9989aec0564628@mail.gmail.com>
	 <c4e36d110910160807i2298dacp7d37289ca3ad25f@mail.gmail.com>
	 <1255711285.3008.59.camel@pc1117.cambridge.arm.com>
Date: Mon, 19 Oct 2009 11:15:54 +0200
Message-ID: <c4e36d110910190215j129e61ey5e20634a4bc19292@mail.gmail.com>
Subject: Re: Leaks in trace reported by kmemleak
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/16 Catalin Marinas <catalin.marinas@arm.com>:
> On Fri, 2009-10-16 at 17:07 +0200, Zdenek Kabelac wrote:
>> So I've tested this modified version and it gives much better result
>> with respect to amount of leaked objects
>
> BTW, I created this tree with kmemleak patches to be pushed upstream:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/kmemleak.git
>
> It would be easier to test.

Yes this branch worked well - and there were no leaks  from i915 or
kvm modules for trace.

What is however interesting is the false positive leak for
dma_debug_init(). Which is sometimes listed and sometimes not - the
memory is allocated just once in the code during boot, so it's strange
that pointers to that area are sometimes out of kmemleak scan.

Zdenek
