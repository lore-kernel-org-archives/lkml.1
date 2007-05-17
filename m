Return-Path: <linux-kernel-owner+w=401wt.eu-S1761186AbXEQEw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761186AbXEQEw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 00:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755726AbXEQEwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 00:52:19 -0400
Received: from terminus.zytor.com ([192.83.249.54]:37606 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531AbXEQEwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 00:52:19 -0400
Message-ID: <464BDF58.2090907@zytor.com>
Date: Wed, 16 May 2007 21:51:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Christian <haveaniceday@cv-sv.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
References: <464B9D2C.7040704@cv-sv.de> <alpine.LFD.0.98.0705161750350.3890@woody.linux-foundation.org> <464BAF07.9020003@cv-sv.de> <alpine.LFD.0.98.0705161920410.3890@woody.linux-foundation.org> <464BC67F.7080707@zytor.com> <alpine.LFD.0.98.0705162012340.3890@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705162012340.3890@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 16 May 2007, H. Peter Anvin wrote:
>> It gets turned on by the code in arch/i386/kernel/cpu.  It's just that
>> the new code that Andi added runs during setup, i.e. in real mode, so
>> *way* earlier than that.
> 
> Ahh. Do we really need it that early?

The reason to do it early is so that we can still get a message out if
the CPU doesn't have the necessary features.  This is generic code and
not specific to CX8.

Since I'm rewriting the setup code in C, I have added code to enable
features on VIA and Transmeta CPUs (there was already code in there to
enable features on AMD; Intel isn't known to hide any features other
than PAE on 400 MHz FSB Pentium-M.)

I think the early feature detection makes good sense.  It's a heckuva
lot nicer to get a message on your screen saying that you can't boot
this kernel on this CPU than a crash, or an early_printk which may never
actually get to you.

	-hpa
