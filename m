Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab0CIGow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 01:44:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:60984 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab0CIGou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 01:44:50 -0500
Message-ID: <4B95EE4C.3020606@kernel.org>
Date: Tue, 09 Mar 2010 15:44:28 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: odd lockdep messages
References: <24605.1268073053@localhost> <1268073831.4997.69.camel@laptop>            <4B95AA4C.2030303@kernel.org> <4298.1268116039@localhost>
In-Reply-To: <4298.1268116039@localhost>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Mar 2010 06:44:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/09/2010 03:27 PM, Valdis.Kletnieks@vt.edu wrote:
> Doesn't seem to make a difference, sorry.
> 
> For what it's worth, adding the iwlwifi-5000-2.ucode to the builtin firmware
> list fixed the two BUG: messages related to the firmware load.  Not sure if
> that tells you anything or not.
> 
> However, I still have left:
> 
> [    0.997904] Monitor-Mwait will be used to enter C-1 state
> [    0.998045] Monitor-Mwait will be used to enter C-2 state
> [    0.998184] Monitor-Mwait will be used to enter C-3 state
> [    0.998300] Marking TSC unstable due to TSC halts in idle
> [    0.998476] Switching to clocksource hpet
> [    1.030681] BUG: key ffff88011c8c1d00 not in .data!
> [    1.030787] BUG: key ffff88011c8c1d48 not in .data!
> [    1.035288] thermal LNXTHERM:01: registered as thermal_zone0
> [    1.035405] ACPI: Thermal Zone [THM] (54 C)
> [    1.041622] Real Time Clock Driver v1.12b
> [    1.041955] Linux agpgart interface v0.103
> [    1.042266] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
> 
> I'll stick a 'WAR_ON(1)' next to that BUG printk so we get an idea where it's
> happening, probably be morning before that happens though...

Hmm... the original percpu address check wasn't correct but wasn't too
far off either so it wouldn't be surprising nothing triggered it.
Yeap, stack trace should tell us where the address is coming from.

Thanks.

-- 
tejun
