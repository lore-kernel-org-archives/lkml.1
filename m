Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbZKHCPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbZKHCPG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 21:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZKHCPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 21:15:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51894 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbZKHCPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 21:15:04 -0500
Message-ID: <4AF6299F.50706@zytor.com>
Date: Sat, 07 Nov 2009 18:14:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Matteo Croce <technoboy85@gmail.com>
CC: Martin Schleier <drahemmaps@gmx.net>, Krzysztof Halasa <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <20091106154911.29400@gmx.net> <20091106155937.11d95279@lxorguk.ukuu.org.uk> 	<20091106165731.26800@gmx.net> <20091106182218.43940287@lxorguk.ukuu.org.uk> 	<20091106200620.179910@gmx.net> <m3r5sbcl07.fsf@intrepid.localdomain> 	<20091107000559.166710@gmx.net> <40101cc30911070311u56035911l5eb50ac4abb73acc@mail.gmail.com>
In-Reply-To: <40101cc30911070311u56035911l5eb50ac4abb73acc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2009 03:11 AM, Matteo Croce wrote:
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ b/arch/x86/kernel/nopl_emu.c	2009-11-07 11:59:17.667748571 +0100
> @@ -0,0 +1,103 @@
> +/*
> + *  linux/arch/x86/kernel/nopl_emu.c
> + *
> + *  Copyright (C) 2002  Willy Tarreau
> + *  Copyright (C) 2009  Matteo Croce
> + */
> +
> +#include <linux/linkage.h>
> +#include <asm/math_emu.h>
> +#include <asm/traps.h>
> +
> +/* This code can be used to allow the AMD Geode to hopefully correctly execute
> + * some code which was originally compiled for an i686, by emulating NOPL,
> + * the only missing i686 instruction in the CPU
> + *
> + * Willy Tarreau <willy@meta-x.org>
> + * Matteo Croce <technoboy85@gmail.com>
> + */
> +

If we're doing to introduce a missed-instruction interpreter (which is
what this is) in the kernel, it needs to handle all the subtleties of
x86 execution correctly; in particular I believe it needs to check the
code segment limits, permissions, and mode.  Things it doesn't
understand it can SIGILL (or, if more appropriate, SIGSEGV) on, of course.

Personally I think the easiest is to verify that the code segment is
flat 32 bits or even more specifically CS == USER_CS, and SIGILL otherwise.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

