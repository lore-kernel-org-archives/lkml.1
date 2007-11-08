Return-Path: <linux-kernel-owner+w=401wt.eu-S1760269AbXKHLYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269AbXKHLYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 06:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758577AbXKHLYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 06:24:03 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:37083 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758461AbXKHLYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 06:24:01 -0500
From: Marin Mitov <mitov@issp.bas.bg>
To: linux-kernel@vger.kernel.org
Subject: Re: is minimum udelay() not respected in preemptible SMP kernel-2.6.23?
Date: Thu, 8 Nov 2007 13:24:49 +0200
User-Agent: KMail/1.9.7
References: <200711071921.52330.mitov@issp.bas.bg> <20071107123045.c6d4b855.akpm@linux-foundation.org>
In-Reply-To: <20071107123045.c6d4b855.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711081324.49130.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Thanks to all of you answering to my post.

On 7.11.2007, Andrew Morton wrote:
> Ow.  Yes, from my reading delay_tsc() can return early (or after
> heat-death-of-the-universe) if the TSCs are offset and if preemption
> migrates the calling task between CPUs.
>
> I suppose a lameo fix would be to disable preemption in delay_tsc().

I have seen the problem in delay_tsc(), but I was pusled by these lines
in my dmesg:

> Time: acpi_pm clocksource has been installed.
> Switched to high resolution mode on CPU 0
> Switched to high resolution mode on CPU 1

I thought (sort of) acpi_pm (but not tsc) is used in udelay().

The same delay_tsc() is used in both arches: i386 & x86_64
(and as I see from the proposed patches in -mm, also for 
the new x86 arch). Should the patch be applied for all of them?

Quite similar function ia64_itc_udelay() is used in IA64, but one
find a coment before it:
/*
 * Generic udelay assumes that if preemption is allowed and the thread
 * migrates to another CPU, that the ITC values are synchronized across
 * all CPUs.
 */

Are they really synchronized or similar patch: preempt_disable/enable()
should be applied?

What about all other arches?

Thanks.

Marin Mitov
