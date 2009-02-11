Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbZBKTuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbZBKTuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 14:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbZBKTul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 14:50:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35507 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbZBKTul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 14:50:41 -0500
Message-ID: <49932BF4.2040008@zytor.com>
Date: Wed, 11 Feb 2009 11:50:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: "H. Peter Anvin" <hpa@kernel.org>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Pass in pt_regs pointer for syscalls that need
 	it
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com>	 <1234277507-4987-3-git-send-email-brgerst@gmail.com>	 <49931067.4090802@kernel.org> <73c1f2160902111027s2509f31fq732907bde8db775e@mail.gmail.com>
In-Reply-To: <73c1f2160902111027s2509f31fq732907bde8db775e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> 
> I guess I could go back to extracting the args from the pt_regs struct
> given just the pointer.  How do you intend to handle system calls in
> your changes (normal ones, not needing pt_regs)?
> 

My plan was to by default load up the three first arguments in (%eax, 
%edx, %ecx) followed by the remaining arguments on the stack... I 
currently have it as a reorganized struct pt_regs, but I'm still trying 
to figure out if it would make more sense from a correctness and 
performance perspective to instead have duplicates of these entries.

For the pt_regs-using registers, they would need a tiny trampoline, 
looking like:

	leal 16(%esp),%eax
	jmp <real function>

	-hpa

