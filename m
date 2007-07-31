Return-Path: <linux-kernel-owner+w=401wt.eu-S941003AbXGaDzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941003AbXGaDzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940853AbXGaDzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:55:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:47778 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940826AbXGaDzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:55:33 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/2] Introduce CONFIG_HIBERNATION and CONFIG_SUSPEND (updated)
Date: Mon, 30 Jul 2007 23:54:17 -0400
User-Agent: KMail/1.9.5
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org> <200707292323.29601.rjw@sisk.pl> <alpine.LFD.0.999.0707291717410.3442@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707291717410.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707302354.18212.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 July 2007 20:21, Linus Torvalds wrote:
> 
> Ok, I took this, and modified Len's patch to re-introduce ACPI_SLEEP on 
> top of it (I took the easy way out, and just made PM_SLEEP imply 
> ACPI_SLEEP, which should make everything come out right. I could have 
> dropped ACPI_SLEEP entirely in favour of PM_SLEEP, but that would have 
> implied changing more of Len's patch than I was really comfy with).
> 
> Len, Rafael, please do check that the end result looks ok. 

SUSPEND depends only on (!SMP || SUSPEND_SMP_POSSIBLE).
This means that while we limit the architectures it can build on
if they are SMP, it can build on any !SMP architecture --
which probably isn't what we want.

I think the right way to go is your SUSPEND_UP_POSSIBLE suggestion.
Honestly, I though it was overly verbose when I first read it,
but I like it better now, especially since it works;-)
I'll reply w/ an incremental patch.

> I suspect ACPI could now take the PM_SLEEP/SUSPEND/HIBERNATE details into 
> account, and that some of the code is not necessary when HIBERNATE is not 
> selected, for example, but I'm not at all sure that it's worth it being 
> very fine-grained.

As you know, I don't think that it is worth dedicated config options
to save 16KB on an SMP+ACPI kernel.  The prospect of adding code to
slice that 16KB into finer grain savings seems even less worthwhile.

-Len
