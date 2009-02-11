Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbZBKUAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbZBKUAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 15:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbZBKUA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 15:00:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49888 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296AbZBKUAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 15:00:25 -0500
Message-ID: <49932E51.8040009@zytor.com>
Date: Wed, 11 Feb 2009 12:00:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: "H. Peter Anvin" <hpa@kernel.org>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Pass in pt_regs pointer for syscalls that need
 	it
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com>	 <1234277507-4987-3-git-send-email-brgerst@gmail.com>	 <49931067.4090802@kernel.org>	 <73c1f2160902111027s2509f31fq732907bde8db775e@mail.gmail.com>	 <49932BF4.2040008@zytor.com> <73c1f2160902111157g202dbdd2h1bc75b0a8cb242b3@mail.gmail.com>
In-Reply-To: <73c1f2160902111157g202dbdd2h1bc75b0a8cb242b3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> 
> IMHO, copying the 4th-6th args to a new stack frame is the only way to
> guarantee that gcc won't trash any part of pt_regs.  The question is
> whether to do it unconditionally, or try to be clever and only copy
> them for the syscalls that actually need them.
> 

My guess is that the conditionalization would actually cost more than 
doing it unconditionally.  We're talking a small fraction of a cache 
line, and a set of stores to RAM, which can be buffered.

It's in many ways easier than reorganizing the struct pt_regs.  I'm just 
hypersensitive to adding system call overhead in any way.

	-hpa

