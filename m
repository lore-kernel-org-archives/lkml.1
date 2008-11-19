Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbYKSVGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbYKSVGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 16:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYKSVGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 16:06:16 -0500
Received: from gw.goop.org ([64.81.55.164]:47699 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbYKSVGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 16:06:16 -0500
Message-ID: <49247FC6.8080201@goop.org>
Date: Wed, 19 Nov 2008 13:06:14 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Eric Lacombe <goretux@gmail.com>
CC: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [x86] do_arch_prctl - bug?
References: <200811181835.07360.goretux@gmail.com> <200811190044.11566.goretux@gmail.com> <492366CB.8020905@goop.org> <200811191023.16358.goretux@gmail.com>
In-Reply-To: <200811191023.16358.goretux@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Lacombe wrote:
> Ok, thanks, so I suppose now that only doing :
> asm volatile("movl %0,%%gs" :: "r" (0));
> could corrupt the address of the PDA that resides actually in the MSR_GS_BASE. 
> And that's why load_gs_index is used as it contains "swapgs" before and after 
> the "mov to gs".
>
> Is that correct?
>   

Yes, loading a selector into a segment register will load the lower 32 
bits of the base from the ldt/gdt into the msr and zero the rest.

    J
