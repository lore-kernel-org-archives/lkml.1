Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbXIRKou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbXIRKou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 06:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbXIRKop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 06:44:45 -0400
Received: from il.qumranet.com ([82.166.9.18]:57306 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269AbXIRKoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 06:44:44 -0400
Message-ID: <46EFAC0D.9090606@qumranet.com>
Date: Tue, 18 Sep 2007 12:44:29 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Christoph Hellwig <hch@infradead.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Nguyen Anh Quynh <aquynh@gmail.com>
Subject: Re: [PATCH 001/104] KVM: Fix *nopage() in kvm_main.c
References: <11900179463203-git-send-email-avi@qumranet.com> <200709170729.24835.nickpiggin@yahoo.com.au> <46EEC52B.8080101@qumranet.com> <200709180317.07055.nickpiggin@yahoo.com.au>
In-Reply-To: <200709180317.07055.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Tuesday 18 September 2007 04:19, Avi Kivity wrote:
>   
>> Nick Piggin wrote:
>>     
>>>> I should mention that the converting to use ->fault() is a 15-minute
>>>> change; the tricky part is adding backwards compatibility for the
>>>> external module package.
>>>>         
>>> It should be mostly possible to ifdef a nopage() handler, which is
>>> just a wrapper function to translate arguments then call your new
>>> ->fault() handler. With luck, fault would mostly inline into nopage,
>>> and do some constant folding to make it cheaper...
>>>
>>> I'm planning to go through and convert the rest of the in-tree users
>>> at some point soon, so if you do get a chance to convert your
>>> upstream code before I try, it would nice ;)
>>>       
>> In kvm I don't add compatibility #ifdefs to mainline, instead I have an
>> awk script that massages the sources into something that all kernels can
>> grok.
>>     
>
> Sure, but my suggestion is just a way to make it possible without having
> to maintain a lot of duplicated code. The point is simply that we'll be
> getting rid of nopage from mainline sooner or later, and it will probably
> be less painful for your out of tree stuff if you do it rather than me. Maybe.
>
>   

Certainly it's best done by someone familiar with the kvm external 
module hackery.  I'll do it during 2.6.24 if no one beats me to it.

-- 
error compiling committee.c: too many arguments to function

