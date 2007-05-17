Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbXEQDSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbXEQDSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 23:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbXEQDSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 23:18:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41408 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758590AbXEQDSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 23:18:02 -0400
Date: Wed, 16 May 2007 20:16:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Christian <haveaniceday@cv-sv.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
In-Reply-To: <464BC67F.7080707@zytor.com>
Message-ID: <alpine.LFD.0.98.0705162012340.3890@woody.linux-foundation.org>
References: <464B9D2C.7040704@cv-sv.de> <alpine.LFD.0.98.0705161750350.3890@woody.linux-foundation.org>
 <464BAF07.9020003@cv-sv.de> <alpine.LFD.0.98.0705161920410.3890@woody.linux-foundation.org>
 <464BC67F.7080707@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 May 2007, H. Peter Anvin wrote:
> 
> It gets turned on by the code in arch/i386/kernel/cpu.  It's just that
> the new code that Andi added runs during setup, i.e. in real mode, so
> *way* earlier than that.

Ahh. Do we really need it that early?

Now, it's easy enough to just turn off CONFIG_X86_CMPXCHG64 (it really 
should be "8B" instead of "64", but that's another issue) for those 
things, and nobody should really care, but still, maybe we could re-do the 
early bits to be more polite to those VIA CPU's?

I thought the cmpxchg8b stuff was just used to page table setup. Do those 
things even _support_ PAE?

What else uses it? Early setup in real mode? What am I missing? My grep 
powers are waning..

		Linus
