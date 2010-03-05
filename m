Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab0CEVV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 16:21:56 -0500
Received: from mail-px0-f175.google.com ([209.85.216.175]:58094 "EHLO
	mail-px0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab0CEVVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 16:21:52 -0500
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Mar 2010 16:21:52 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=OmU88VmPZtz9+f1bryAsDcjeOhCfibu6rJ4D+pnnvv2JJ+1aifefOwxQaQW4HPfG/Q
         c0Un4ueI8Z/0VLf53+5Th1iR56N9KgG2TKVBS/9R2gsEfTunYYVyxmzzcCeaB5Tq1E9l
         U2dpj2WA5RXY1cKh5a02RMVLIM5BjjuUVHyYQ=
MIME-Version: 1.0
Date: Sat, 6 Mar 2010 05:14:38 +0800
Message-ID: <10d816431003051314i3e87a2d2yab344826d14a310a@mail.gmail.com>
Subject: Different definition in div_sc and clocksource_cyc2ns
From: Lin Mac <mkl0301@gmail.com>
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

While working with the clocksource, I found that the relation of cycle
and nanosecond of div_sc and clocksource_cyc2ns is different.

linux-2.6.33
div_sc in include/linux/clockchips.h suggests that clock_ticks =
(nanoseconds * factor) >> shift.
  98/*
  99 * Calculate a multiplication factor for scaled math, which is
used to convert
 100 * nanoseconds based values to clock ticks:
 101 *
 102 * clock_ticks = (nanoseconds * factor) >> shift.
 103 *
 104 * div_sc is the rearranged equation to calculate a factor from a
given clock
 105 * ticks / nanoseconds ratio:
 106 *
 107 * factor = (clock_ticks << shift) / nanoseconds
 108 */
 109static inline unsigned long div_sc(unsigned long ticks, unsigned long nsec,
 110                                   int shift)
 111{
 112        uint64_t tmp = ((uint64_t)ticks) << shift;
 113
 114        do_div(tmp, nsec);
 115        return (unsigned long) tmp;
 116}


However, clocksource_cyc2ns in include/linux/clocksource.h suggest
nanoseconds=(cycles*mult)>>shift.
 268static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
 269{
 270        return ((u64) cycles * mult) >> shift;
 271}

But there are many others using div_sc, I don't think they got issues
with it. So what am I missing?

Best Regards,
Mac Lin
