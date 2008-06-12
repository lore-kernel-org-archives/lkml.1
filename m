Return-Path: <linux-kernel-owner+w=401wt.eu-S1761110AbYFLMfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761110AbYFLMfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757737AbYFLMfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:35:38 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:36043 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755532AbYFLMfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:35:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NBVfHoFIzTAUt+jykFbAHAfWb9pbbRkGHLiN4u4Cnm7WPa7AOxlDmEs4gUimItmc5WiTYI29Gc/cwTyaK2nV1BMb6mvUF/ZsW3MwtjLV6ogetuq128ey9F4f49XkbEHpalHqo1+RWcg2Wz34NefzXeYksC01MXcGXdV3sS3fpyY=  ;
X-YMail-OSG: nshApv4VM1kAZV3W.wp38dOoJd.GpRzF8FIAQVcCEigmaH.vzincDaatafxsBwI2eMQU2tHEYxvB3lYrljhlE7iz6O.pIvDrTsO5zBmPGyv0I46ctv1LV5AtpChJv3BrlEQ-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Cliff Wickman <cpw@sgi.com>
Subject: Re: [PATCHv4] SGI UV: TLB shootdown using broadcast assist unit
Date: Thu, 12 Jun 2008 22:35:29 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
References: <E1K6lqI-0006pX-JQ@eag09.americas.sgi.com>
In-Reply-To: <E1K6lqI-0006pX-JQ@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806122235.29888.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2008 22:23, Cliff Wickman wrote:
> From: Cliff Wickman <cpw@sgi.com>
>
> TLB shootdown for SGI UV.
>
> v1: 6/2 original
> v2: 6/3 corrections/improvements per Ingo's review
> v3: 6/4 split atomic operations off to a separate patch (Jeremy's review)
> v4: 6/12 include <mach_apic.h> rather than <asm/mach-bigsmp/mach_apic.h>
>          (fixes a !SMP build problem that Ingo found)
>          fix the index on uv_table_bases[blade]
> Now depends on patch:
>     x86 atomic operations: atomic_or_long atomic_inc_short
>   which was split off (and improved) at the suggestion of
>   Jeremy Fitzhardinge <jeremy@goop.org>
>
> This patch provides the ability to flush TLB's in cpu's that are not on
> the local node.  The hardware mechanism for distributing the flush
> messages is the UV's "broadcast assist unit".
>
> The hook to intercept TLB shootdown requests is a 2-line change to
> native_flush_tlb_others() (arch/x86/kernel/tlb_64.c).
>
> This code has been tested on a hardware simulator. The real hardware
> is not yet available.
>
> The shootdown statistics are provided through /proc/sgi_uv/ptc_statistics.
> The use of /sys was considered, but would have required the use of
> many /sys files.  The debugfs was also considered, but these statistics
> should be available on an ongoing basis, not just for debugging.
>
> Issues to be fixed later:
> - The IRQ for the messaging interrupt is currently hardcoded as 200
>   (see UV_BAU_MESSAGE).  It should be dynamically assigned in the future.
> - The use of appropriate udelay()'s is untested, as they are a problem
>   in the simulator.

For someone not too familiar with low level x86 (or UV) code, can
you explain why you are hooking at this point? I mean, what it
looks like is either a performance improvement, or for some reason
UV does not support send_IPI_mask out to CPUs "not on the local node".

If the former, what sort of improvement to you expect / see?

If the latter, then why aren't you hooking at send_IPI_mask? If
possible that would obviously be preferable so you aren't
making the tlb flushing harder to follow...

Can you set me straight? :)

Thanks,
Nick
