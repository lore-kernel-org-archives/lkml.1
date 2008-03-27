Return-Path: <linux-kernel-owner+w=401wt.eu-S1760761AbYC0T4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761AbYC0T4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 15:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757720AbYC0T4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 15:56:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41938 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758175AbYC0T4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 15:56:07 -0400
Message-ID: <47EBFBBE.4060404@zytor.com>
Date: Thu, 27 Mar 2008 12:55:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: processor flags
References: <20080327194749.GA7633@cvg>
In-Reply-To: <20080327194749.GA7633@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> 
> And now I'm in confusion - the way of changing this code I see is the
> following:
> 
> - or use additional #ifdef CONFIG_VM86 in code where VM_MASK is used
>   (that would be ugly IMHO)
> - rename VM_MASK to say X86_EFLAGS_VM86 with that #ifdef remained
> - rest VM_MASK as it is
> 
> How do you think?
> 

I think what we should do is:

- Rename VM_MASK to X86_VM_MASK (it's x86-specific after all)
- Have:

#if CONFIG_VM86
# define X86_VM_MASK X86_EFLAGS_VM
#else
# define X86_VM_MASK 0		/* No V86 support */
#endif

	-hpa
