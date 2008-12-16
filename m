Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbYLPTHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbYLPTHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYLPTHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:07:25 -0500
Received: from gw.goop.org ([64.81.55.164]:47255 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbYLPTHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:07:24 -0500
Message-ID: <4947FC68.4020603@goop.org>
Date: Tue, 16 Dec 2008 11:07:20 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Martin Steigerwald <ms@teamix.de>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: physical memory limit of 64-bit linux
References: <200812161556.25518.ms@teamix.de> <200812161654.17291.rjw@sisk.pl> <20081216184742.GL11683@elte.hu>
In-Reply-To: <20081216184742.GL11683@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> phase 3)  We could also go close to 47 bits: with various more invasive
>           movings of VMALLOC and rest upwards, and other considerations
>           such as the elimination of the generous start of 8 TB hole at
>           __PAGE_OFFSET - i.e. moving __PAGE_OFFSET straight down to
>           minus 128 TB. 120 TB would be doable.
>   

Originally it was there, but I moved it up because that's where Xen puts 
itself when running a PV 64-bit guest.  It is also properly 
parameterised now, so we could make it move on the basis of a config 
setting.

> phase 4)  If the 48 bits limit is ever lifted on the CPU side, we can move
>           __PAGE_OFFSET down. This is actually less invasive than phase 
>           3), because moving __PAGE_OFFSET is relatively easy. The far
>           more invasive change would be the necessary changes to the
>           virtual memory code: the current 4-level paging has a 256 TB 
>           limit which comes from the 512*512*512*512*4K split of 
>           pgd/pud/pmd/pte entries. Either PGDIR_SHIFT would have to be 
>           increased, moving the root pgtable's size from 4K to 8K or more, 
>           or another pgdir level would have to be introduced (which is 
>           even more intrusive and much less likely to be implemented by hw
>           makers).
>   

...or we could just reintroduce highmem ;)

    J
