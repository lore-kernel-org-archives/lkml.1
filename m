Return-Path: <linux-kernel-owner+w=401wt.eu-S1762739AbYARRAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762739AbYARRAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758959AbYARQ7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:59:54 -0500
Received: from sd-6163.dedibox.fr ([88.191.46.45]:4084 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757777AbYARQ7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:59:53 -0500
X-Greylist: delayed 1798 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2008 11:59:52 EST
Message-ID: <4790D3E3.4060409@free-electrons.com>
Date: Fri, 18 Jan 2008 17:29:23 +0100
From: Michael Opdenacker <michael-lists@free-electrons.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linux-tiny@selenic.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: fix	unconditional	arch/x86/kernel/pcspeaker.c?compiling
References: <200801171643.49301.michael-lists@free-electrons.com>	 <478F8AEC.1080209@free-electrons.com>	 <1200590031.5332.19.camel@cinder.waste.org>	 <200801172315.29976.michael-lists@free-electrons.com>	 <20080118110252.GA17397@elte.hu> <47909821.1090907@free-electrons.com>	 <20080118122540.GH11044@elte.hu> <20080118122926.GA15216@elte.hu>	 <4790A385.800@free-electrons.com> <1200664214.4001.24.camel@cinder.waste.org>
In-Reply-To: <1200664214.4001.24.camel@cinder.waste.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2008 02:50 PM, Matt Mackall wrote:
> On Fri, 2008-01-18 at 14:03 +0100, Michael Opdenacker wrote:
>   
>> However, wouldn't the Makefile look nicer if we introduced a
>> CONFIG_PCSPEAKER setting as in the mips platform? We would just have:
>>
>> obj-$(CONFIG_PCSPEAKER)		+= pcspeaker.o
>>     
>
> Yes, that would be cleaner. Not worth it for just x86, but there are
> about 6 other arches that use CONFIG_INPUT_PCSPKR. Do that in one patch
> on top of this one and send it to Andrew (who will pull the above into
> his tree from Ingo shortly).
>   
Well, sorry for consuming your time with this very small change, but I'm
not sure I understand what you're suggesting... Here's what I'd do:

    * I'd define  CONFIG_PCSPEAKER for x86 (typically in
      arch/x86/Kconfig), to be set to "y"  when CONFIG_INPUT_SPKR is
      set. This is what minimizes the changes to make.
    * This way, we can just have:
      obj-$(CONFIG_PCSPEAKER) += pcspeaker.o

Did I understand things right? Anyway, the current situation is not so
bad either.
> Also, bear in mind that there is a fair amount of lower-hanging fruit
> than this, so bouncing a bunch of patches back and forth to make this
> perfect is not the best use of people's time.
>   
Sounds fine! Don't hesitate to let us know about the lower-hanging fruit
you're thinking about. Here are the main things I have so far:

    * Ideas in the existing Linux-Tiny patchset.
    * Disable support for non-Intel processors in x86 (cyrix.c,
      centaur.c, transmeta.c, nexgen.c, umc.c in arch/x86/kernel/cpu).
      As far as I remember, I saved 15 KB when I first experimented with
      this).
    * Disable support for readahead, page writeback, pdflush and swap
      when we have no storage at all (typically booting from an
      initramfs). This corresponds to 69 KB of source code!

So, more ideas are welcome!

Thanks for your time,

Michael.

-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

