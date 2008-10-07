Return-Path: <linux-kernel-owner+w=401wt.eu-S1756957AbYJGVci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbYJGVci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbYJGVcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:32:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44532 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578AbYJGVcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:32:16 -0400
Message-ID: <48EBD555.9060104@kernel.org>
Date: Tue, 07 Oct 2008 14:32:05 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/3] Provide rdtscll() asm/msr.h for user space
References: <20081007143.793379346@firstfloor.org>
In-Reply-To: <20081007143.793379346@firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> For simple user space timing it's very useful to be able to do
> #include <asm/msr.h> instead of having to cut'n'paste the necessarily
> macros into all programs. This used to work with older kernels,
> but broke with the paravirt support (I ended up with a bunch of
> test programs that broke because of that). But it's very useful
> to have rdtscll() available somewhere in user space and asm/msr.h
> is a good place to have them.
> 
> Provide simple rdtsc/rdtscl() macros for user space too in asm/msr.h. 
> Since they are very simple I don't think they are a burden to maintain.
> 
> The diff looks bigger than it is because I moved a code block
> and diff doesn't handle it very well.

I really don't think this belongs in the kernel.  It's not even a case 
of "usable by accident" anymore, and hasn't worked for a while, so it's 
not a matter of legacy, either.

Mixing fundamentally unrelated kernel and userspace variants of the same 
function just makes the aggregation uglier than both.

(Also, most userspace variants I have seen have what the kernel calls 
"rdtscll" and calls it "rdtsc".)

I would suggest writing a <sys/tsc.h> header file and submitting to the 
glibc people, instead, or perhaps even better, start a libarch/libx86 tree.

	-hpa
