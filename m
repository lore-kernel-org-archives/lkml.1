Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbXLKVOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbXLKVOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 16:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbXLKVOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 16:14:43 -0500
Received: from mfe1.polimi.it ([131.175.12.23]:56124 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751088AbXLKVOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 16:14:42 -0500
Date: Tue, 11 Dec 2007 22:10:29 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Guillaume Chazarain <guichaz@yahoo.fr>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071211221029.5af4cb43@morte>
In-Reply-To: <20071211090120.GA27690@elte.hu>
References: <200712080340.49546.rjw@sisk.pl>
	<20071210204212.GA5502@elte.hu>
	<20071210125923.37bd2f10.akpm@linux-foundation.org>
	<20071210224508.GB27178@elte.hu>
	<20071210230425.GA641@elte.hu>
	<20071211003433.5cf0230d@morte>
	<20071211090120.GA27690@elte.hu>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.311128, Antispam-Data: 2007.12.11.130025
X-PerlMx-Spam: Gauge=II, Probability=22%, Report='RELAY_IN_PBL_11 2.5, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, RELAY_IN_PBL 0, __CP_URI_IN_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 10:01:20 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> ok, just to make sure we are all synced up. I made 8 patches related to 
> this problem category (and all the trickle effects). 3 are upstream 
> already, 5 are pending for v2.6.25. One out of those 5 is an immaterial 
> cleanup patch - which leaves us 4 patches to sort out.
> 
> So i'd suggest for you to try latest -git - that will tell us whether 
> udelay() is acceptable on your box right now.

Yes, it is (msleep(2000), as said, gives delays between 2 and 2.9s on my
box, and drivers are happy).

The commit which fixed this (it seems) is
fa2dd441df28b9fdfc68f84ae66f1b507cfff0e4. I'll bisect and tell you more in the
next days.

> i've attached those 4 patches:
> 
>  x86-sched_clock-re-scheduler-fix-x86-regression-in-native-sched-clock.patch
>  x86-cpu-clock-idle-event.patch
>  sched-printk-recursion-fix.patch
>  sched-printk-clock-fix.patch
> 
> none of them is _supposed_ to have any effect on udelay(), but the 
> interactions in this area are weird.

No effects here IIRC.

> [ note: CONFIG_PRINTK_TIME will be broken and only fixed in v2.6.25, so 
>   use some other time metric for determining mdelay quality. ]
> 
> plus then there's this patch:
> 
>   http://lkml.org/lkml/2007/12/7/100
> 
> is it perhaps this one that fixed udelay for you? [ which would be much 
> more expected, as this patch changes udelay ;-) ]

Will try it ASAP, again, in the next few days anyway.


--
Ciao
Stefano
