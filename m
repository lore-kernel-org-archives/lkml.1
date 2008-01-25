Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbYAYPvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbYAYPvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 10:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757733AbYAYPv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 10:51:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35015 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbYAYPv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 10:51:26 -0500
Message-ID: <479A04AA.9040202@zytor.com>
Date: Fri, 25 Jan 2008 07:47:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: trim ram need to check if mtrr is there v2
References: <47993F1A.5070408@goop.org> <4799400C.1060102@zytor.com> <200801241947.55223.yinghai.lu@sun.com> <4799930B.40006@goop.org> <86802c440801250013p1a35b126l30fb7479b110e97d@mail.gmail.com> <20080125111219.GB20026@elte.hu>
In-Reply-To: <20080125111219.GB20026@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> 
>> is_cpu(INTEL) already make sure we have mtrr_if got assigned and 
>> cpu_has_mtrr.
>>
>> may need to fix qemu instead...
> 
> no ...
> 
> lets not do non-sensical trimming of RAM, ok? Emit a warning but never 
> trim all of RAM and make the system unbootable. Trimmed RAM is something 
> that users can pester board/BIOS vendors with. Non-booting kernels is 
> something _we_ get pestered with ;-)
> 

*And* let's push a fix to Qemu/KVM as appropriate.

Last I checked Qemu never even turns caching on in %cr0, never mind gets 
the MTRRs right.  If it's advertising MTRRs, this is a problem.

	-hpa
