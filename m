Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbYHTKIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbYHTKIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbYHTKII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:08:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58527 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbYHTKIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:08:07 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: ioremap panic
From: Andi Kleen <andi@firstfloor.org>
References: <86802c440808162049u12fc92c4teae43c9b6f4a72b8@mail.gmail.com>
	<20080819235106.d6776abc.akpm@linux-foundation.org>
Date: Wed, 20 Aug 2008 12:08:05 +0200
In-Reply-To: <20080819235106.d6776abc.akpm@linux-foundation.org> (Andrew Morton's message of "Tue, 19 Aug 2008 23:51:06 -0700")
Message-ID: <871w0kyp6i.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>
> Please work out what address qla2x00_probe_one() passed into ioremap(),

Note that ioremap doesn't get a virtual address, but a bus/phys one.
The virtual address checked in the BUG above comes internally
out of vmalloc's address space allocation.

> then see if you can work out what was already at that virtual address
> (/proc/iomem, dmesg output, etc).

The bug is more likely that either the kernel page tables or the 
vmalloc vmlist are inconsistent somehow. In particularly it looks
like vmalloc gave out an address for ioremap on which there was
already a mapping.

I doubt it is qla2x00's fault.

-Andi
