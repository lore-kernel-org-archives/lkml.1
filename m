Return-Path: <linux-kernel-owner+w=401wt.eu-S1759804AbZFPHkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804AbZFPHkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 03:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbZFPHkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 03:40:00 -0400
Received: from av7-1-sn3.vrr.skanova.net ([81.228.9.181]:39725 "EHLO
	av7-1-sn3.vrr.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbZFPHj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 03:39:59 -0400
Message-ID: <4A374C50.1000508@mocean-labs.com>
Date: Tue, 16 Jun 2009 09:40:00 +0200
From: =?ISO-8859-15?Q?Richard_R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Trilok Soni <soni.trilok@gmail.com>, linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-omap@vger.kernel.org
Subject: Re: [RESEND][PATCH] input: Added TSC2003
References: <4A366439.70005@mocean-labs.com> <5d5443650906151110u3f7d9d1cm1990e767d29a45b6@mail.gmail.com> <4A36A1C2.2060805@mocean-labs.com> <20090616062044.GA20209@avionic-design.de>
In-Reply-To: <20090616062044.GA20209@avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-06-16 08.20, Thierry Reding wrote:
>>>>
>>> Meaning? I think I2C transaction can sleep.
>> Yes that's what it means, and that's bad in a HR timer callback.
> 
> Note that my patch to the tsc2007 to support the tsc2003 exactly fixes this
> problem. It moves the actual I2C transfers into a workqueue, so no sleeping
> functions are called from the hrtimer callback.

Ah good! The IRQ is disabled no sync too.
We actually don't have the possibility to implement a pen down state callback,
so I need to modify the code slightly to work even without one. (but not be
as accurate when the callback is not available)

Your patch where it schedules work rather than calling the I2C function directly
isn't in mainline.
I saw a patch where you added the work scheduling, and a later patch where you
fixed some spinlock stuff, have you resent the patch for the work scheduling?

--Richard
