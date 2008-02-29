Return-Path: <linux-kernel-owner+w=401wt.eu-S933841AbYB2VAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841AbYB2VAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933143AbYB2VAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:00:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53995 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933064AbYB2VAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:00:11 -0500
Message-ID: <47C8717F.3030009@zytor.com>
Date: Fri, 29 Feb 2008 12:56:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Zachary Amsden <zach@vmware.com>
Subject: Re: bad paravirt/Xen interaction in "x86 - Enhance DEBUG_RODATA support
 - alternatives"
References: <47C86D7A.5030608@goop.org>
In-Reply-To: <47C86D7A.5030608@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> The patch "x86 - Enhance DEBUG_RODATA support - alternatives" enables 
> the kernel for writing by clearing X86_CR0_WP allow privileged writes.  
> This won't work in a paravirt environment for two reasons:
> 
>   1. the kernel may not be running in ring 0, so writes will still be
>      prevented
>   2. the hypervisor prevents X86_CR0_WP from being cleared anyway (it
>      GPFs the cr0 update)
> 
> This crashes on Xen, and it would probably break VMI too.
> 
> The only safe way to allow writes is to change the page permissions 
> (either on the page itself, or create a temporary writable alias for 
> that page).  Perhaps something you could do it with kmap_atomic.
> 

A properly implemented hypervisor should arguably emulate this.

Doesn't really mean the patch is worth the pain.

	-hpa
