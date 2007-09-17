Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbXIQSTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbXIQSTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbXIQSTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:19:41 -0400
Received: from il.qumranet.com ([82.166.9.18]:39003 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbXIQSTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:19:40 -0400
Message-ID: <46EEC52B.8080101@qumranet.com>
Date: Mon, 17 Sep 2007 20:19:23 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Christoph Hellwig <hch@infradead.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Nguyen Anh Quynh <aquynh@gmail.com>
Subject: Re: [PATCH 001/104] KVM: Fix *nopage() in kvm_main.c
References: <11900179463203-git-send-email-avi@qumranet.com> <46EE45C3.8040302@qumranet.com> <46EE4683.7070205@qumranet.com> <200709170729.24835.nickpiggin@yahoo.com.au>
In-Reply-To: <200709170729.24835.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Mon, 17 Sep 2007 20:19:24 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
>>
>> I should mention that the converting to use ->fault() is a 15-minute
>> change; the tricky part is adding backwards compatibility for the
>> external module package.
>>     
>
> It should be mostly possible to ifdef a nopage() handler, which is
> just a wrapper function to translate arguments then call your new
> ->fault() handler. With luck, fault would mostly inline into nopage,
> and do some constant folding to make it cheaper...
>
> I'm planning to go through and convert the rest of the in-tree users
> at some point soon, so if you do get a chance to convert your
> upstream code before I try, it would nice ;)
>
>   

In kvm I don't add compatibility #ifdefs to mainline, instead I have an
awk script that massages the sources into something that all kernels can
grok.

It isn't pretty but it works.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

