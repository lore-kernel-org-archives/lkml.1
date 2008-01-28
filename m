Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbYA1Pjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbYA1Pjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYA1PjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:39:05 -0500
Received: from gw.goop.org ([64.81.55.164]:56760 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbYA1PjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:39:04 -0500
Message-ID: <479DF715.5080309@goop.org>
Date: Mon, 28 Jan 2008 07:39:01 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 00 of 11] x86: separate pmd lifetime from pgd
References: <patchbomb.1201296189@localhost> <20080128151753.GA14451@elte.hu>
In-Reply-To: <20080128151753.GA14451@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> This series addresses various cleanups in pagetable allocation in the 
>> direction of unifying 32/64 bits (that's still a while off yet).
>>     
>
> hm, i tried this, and got an early crash:
>
> [   29.389844] VFS: Mounted root (ext3 filesystem) readonly.
> [   29.389872] debug: unmapping init memory c0b03000..c0b6f000
> [   29.440139] PM: Adding info for No Bus:vcs1
> [   29.463676] khelper used greatest stack depth: 2404 bytes left
> [   29.467238] PM: Adding info for No Bus:vcsa1
> [   29.541785] PANIC: double fault, gdt at c1d16000 [255 bytes]
> [   29.541785] double fault, tss at c1d19100
> [   29.541785] eip = c011fa95, esp = c3bf6000
> [   29.541785] eax = c3bf6010, ebx = c0b6fc08, ecx = 0000007b, edx = 00000000
> [   29.541785] esi = f76a7df4, edi = c011fa90
>
> i think it's one of your patches :) Bisecting it down to the right one 
> now.

Wouldn't surprise me.  Given that its a non-PAE config, most of the 
patches won't be in play, but perhaps I screwed up coping the kernel 
pagetable entries into the pgd somehow.

    J
