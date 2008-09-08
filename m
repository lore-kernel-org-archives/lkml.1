Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbYIHUSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbYIHUSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 16:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbYIHUSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 16:18:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35709 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbYIHUSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 16:18:33 -0400
Message-ID: <48C587A1.5010206@zytor.com>
Date: Mon, 08 Sep 2008 13:14:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org>	<alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org>	<48C56D60.7010405@zytor.com>	<20080908114619.741b6786@infradead.org>	<48C57439.3040903@zytor.com>	<20080908190249.GA21998@elte.hu>	<alpine.LFD.1.10.0809081213330.3117@nehalem.linux-foundation.org> <20080908125525.72bc1ad2@infradead.org>
In-Reply-To: <20080908125525.72bc1ad2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> 
> I'd lump all cpus that don't have cpuid in this bucket too (eg half the
> 486es) simply because not having cpuid is painful in pretty much the
> same way.
> 

Not really.  Detecting CPUID is pretty trivial, and we just initialize 
the feature vector to zero if it isn't there.

>>  - "modern 32-bit": PPro and better. Can take CMOV, MMX and TSC for 
>>    granted.
> 
> again makes sense; question is if it makes sense to take PSE and PAE
> for granted as well (although PSE we can do runtime I suppose)

Well, PAE implies PSE.  Unfortunately Intel released a series of 
Pentium-Ms without PAE support.  We *should* be able to take PSE for 
granted, but there is Xen damage.

	-hpa
