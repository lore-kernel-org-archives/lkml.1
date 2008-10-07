Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbYJGXZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbYJGXZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYJGXZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:25:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46227 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbYJGXZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:25:09 -0400
Message-ID: <48EBEFCC.4090302@kernel.org>
Date: Tue, 07 Oct 2008 16:25:00 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/3] Provide rdtscll() asm/msr.h for user space
References: <20081007143.793379346@firstfloor.org> <48EBD555.9060104@kernel.org> <20081007231149.GT20740@one.firstfloor.org>
In-Reply-To: <20081007231149.GT20740@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
>> I would suggest writing a <sys/tsc.h> header file and submitting to the 
>> glibc people, instead, or perhaps even better, start a libarch/libx86 tree.
> 
> That wouldn't work on old kernels. asm/msr.h has been the traditional 
> interface for this and rdtsc has worked forever (at least dating back to 2.0)
> rdtscll is a bit newer, but still in Linux terms ancient (2.4)
> 

It would definitely work on older kernels.  Just don't stomp on the 
kernel's namespace and you can do whatever you want.

> Also in my experience distributions are extremly slow at keeping up
> with glibc, so even if this was added to glibc it would be probably
> years before it would be actually usable :/ And I see about zero
> point in changing a perfectly fine include name breaking everything old.

So ship the include file with your utility.  Hardly a big deal.  But 
yes, that's part of why I'm mentioning the idea of putting it in a 
separate library, which can also house other low-level constructs.

> Anyways if you insist I can probably deal without
> but I (and likely others) would think something nasty about you every time 
> I have to cut'n'paste that code again. Do you really want to risk that? @)

If you're really incapable of maintaining a single user-mode header file 
with a handful of one-liners in a sane way, then definitely.

	-hpa
