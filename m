Return-Path: <linux-kernel-owner+w=401wt.eu-S1760735AbXLADOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760735AbXLADOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 22:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758755AbXLADOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 22:14:11 -0500
Received: from rtr.ca ([76.10.145.34]:1927 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757273AbXLADOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 22:14:10 -0500
Message-ID: <4750D180.6080001@rtr.ca>
Date: Fri, 30 Nov 2007 22:14:08 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, abelay@novell.com,
       lenb@kernel.org, mlord@pobox.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
References: <200711302153.lAULrZ7n026255@imap1.linux-foundation.org>	<924EFEDD5F540B4284297C4DC59F3DEE2FAE6A@orsmsx423.amr.corp.intel.com>	<20071130142058.816d1693.akpm@linux-foundation.org>	<924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com>	<4750CC78.9070105@rtr.ca> <20071130190227.1976e682@laptopd505.fenrus.org>
In-Reply-To: <20071130190227.1976e682@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Fri, 30 Nov 2007 21:52:40 -0500
> Mark Lord <lkml@rtr.ca> wrote:
> 
>> Pallipadi, Venkatesh wrote:
> 
>>> Exporting it as read only should be OK. We also need to know if
>>> there are hard user space dependency on writing to this from
>>> userspace.
>> ..
>>
>> Well, actually..  my scripts have a firm need to write "1" to it,
>> and then later restore the original value.
>>
>> This is needed to *greatly* speed up an otherwise sluggish binary I
>> use, 
> 
> just curious, but this does sound like the c-state code has a bug...
> independent of the sysfs thing, I think that really needs solving
> 
> Can you describe the behavior a little? Or provide information to the
> degree that some of us can figure out how to tweak the algorithm..,.
> 
> 
>> as well as whenever I want to semi-accurately benchmark I/O.
>>
>> Is there another way to achieve exactly the same behaviour?
> 
> in -mm there is.. the QoS stuff allows you to set maximum tolerable
..

That's encouraging, I think, but not for 2.6.24.

> latency. If your app cant take any latency, you should set those... and
> the side effect is that the kernel will not do long-latency C-states or
> P-state transitions..
..

I don't mind the cpufreq changing (actually, I want it to drop in cpugfreq
to save power and keep the fan off), but the C-states just kill this app.

The app is VMware.  I force the max_state=1 when launching,
and restore it to (prior value) 8 when it exits.
Makes a *huge* difference for text input and the like.
Yes, there's something there that could get fixed in the app,
and maybe one day will get fixed.  But I'm not holding my breath.

I think it manages to resonate at exactly the harmonic required that
the chip transitions to C?? just prior to the app wanting to wake up 
and do another poll.  Just kills it.

I'm not sure about C?? -- it could be C8 or even be C2 or whatever.
I suppose I should find out, but that really takes a lot of fuss (hours)
to measure, and isn't strictly repeatable.



 

