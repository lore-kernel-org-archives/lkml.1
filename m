Return-Path: <linux-kernel-owner+w=401wt.eu-S1761996AbXGCVa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761996AbXGCVa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761918AbXGCVam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:30:42 -0400
Received: from terminus.zytor.com ([192.83.249.54]:49133 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759752AbXGCVal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:30:41 -0400
Message-ID: <468ABFEE.3000608@zytor.com>
Date: Tue, 03 Jul 2007 14:30:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 06/10] Immediate Value - i386 Optimization
References: <20070703164046.645090494@polymtl.ca> <20070703164515.071300768@polymtl.ca> <468A9956.9050903@zytor.com> <20070703191605.GB4047@Krystal> <468AAF1F.6010909@zytor.com> <468AB390.7000608@redhat.com>
In-Reply-To: <468AB390.7000608@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> On 07/03/2007 04:18 PM, H. Peter Anvin wrote:
>> One could, though, use an indirect jump to achieve, if not as good, at
>> least most of the effect:
>>
>> 	movl	$<patchable>,<reg>
>> 	jmp	*<reg>
>>
> 
> Yeah, but there's this GCC bug:
> 
> 	http://gcc.gnu.org/bugzilla/show_bug.cgi?id=22448
> 
> You can't even dereference labels in an ASM statement.

I wouldn't to that, though, for the existing compiler.   Instead, I
would do:

	void (*func)(void);	/* or what's appropriate */
	asm(<magic movl> : "=rm" (func));
	func();

	-hpa

