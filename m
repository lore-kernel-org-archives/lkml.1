Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbYBQTrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbYBQTrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYBQTrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:47:11 -0500
Received: from slowhand.arndnet.de ([88.198.19.76]:46914 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752345AbYBQTrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:47:10 -0500
Message-ID: <47B88F2F.1030200@i4.informatik.rwth-aachen.de>
Date: Sun, 17 Feb 2008 20:46:55 +0100
From: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Iain Paton <ilp@lkml.darkvoyage.org.uk>
CC: Adrian Bunk <bunk@kernel.org>, Jordan Crouse <jordan.crouse@amd.com>,
       Andres Salomon <dilinger@queued.net>, marc.jones@amd.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, wim@iguana.be
Subject: Re: Geode GX/LX watchdog timer (RESEND)
References: <20080117211917.GF8244@cosmic.amd.com> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <20080117223644.GK8244@cosmic.amd.com> <478FDC12.6020505@i4.informatik.rwth-aachen.de> <20080119010624.GA25328@cosmic.amd.com> <47934B2E.3020707@i4.informatik.rwth-aachen.de> <20080121170700.GC6884@cosmic.amd.com> <4794E664.6020209@i4.informatik.rwth-aachen.de> <47B8413A.80105@lkml.darkvoyage.org.uk> <47B848A9.3080308@i4.informatik.rwth-aachen.de> <20080217145450.GB1403@cs181133002.pp.htv.fi> <47B85C61.7060507@lkml.darkvoyage.org.uk>
In-Reply-To: <47B85C61.7060507@lkml.darkvoyage.org.uk>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Iain Paton schrieb:
> Adrian Bunk wrote:
>> On Sun, Feb 17, 2008 at 03:46:01PM +0100, Arnd Hannemann wrote:
>>> Never tried to built it as a module.
>>> Probably there are issues with that. If I remember correctly I saw a
>>> patch in 2.6.25-rc which
>>> mentioned that using mfgpt in modules won't work. Does this apply to
>>> 2.6.24 as well?
>>
>> For using code from modules it must be explicitely
>> EXPORT_SYMBOL{,GPL}'ed.
>>
>> Adding
>>   EXPORT_SYMBOL_GPL(geode_mfgpt_toggle_event);
>> and
>>   EXPORT_SYMBOL_GPL(geode_mfgpt_alloc_timer);
>> below the respective functions in mfgpt_32.c should fix this issue.
> 
> I couldn't find the patch Arnd mentioned on lkml or in Linus git tree,
> but adding the lines suggested by Adrian gets me a working module.


I meant commit fa28e067c3b8af96c79c060e163b1387c172ae75 in linus git, but seems
I misinterpreted it.

>     x86: GEODE: MFGPT: drop module owner usage from MFGPT API
>     
>     We had planned to use the 'owner' field for allowing re-allocation of
>     MFGPTs; however, doing it by module owner name isn't flexible enough.  So,
>     drop this for now.  If it turns out that we need timers in modules, we'll
>     need to come up with a scheme that matches the write-once fields of the
>     MFGPTx_SETUP register, and drops ponies from the sky.
>     
>     Signed-off-by: Andres Salomon <dilinger@debian.org>
>     Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Best regards,
Arnd
