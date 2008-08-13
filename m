Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbYHMR3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbYHMR3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYHMR3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:29:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52364 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYHMR3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:29:35 -0400
Message-ID: <48A319AB.9030707@zytor.com>
Date: Wed, 13 Aug 2008 10:28:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mark Langsdorf <mark.langsdorf@amd.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: invalidate caches before going into suspend
References: <200808131141.18003.mark.langsdorf@amd.com> <20080813164728.GD5720@elte.hu> <48A31188.4050904@zytor.com> <20080813170133.GA16557@elte.hu>
In-Reply-To: <20080813170133.GA16557@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>>
>> Spurious interrupt of what kind?  The only things that could come in 
>> would not be non-INT type interrupts, and those aren't affected by 
>> CLI.
> 
> nothing should come in really at that point - but say IRQ#7 on older 
> platforms used to trigger at various points in time, even unprompted. Or 
> an APIC error interrupt in the last moment? All device irqs should 
> indeed be turned off at this stage, but since it costs us nothing to add 
> another cli, and because the failure mode is subtle memory corruption, 
> does it hurt to have it?
> 

Not significantly, but I cannot for my life figure out how it could help.

Either the interrupts will be blocked by the CLI already in effect, or 
the additional CLI will not help, either (in fact, it will just slightly 
increase the window for something like that to slip in.)

	-hpa

