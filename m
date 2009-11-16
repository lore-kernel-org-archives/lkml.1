Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbZKPRHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbZKPRHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 12:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbZKPRHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 12:07:22 -0500
Received: from smtp-out.google.com ([216.239.45.13]:18198 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbZKPRHW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 12:07:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=f4R8FX/0l+9N2tp/CvZF3Y+esAHwX2vRaynVlyQZAgdNcfDmLZe3E+/8TLGJkduEr
	ckNE5RcRJ4Y/ZPrDCIHZA==
MIME-Version: 1.0
In-Reply-To: <20091116165716.GD3568@n2100.arm.linux.org.uk>
References: <20091102104949.GA23456@elf.ucw.cz>
	 <20091116163659.GB3568@n2100.arm.linux.org.uk>
	 <a55d774e0911160843h22938604s8966a58ee71992a@mail.gmail.com>
	 <20091116165716.GD3568@n2100.arm.linux.org.uk>
Date: Mon, 16 Nov 2009 09:07:24 -0800
Message-ID: <a55d774e0911160907o27fcb1e1yde61e446039749a2@mail.gmail.com>
Subject: Re: [PATCH 2/3] msm: add minimal board file for HTC Dream device
From: Brian Swetland <swetland@google.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, "Arve Hj?nnev?g" <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 8:57 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Nov 16, 2009 at 08:43:20AM -0800, Brian Swetland wrote:
>> What's the best way to handle a situation where there is no valid
>> debug uart?  Could the arch/platform require DEBUG_LL be unset via
>> Kconfig directives if it is configured in a way where there is no
>> valid debug uart?
>
> You're the first to have that issue.  Everyone else has a UART they
> can always direct stuff at.
>
> However, I believe you're making the issue far larger than it really is.

I actually haven't run into it on the hardware I've worked on (often
the debug uart isn't exposed anywhere useful, but it's usually there),
but have seen designs where it would happen (all uarts assigned to
some non-debug function).  Just curious about how to deal with such a
situation correctly.

> 1. If you define the DEBUG_LL macros to be empty, printascii() etc will
>   not touch any mapping.
>
> 2. If no mapping is going to be touched by printascii(), does it matter
>   whether a UART is mapped via this early mapping stuff?
>
> The answer to (2) is no.
>
> So, you can still arrange for these fields to be populated with a valid
> value even if you don't intend to use the resulting mapping.  And so
> there's no need to force DEBUG_LL to be unset.
>
> If you really have no values you can use, make sure you set io_pg_offst
> to 0x3ffc - the last offset in the L1 page table.  This will cause the
> code to write a single dummy entry at the very top of the page table,
> which will then be overwritten by the generic ARM arch code for its own
> use.

Pointing it at UART1 with the DEBUG_LL macros empty in the event of no
debug uart available works great.

Thanks,

Brian
