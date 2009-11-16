Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZKPQnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZKPQnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 11:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbZKPQnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 11:43:22 -0500
Received: from smtp-out.google.com ([216.239.45.13]:6589 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbZKPQnU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 11:43:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=pKhuAh9VG+UdxEHP0EC2vcxHuE56qfZbDxRTexpXULoz/DOQaF1K6jTO8mtSMeobD
	12BITam5MLa3QEbMLAL9g==
MIME-Version: 1.0
In-Reply-To: <20091116163659.GB3568@n2100.arm.linux.org.uk>
References: <20091102104949.GA23456@elf.ucw.cz>
	 <20091116163659.GB3568@n2100.arm.linux.org.uk>
Date: Mon, 16 Nov 2009 08:43:20 -0800
Message-ID: <a55d774e0911160843h22938604s8966a58ee71992a@mail.gmail.com>
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

On Mon, Nov 16, 2009 at 8:36 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Nov 02, 2009 at 11:49:49AM +0100, Pavel Machek wrote:
>> +MACHINE_START(TROUT, "HTC Dream")
>> +#ifdef CONFIG_MSM_DEBUG_UART
>> +     .phys_io        = MSM_DEBUG_UART_PHYS,
>> +     .io_pg_offst    = ((MSM_DEBUG_UART_BASE) >> 18) & 0xfffc,
>> +#endif
>
> Why is this ifdef'd?  Two reasons why not to do this:
>
> 1. MSM_DEBUG_UART is always defined, so the conditional is pointless

For a default dream build, definitely, but not always on every msm7k
target (some devices may not have a serial port that can safely be
chattered at by the debug code).  For this board file, no harm to
require it.

> 2. the low level page table building code does not expect these to be
>   unset (or even set to an invalid value).  Leaving them unset and
>   having DEBUG_LL enabled is a recipe to prevent booting.

What's the best way to handle a situation where there is no valid
debug uart?  Could the arch/platform require DEBUG_LL be unset via
Kconfig directives if it is configured in a way where there is no
valid debug uart?

> To put it another way, these two fields aren't optional.
>

Thanks,

Brian
