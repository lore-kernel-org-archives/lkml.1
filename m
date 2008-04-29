Return-Path: <linux-kernel-owner+w=401wt.eu-S1761602AbYD2Rp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602AbYD2Rp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757359AbYD2RpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:45:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:26668 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbYD2RpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:45:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=P0Wq8zH7MAxoPSglxX3nsWdfO29x2HIL0LCRQFlpdlC4saU61rardfSW9H4DC4TBj6DcaDcgBsTc9Po9SHGJgVP90vU16oANTsSTW+/dHhsis0kpVNymKS7vB70wOrk5YTzNMrILE/rhm2GfOFFR7c6I5EJve6nRHW06qAJddB8=
Date: Tue, 29 Apr 2008 21:44:12 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: vm86 - hide X86_VM_MASK from userland programs v2
Message-ID: <20080429174412.GF6837@cvg>
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

Thanks Ingo for report - all just became clear - I've tried to define
tese flags *after* ptrace.h inclusion - will fix ASAP.

		- Cyrill -
