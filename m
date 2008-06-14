Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbYFNJGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbYFNJGO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 05:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383AbYFNJF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 05:05:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:27746 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbYFNJF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 05:05:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BPhD0Vxt7mW5IEl+CTyq7ozln5Z64kdvMOzp0ZEEs6dA03lVpx+v3D3sgeI16luGo9
         oF4mDHH9ZKUYlVNHBR8sUcXoPKxolyaD5oWhyrEfVE70aCClnoetj3xE+xA9upy1wMp0
         ADtZ29hooi/QuLY1dYw6JIZc9r2zuSJFpyZeM=
Message-ID: <86802c440806140205g3ff113ffq39272c18ef5b9654@mail.gmail.com>
Date: Sat, 14 Jun 2008 02:05:56 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH] x86: use add_highpages_with_active_regions for high pages init
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080614082343.GB11277@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806132005.45836.yhlu.kernel@gmail.com>
	 <200806140056.32601.yhlu.kernel@gmail.com>
	 <20080614082343.GB11277@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 1:23 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> use early_node_map to init high pages, so can remove page_is_ram and
>> page_is_reserved_early in the big loop with add_one_highpage
>>
>> also remove the page_is_reserved_early that is not needed.
>
> applied to tip/x86/mpparse for testing, thanks.
>
> Andrew: mm/page_alloc.c modification.

Ying Huang,

I removed page_is_reserved_early....it cause init highmem take extra
time on my big box.

please check efi_reserve_early that is calling reserve_early. so need
to make sure "EFI memmap" is reserved in itself...otherwise you may
need to update e820 table by add_memory_region (....,
E820_RESERVED)...

YH
