Return-Path: <linux-kernel-owner+w=401wt.eu-S1752241AbZJTV57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbZJTV57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 17:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZJTV56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 17:57:58 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:3578 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbZJTV55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 17:57:57 -0400
Message-ID: <4ADE3225.5050001@caviumnetworks.com>
Date: Tue, 20 Oct 2009 14:56:53 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
       Mikael Pettersson <mikpe@it.uu.se>, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] Make MIPS dynamic clocksource/clockevent clock code generic
References: <1255819715-19763-1-git-send-email-linus.walleij@stericsson.com> <alpine.LFD.2.00.0910200454300.2863@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0910200454300.2863@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Oct 2009 21:56:53.0381 (UTC) FILETIME=[3BEB6350:01CA51D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Sun, 18 Oct 2009, Linus Walleij wrote:
>> This moves the clocksource_set_clock() and clockevent_set_clock()
>> from the MIPS timer code into clockchips and clocksource where
>> it belongs. The patch was triggered by code posted by Mikael
>> Pettersson duplicating this code for the IOP ARM system. The
>> function signatures where altered slightly to fit into their
>> destination header files, unsigned int changed to u32 and inlined.
>>
>> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Mikael Pettersson <mikpe@it.uu.se>
>> Cc: Ralf Baechle <ralf@linux-mips.org>
>> ---
>> Ralf has stated in earlier conversation that this should be moved,
>> now we risk duplicating code so let's move it.
> 
> Please do not make that functions inline. They are too large and there
> is no benefit of inlining them.
> 

If that is the case, then perhaps they should not be defined in a header 
file.

IMHO if you are defining a function in a header file it should always be 
  'static inline'.  If you don't want it in-lined, put it in some 
library so we only pick up a single instance of it.

David Daney
