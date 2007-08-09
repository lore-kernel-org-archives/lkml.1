Return-Path: <linux-kernel-owner+w=401wt.eu-S938992AbXHIGNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938992AbXHIGNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 02:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933888AbXHIGNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 02:13:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41017 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbXHIGNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 02:13:15 -0400
Message-ID: <46BAB078.4020307@zytor.com>
Date: Wed, 08 Aug 2007 23:13:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: jidong xiao <jidong.xiao@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Question on IS_ERR
References: <4104961b0708082236if0c1199l2bbc468e9d582a08@mail.gmail.com>
In-Reply-To: <4104961b0708082236if0c1199l2bbc468e9d582a08@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jidong xiao wrote:
> I saw we call IS_ERR(ptr) after executing kthread_run() each time.
> But we don't need to call IS_ERR(ptr) after kmalloc().
> 
> My understanding is,
> the kernel pointer ptr for IS_ERR to check should be page aligned, so
> its kernel address should be less than 0xfffff000(or 0xffff ffff ffff
> f000, 64bits),
> 
> kthread_run returns a struct task_struct pointer,which is always page aligned,
> however the pointer returned by kmalloc() might not be page aligned,
> so we cannot use IS_ERR to check.
> 
> Is my understanding correct?
> 

No.  There is no requirement that the pointer is page-aligned.  The last
page of the address space is (in the Linux kernel) invalid by
definition, so there are in effect three kinds of pointers in the Linux
kernel: valid pointers, NULL, and ERR_PTR()s.

	-hpa
