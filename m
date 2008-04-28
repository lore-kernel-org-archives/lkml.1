Return-Path: <linux-kernel-owner+w=401wt.eu-S933907AbYD1OLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933907AbYD1OLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934654AbYD1OLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:11:39 -0400
Received: from trillian.zoopnet.de ([85.214.111.199]:51904 "EHLO
	trillian.zoopnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934643AbYD1OLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:11:38 -0400
Message-ID: <4815DB15.4070908@zoopnet.de>
Date: Mon, 28 Apr 2008 16:11:33 +0200
From: Mika Fischer <mika.fischer@zoopnet.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Gabriel C <nix.or.die@googlemail.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, balajirrao@gmail.com,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
References: <200801192045.17291.yinghai.lu@sun.com> <200801202256.48365.yinghai.lu@sun.com> <20080122165125.GA17992@elte.hu> <200801221623.20861.yinghai.lu@sun.com> <20080426035614.a30afb17.akpm@linux-foundation.org> <48132665.8050202@googlemail.com> <86802c440804272344yac6a9f0n40809169424247e6@mail.gmail.com> <48159668.5010808@googlemail.com> <86802c440804280234y5b38b4bds330fc1a6987202c5@mail.gmail.com> <48159ECF.9020004@googlemail.com> <20080428135351.GF3973@elte.hu>
In-Reply-To: <20080428135351.GF3973@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I'm having the same problem.

Ingo Molnar schrieb:
> excellent. So just to make sure: this box never had proper graphics 
> under Linux (under no previous kernel), due to the way the BIOS has set 
> up the MTRR's, right?

Well, not quite. X still works fine, but since the video memory is
overlapped by two of the existing MTRRs, X cannot add a write-combining
range for the video memory. That makes X rather slow especially if you
use DRI for Compiz etc.

And this always happens with 4GB RAM, but not with 2GB RAM.

So yes, with this patch for the first time X works at normal speed with
4GB of RAM out of the box.

> so fixing up the MTRRs during bootup, no matter how dangerous in theory, 
> is pretty much the best option to get your system to work fine under 
> Linux, with that specific Xorg version?

Yes. That's what I'm doing at the moment with a shell script. :)

> i think we should still try to make this a non-default option because 
> modern Xorg should not have any need to touch MTRRs. Perhaps a .config 
> dependent on CONFIG_DANGEROUS ;-)

AFAICT X always tries to set up a write-combining range for the video
memory. And this will always fail if there are erroneous write-back or
even uncachable ranges overlapping the video memory...

But I don't know if this has changed in newer versions of Xorg (I'm
using 7.3).

In any case if I have a range in /proc/mtrr that is declared uncachable
and overlaps my video memory (which is the case without this patch),
is there even anything Xorg can do to make the video-memory use
write-combining?

Regards,
 Mika
