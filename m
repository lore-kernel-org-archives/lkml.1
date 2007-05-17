Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbXEQOPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbXEQOPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbXEQOPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:15:44 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:27170 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbXEQOPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:15:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QisSiqfgZRunEJs3uOeQ+pbr30Phzqvbg/I5y4tCBNK/+/WuFP35y2wKpQJvSe6VLzo1c/rC0XSyc0A7qlq+3DddUcfW/VpJuAq2e3uZ03o0nAPGGuKYCE3CDxLYyprc5ghjHk4KNtN6ecyjRIb08JI43LddrEbm2Z+tCOCrJ3w=
Message-ID: <d120d5000705170715s2066ea39r9b129e5efe79c4dd@mail.gmail.com>
Date: Thu, 17 May 2007 10:15:37 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH] INPUT: Sanitize PIT locking in pcspkr
Cc: LKML <linux-kernel@vger.kernel.org>, "Stable Team" <stable@kernel.org>,
       "Greg KH" <greg@kroah.com>, "Andrew Morton" <akpm@osdl.org>,
       "Andi Kleen" <ak@suse.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Ralf Baechle" <ralf@linux-mips.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Richard Henderson" <rth@twiddle.net>
In-Reply-To: <1179408962.3764.72.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179408962.3764.72.camel@chaos>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

> +#include <asm/i8253.h>

I don't see this file in include/asm-i386 and your patch only creates
asm-x86_64...
BTW, is there any reason 8253pit.h can't be used...?

Hmm... The best way IMO woudl be if arch code attached spinlock that
should be used by pcspkr driver to pcspkr platform device (as
platform_data) and we would not have private lock at all.

BTW, with all that usevent_supress busiess, does pcspkr gets loaded
automatically nowadays?

-- 
Dmitry
