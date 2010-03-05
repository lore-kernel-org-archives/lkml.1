Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab0CEV3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 16:29:44 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44566 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab0CEV3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 16:29:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=D5A3Q4IJ+HPTy3ySHVT9+akWreIHJUgk9KHvZgffDCafNFtmXcsTPXwdKBbdfKmrWq
         rPSoRgjWWKWEjB7GisXa+7jsvUQyGSjRTZLvrM+s7xegozxjtJnk1ssn4P2P+4MKhlsC
         L2bOyl1Nyt1KxeWW2xZjhAgyMppunibkokw9A=
MIME-Version: 1.0
In-Reply-To: <10d816431003051314i3e87a2d2yab344826d14a310a@mail.gmail.com>
References: <10d816431003051314i3e87a2d2yab344826d14a310a@mail.gmail.com>
Date: Fri, 5 Mar 2010 13:29:42 -0800
X-Google-Sender-Auth: 2ad3ba3fa38e33de
Message-ID: <1f1b08da1003051329ta5b905dq69eef81aedd4f463@mail.gmail.com>
Subject: Re: Different definition in div_sc and clocksource_cyc2ns
From: john stultz <johnstul@us.ibm.com>
To: Lin Mac <mkl0301@gmail.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 1:14 PM, Lin Mac <mkl0301@gmail.com> wrote:
> While working with the clocksource, I found that the relation of cycle
> and nanosecond of div_sc and clocksource_cyc2ns is different.
>
> linux-2.6.33
> div_sc in include/linux/clockchips.h suggests that clock_ticks =
> (nanoseconds * factor) >> shift.

> However, clocksource_cyc2ns in include/linux/clocksource.h suggest
> nanoseconds=(cycles*mult)>>shift.

You're comparing similar helper conversion functions from two
different subsystems.

Both use similar shifted math, but the div_sc() is for clockchips.h,
which is used by the clockevents code to trigger interrupts at a
specified time, while clocksource_cyc2ns() is for the clocksource
code, which converts  clockosurce cycles into nanoseconds for
timekeeping.


thanks
-john
