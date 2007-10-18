Return-Path: <linux-kernel-owner+w=401wt.eu-S932887AbXJRUCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887AbXJRUCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbXJRUC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:02:28 -0400
Received: from il.qumranet.com ([82.166.9.18]:47302 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757484AbXJRUC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:02:27 -0400
Message-ID: <4717BBD0.7070504@qumranet.com>
Date: Thu, 18 Oct 2007 22:02:24 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: latest checkpatch
References: <20071015182118.GA4459@shadowen.org> <200710161759.l9GHxnkK012590@agora.fsl.cs.sunysb.edu> <20071017163916.GO21136@shadowen.org> <20071018111352.GA17039@elte.hu> <20071018192521.GC21136@shadowen.org> <20071018193929.GA22031@elte.hu>
In-Reply-To: <20071018193929.GA22031@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Thu, 18 Oct 2007 22:02:24 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andy Whitcroft <apw@shadowen.org> wrote:
>
>   
>>> it's perfectly legitimate, in fact more robust. So if checkpatch.pl 
>>> wants to make any noise about such constructs it should warn about 
>>> the _lack_ of curly braces in every multi-line condition block 
>>> _except_ the only safe single-line statement:
>>>
>>> 	if (x)
>>> 		y();
>>>       
>> Indeed.  We should probabally do more on the indentation checks in
>> general.  The current direct check for:
>>
>> 	if (foo);
>> 		bar();
>>
>> Could probabally be generalised to look for this kind of error:
>>
>> 	if (foo)
>> 		bar();
>> 		baz();
>> 	one();
>>     
>
> detecting that would be awesome - it's often the sign of a real bug 
> because the intent is often to have bar() and baz() in the conditional 
> block.
>
>   

This is more useful operating on an entire file, so the script can see
all the context.

A 'gcc -Windentation-contradicts-codeflow -Werror' would be nice.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

