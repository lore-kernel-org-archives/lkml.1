Return-Path: <linux-kernel-owner+w=401wt.eu-S1757411AbYARIWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbYARIWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 03:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbYARIWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 03:22:37 -0500
Received: from free-electrons.com ([88.191.23.47]:34414 "EHLO
	sd-2511.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbYARIWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 03:22:36 -0500
Message-ID: <479061BF.2020801@free-electrons.com>
Date: Fri, 18 Jan 2008 09:22:23 +0100
From: Michael Opdenacker <michael-lists@free-electrons.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Taral <taralx@gmail.com>
CC: Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       Linux-tiny@selenic.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix unconditional arch/x86/kernel/pcspeaker.c compiling
References: <200801171643.49301.michael-lists@free-electrons.com>	 <478F8AEC.1080209@free-electrons.com>	 <1200590031.5332.19.camel@cinder.waste.org>	 <200801172315.29976.michael-lists@free-electrons.com> <fa0147d90801171916u2b96bfa0jbeceef57c9c0f641@mail.gmail.com>
In-Reply-To: <fa0147d90801171916u2b96bfa0jbeceef57c9c0f641@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2008 04:16 AM, Taral wrote:
> On 1/17/08, Michael Opdenacker <michael-lists@free-electrons.com> wrote:
>   
>> Another issue would be that we would no longer be able
>> to load the speaker driver module from a kernel which
>> wasn't originally compiled with support for this module.
>>     
>
> Have you looked at pcspeaker.o? As far as I can tell, it does *nothing*.
>   
Do you mean "almost nothing"? It still allocates and adds a platform
device, and the corresponding function always gets called at boot time.

I know that not compiling this piece of code just reduces the
uncompressed kernel size by just a few bytes (218). However, many small
contributions of this kind can have a significant impact on embedded
systems (or on boot media or on Linux based bootloaders).

As I said earlier, I'm starting to think that this trick should only be
used when CONFIG_EMBEDDED is set. In the non-embedded case, it's
probably not acceptable not to declare a platform device that is always
present in the system (while it's perfectly fine not to load the
corresponding driver).

Your comments and suggestions are more than welcome!

Michael.

-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

