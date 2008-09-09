Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYIIE6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYIIE6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 00:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYIIE5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 00:57:53 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:28123 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbYIIE5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 00:57:52 -0400
Date: Tue, 9 Sep 2008 07:05:01 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dave Airlie <airlied@linux.ie>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: 2.6.27-rc5-mm1: 3 WARN_ON dumps during boot (acpi +
 vmap_pte_range)
Message-Id: <20080909070501.244d06ab.krzysztof.h1@poczta.fm>
In-Reply-To: <200809091304.47769.nickpiggin@yahoo.com.au>
References: <20080906084558.dff614d4.krzysztof.h1@poczta.fm>
	<200809081937.16427.nickpiggin@yahoo.com.au>
	<20080908195208.773ecadb.krzysztof.h1@poczta.fm>
	<200809091304.47769.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 64e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008 13:04:47 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Tuesday 09 September 2008 03:52, Krzysztof Helt wrote:
> 
> > alloc_vmap_area within(e07f0000-fffb7000) size=801000
> > returns=(e0880000-e1081000)
> > alloc_vmap_area within(e07f0000-fffb7000) size=2000
> > returns=(e07f0000-e07f2000)
> > alloc_vmap_area within(e07f0000-fffb7000) size=2000
> > returns=(e0822000-e0824000) 
> > vunmap_page_range (e07f0000-e07f2000 size=2000)
> > free_vmap_area (e07f0000-e07f2000 size=2000)
> 
> > alloc_vmap_area within(e07f0000-fffb7000) size=5000
> > returns=(e07f0000-e07f5000)
> > ------------[ cut here ]------------ 
> > WARNING: at mm/vmalloc.c:40 check_pte_range+0x83/0x90()
> 
> Thanks for that, it clearly shows the virtual address allocator
> is allowing an overlapping allocation after a vm_unmap_aliases()
> call. Unfortunately, my "random" test case happened not to
> trigger that... I should have paid more attention to edge cases
> rather than just random testing.
> 
> Anyway, I hope this fix should solve the problem for you? (it
> fixes it here)
> 

Your patch fixes two WARN_ON dumps from my original dmesg (agp 
related and module loading related).
The remaining one is the acpi kobject duplication.

Tested-by: Krzysztof Helt <krzysztof.h1@wp.pl>

Thanks a lot Nick,
Krzysztof

----------------------------------------------------------------------
Tanie polaczenia z Polska i ze swiatem
Sprawdz >>  http://link.interia.pl/f1f00 


