Return-Path: <linux-kernel-owner+w=401wt.eu-S1764608AbYD2QCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764608AbYD2QCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756736AbYD2QCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:02:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:8216 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbYD2QB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:01:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=WvCBwJBBmutVwflzwwTQcikXcjZ0c9Ak4ER9fQ2rcwSOYqzPe5J/2ALY8uvQfDW5AKLXq9h650V1+/V6Yimk1nllem/MR6q249CFeApF/vjby/PCQoDV2rV2+0bL5gGoJWY4T8tuIvBKG2mYMlWE8kw0UBRIShL2kFC1RJsT2B4=
Date: Tue, 29 Apr 2008 20:01:05 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: vm86 - hide X86_VM_MASK from userland programs v2
Message-ID: <20080429160105.GD6837@cvg>
References: <20080424144120.GA7717@cvg> <4810CC2F.3010600@zytor.com> <20080428182323.GD1685@elte.hu> <20080428192039.GA10267@elte.hu> <20080429152947.GB6837@cvg> <20080429154330.GC6837@cvg> <481742C1.5040709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481742C1.5040709@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Tue, Apr 29, 2008 at 08:46:09AM -0700]
> Cyrill Gorcunov wrote:
>> | | with this patch we have <asm/vm86.h> included only
>> | if __i386__ defined *BUT* X86_VM_MASK is tried to be
>> | used *without* __386__ being checked (as example - 
>> ptrace.h:user_mode_vm).
>> | I'm not sure how to properly hanle this situation. But will take a look.
>> | | So I suggest you drop my last patch (which moves X86_VM_MASK
>> | into __KERNEL__ section) for a while. I'll recheck all
>> | this stuff later (too busy now).
>> | | 		- Cyrill -
>> Thomas, could you take a look please - is my suspicious wrong?
>> 		- Cyrill -
>
> X86_VM_MASK should be defined to zero on x86-64.  Part of the reason for 
> this symbol is so we don't have to put #ifdef around its uses.
>
> 	-hpa
>

Hi Peter,

yes, we already have X86_VM_MASK defined to 0 in vm86.h on 64bits
cpu - the only question - why this file was not included in ptrace.h
even the machine was 32bit cpu configured (according to Ingo's config).
I've been suspecting that it's __i386__ who is responsible for that but
I was wrong - it's just alias for CONFIG_X86_32. Interesting... ;)
Need time to investigate. /And sorry Thomas, I was wrong about your
commit/

		- Cyrill -
