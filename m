Return-Path: <linux-kernel-owner+w=401wt.eu-S1762331AbXGJXA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762331AbXGJXA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 19:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760025AbXGJXAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 19:00:16 -0400
Received: from gw.goop.org ([64.81.55.164]:58651 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760016AbXGJXAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 19:00:14 -0400
Message-ID: <46940F45.3090005@goop.org>
Date: Tue, 10 Jul 2007 15:59:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
CC: Al Boldi <a1426z@gawab.com>, Pavel Machek <pavel@ucw.cz>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com>	<4691BC0F.8050909@yahoo.com.au> <20070709135205.GB3216@elf.ucw.cz>	<200707091830.48074.a1426z@gawab.com> <87hcoduh4k.fsf@jbms.ath.cx>	<46939E5E.6010305@goop.org> <871wfguq5g.fsf@jbms.ath.cx>
In-Reply-To: <871wfguq5g.fsf@jbms.ath.cx>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Maitin-Shepard wrote:
> I suppose that would be an interesting thing to look into.  Another
> possible approach for having the kernel run in non-contiguous memory is
> to specify a memmap exactly to the kernel on the command-line, as I
> believe is done for the crashdump kernels currently. 

That sounds very fragile.  It would be better to extend the bootparams 
to contain that information.

> I recall reading, though, that even with the relocatable
> kernel support, there are still significant alignment requirements for
> loading the kernel.  In particular, I seem to recall that it is
> necessary to load an x86 kernel at maybe a 16MB boundary, and on other
> platforms the alignment requirements may be even more restrictive.

2MB for x86, I think.  But that's not really an issue if you use a 
P(seudo-physical) to M(achine) mapping, since you can choose any 
arrangement you like for the kernel.  The only restriction is that you 
can't use large pages any more, but I don't think that's an issue for a 
dump/hibernation kernel.

>   In
> addition, I recall that the Linux boot procedure on x86 and on some
> other platforms necessarily uses certain low-address memory, like the
> first 640K, which must be backed up regardless.
>   

Well, the traditional framebuffer/ISA space between 640k and 1M probably 
needs to be identity mapped, but I don't think there's anything in there 
which specifically needs to be save/restored (except framebuffer 
contents, maybe?).

> For these reasons, it seems that it would be easiest to simply backup
> the first e.g. 16 or 64 MB of memory, and not have to worry about
> loading the kernel at a non-standard address and specifying a
> complicated exact memmap.  Someone might prove me wrong, though.
>   

Yes, I suppose.  You're certain the old kernel's devices are completely 
quiescent at that point?

    J

