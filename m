Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbZB0SrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbZB0SrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 13:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbZB0SrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 13:47:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47509 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713AbZB0SrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 13:47:13 -0500
Message-ID: <49A8345F.8020800@zytor.com>
Date: Fri, 27 Feb 2009 10:43:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: add brk allocation for very, very early allocations
References: <49A829CE.9020509@goop.org>
In-Reply-To: <49A829CE.9020509@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> I'd like to add a mechanism like this so I can dynamically allocate some
> Xen-related structures, rather than statically allocating them in the bss,
> both so that Xen has less overhead when it isn't being used, and so I can
> scale better to things like memory size.
> 
> I think this is more widely useful; it would supplant dmi_alloc_data[], for
> example, and I'm sure there's other cases.
> 
> This is fundimentally the same as head_32.S's extension of the bss to build
> the initial kernel mapping, but 64-bit doesn't currently do anything
> analogous
> to this.
> 
> Unfortunately when I use this code as-is I'm getting crashes when the slab
> allocator starts up.  I think this is all correct, but I'm wondering if
> there's something I'm overlooking which is broken in principle.

First of all, I like the concept.  As far as getting crashes, I suspect
what you're finding is some use of this type of extended memory space
that just isn't documented.  I would try this in a simulator, setting a
watchpoint on _end to see if you get any hits before the slab allocator
starts.

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

