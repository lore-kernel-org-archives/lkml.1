Return-Path: <linux-kernel-owner+w=401wt.eu-S939014AbXHMD1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939014AbXHMD1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 23:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935552AbXHMD0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 23:26:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48130 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934337AbXHMD0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 23:26:52 -0400
Date: Sun, 12 Aug 2007 20:26:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
cc: Andi Kleen <ak@suse.de>, dean@arctic.org, patches@x86-64.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [1/12] x86: Work around mmio config space quirk on AMD
 Fam10h
In-Reply-To: <20070813030632.GA1445@redhat.com>
Message-ID: <alpine.LFD.0.999.0708122021300.30176@woody.linux-foundation.org>
References: <20070809241.425881000@suse.de> <20070809124128.886BE14F3B@wotan.suse.de>
 <alpine.LFD.0.999.0708120216470.30176@woody.linux-foundation.org>
 <200708121203.23741.ak@suse.de> <alpine.LFD.0.999.0708121205210.30176@woody.linux-foundation.org>
 <20070813030632.GA1445@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 12 Aug 2007, Dave Jones wrote:
> 
> This does make me wonder, why these weren't caught in -mm ?

I'm worried that -mm isn't getting a lot of exposure these days. People do 
run it, but I wonder how many..

That said, a lot of machines won't ever use MMCFG (especially the old ones 
- and most of the new ones would run x86-64), so that probably explains at 
least that one.

But the x86-64 alternates code would hit anybody who had the "use rep movs 
for best performance" code, and I'm surprised that one wasn't caught 
earlier. X86_FEATURE_REP_GOOD is not uncommon (Core 2 has it). So I assume 
that one wasn't really in -mm at all.

		Linus
