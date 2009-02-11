Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbZBKT6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbZBKT6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 14:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbZBKT57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 14:57:59 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:58091 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbZBKT56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 14:57:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QxQ55GrwSSEx+NPGBO1cVAMUST4YZecR/zaSQGHgTtKPQltv/sSv2zQSi9zZ0PCUDk
         4y2rIsWfdnlLlSDktsPNBFcCrx8OMggj4RJSqZhzEcEXuYX3A56b5qC4Lqqd1/MksKRs
         EZJt0c2cBxSLgXEVQP+AoSJWfoS2ZhBbLWIfE=
MIME-Version: 1.0
In-Reply-To: <49932BF4.2040008@zytor.com>
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com>
	 <1234277507-4987-3-git-send-email-brgerst@gmail.com>
	 <49931067.4090802@kernel.org>
	 <73c1f2160902111027s2509f31fq732907bde8db775e@mail.gmail.com>
	 <49932BF4.2040008@zytor.com>
Date: Wed, 11 Feb 2009 14:57:57 -0500
Message-ID: <73c1f2160902111157g202dbdd2h1bc75b0a8cb242b3@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86: Pass in pt_regs pointer for syscalls that need 
	it
From: Brian Gerst <brgerst@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 2:50 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Brian Gerst wrote:
>>
>> I guess I could go back to extracting the args from the pt_regs struct
>> given just the pointer.  How do you intend to handle system calls in
>> your changes (normal ones, not needing pt_regs)?
>>
>
> My plan was to by default load up the three first arguments in (%eax, %edx,
> %ecx) followed by the remaining arguments on the stack... I currently have
> it as a reorganized struct pt_regs, but I'm still trying to figure out if it
> would make more sense from a correctness and performance perspective to
> instead have duplicates of these entries.
>
> For the pt_regs-using registers, they would need a tiny trampoline, looking
> like:
>
>        leal 16(%esp),%eax
>        jmp <real function>
>
>        -hpa
>
>

IMHO, copying the 4th-6th args to a new stack frame is the only way to
guarantee that gcc won't trash any part of pt_regs.  The question is
whether to do it unconditionally, or try to be clever and only copy
them for the syscalls that actually need them.

--
Brian Gerst
