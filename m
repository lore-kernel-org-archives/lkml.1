Return-Path: <linux-kernel-owner+w=401wt.eu-S1759981AbZDWTpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981AbZDWTpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZDWTpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:45:36 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:30734 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751841AbZDWTpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:45:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JELT67YQsHwSCHXore2edVm063/l7m660gIXtskQ3CwWsCLKV5Z/TfxufmI2yAwwYrs1WoZRD6FMljmXZHrIx22AMqjCGlrZbaJzqjCGf2nZgh4Pt1OVqHxYiRNGH9I8HJeitlWQyB6NxU/+hs6Nmavz4up6NPefnzOQTVDVlMU=  ;
X-YMail-OSG: enxaGZgVM1kbQbsVl1eau151rrLO8F3qUIzoGM8VDfzq0FsbnUu8izrDkttfZaMvkqzG0itFjp7kp_uRIMIfIZXb_tPQfXP4n_XHOMApR9m9Z9z4whBSBTco5Ky6Z9FmOUS_CvRYi2CQxkOoURcIJ4hyv1mhw1hQyJb118AcYIveui6G0WzdrcQWT5THCracESwqHzX5q_2sRDeMFN6MmYmO9ZLSu87JzLOAAyWEOsmvT9ydkU4VqwIFteZiccSlUJvNXXY1y2CCN9v2zggoI4lGCgAZCdf9GONeUgHag0flIrM3vV.VyrX4Xvy3Zv72D8NirE6InuwPCsqpZjMlB2TN2xsbBwSicistlwAsm3UeiGk5BchBvdbOvF.0YXWKXjAob0QCXba7NP9Ue.alBXHR927xo3PEReqJpWZEySrZqSGZORd6odPGH4yUOjMsMCP9.9ymfUxcwTdtwgyl93fcfopHKyoKo0qyNgmmqEqTDDLgxX-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [rtc-linux] Re: [PATCH] rtc: Make rtc_update_irq callable with irqs enabled
Date: Thu, 23 Apr 2009 12:45:32 -0700
User-Agent: KMail/1.9.10
Cc: rtc-linux@googlegroups.com, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hcegtvedt@atmel.com, vapier@gentoo.org, rongkai.zhan@windriver.com,
       balajirrao@openmoko.org, broonie@opensource.wolfsonmicro.com
References: <20090410005820.4fcfcc1f@i1501.lan.towertech.it> <200904231225.01618.david-b@pacbell.net> <20090423212639.7ba7cb0b@i1501.lan.towertech.it>
In-Reply-To: <20090423212639.7ba7cb0b@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904231245.33435.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 April 2009, Alessandro Zummo wrote:
> 
> > If you're talking about a different patch, please forward...
> 
>  no patch, just theory.
> 
>  the question is, do we need IRQs disabled when
>  calling rtc_update_irq?

If the spinlock is *ever* acquired with IRQs disabled,
it must *always* be acquired that way.

The typical use is ... from IRQ context, which will in
some cases mean IRQs disabled.  QED.


>  and if yes, why? to prevent what?

Consider:  one context grabs spinlock with IRQs enabled.
IRQ arrives.  That context tries to grab that same lock,
from the same CPU.  ==> Self-deadlock.

