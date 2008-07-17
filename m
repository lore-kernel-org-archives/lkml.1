Return-Path: <linux-kernel-owner+w=401wt.eu-S1759668AbYGQQpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668AbYGQQpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756397AbYGQQpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:45:35 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:54620 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756309AbYGQQpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:45:34 -0400
Message-ID: <487F772C.1070806@suse.de>
Date: Thu, 17 Jul 2008 20:45:32 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] acpi: Avoid dropping rapid hotkey events (or other GPEs)
 on Asus EeePC
References: <487D23C3.5070301@student.cs.york.ac.uk> <487F58B6.5040309@suse.de> <487F6D2E.2040501@tuffmail.co.uk>
In-Reply-To: <487F6D2E.2040501@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Alexey Starikovskiy wrote:
>> Hi Alan,
>>
>> Could you please test if your patch works with the last patch in #10919?
>>
>> Thanks,
>> Alex.
> Vacuously so.
> 
> My patch still applies, but #10919 makes it obsolete.
Not so, there are two polls in ec.c, first is poll for change in status register,
which gave the name to the mode, and still exists; the other is for event
in embedded controller, which was introduced to properly solve #9998, and part of
it is removed by patch in #10919.
>  My patch fixed a
> bug that shows up in polling mode.  #10919 kills polling mode.

> 
> I've tested v2.6.26 + #10919 and it works fine (except for spamming the
> kernel log - please read my Bugzilla comment).
> 
> 
> It appears that interrupt mode suffered from a race which is very
> similar to my original problem.  If two GPE interrupts arrive before the
> workqueue runs, then the second interrupt will be ignored because
> EC_FLAGS_QUERY_PENDING is still set.  This will happen with any EC if
> interrupts are very close together, right?
The notion of queue in embedded controller is new, it was never mentioned in
ACPI spec, so the driver was written with assumption that new query interrupt should
not arrive before we service previous one. There is even a chart in how interrupts
should occur near the EC query command...
> 
> I think my patch also fixes this theoretical problem.
I think, this is not a theoretical problem, but the problem we've tried to solve in
#9998, #10724, and so on.
> But I'd rather
> you took over on this.  I was already confused by ec.c in v2.6.26, and
> with #10919 I understand it even less.  E.g. why is
> ec_switch_to_poll_mode() still present; what does it do now do_ec_poll()
> is removed?
See above, I still disable EC GPE for the time than we have pending query,
so we better not wait for it to check the status register
> 
> I'm happy to work on this with you, but I'd need to be able understand
> the code first :-(.
Well, with this patch of yours, I guess, we will not have too many problems in EC left :-)
> 
> Alan

Thanks again,
Alex.
