Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbZKJUey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbZKJUey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758090AbZKJUex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:34:53 -0500
Received: from 1wt.eu ([62.212.114.60]:50913 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758080AbZKJUex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:34:53 -0500
Date: Tue, 10 Nov 2009 21:34:34 +0100
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091110203434.GC26633@1wt.eu>
References: <4AF9020C.90108@zytor.com> <4AF9435F.2070103@redhat.com> <20091110105642.215804e0@lxorguk.ukuu.org.uk> <4AF99E04.8080704@zytor.com> <20091110172454.3c4481f2@lxorguk.ukuu.org.uk> <4AF9B5AB.5010800@zytor.com> <4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com> <20091110201602.GA26633@1wt.eu> <4AF9CC1E.2050700@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF9CC1E.2050700@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 12:25:02PM -0800, H. Peter Anvin wrote:
> On 11/10/2009 12:16 PM, Willy Tarreau wrote:
> > 
> > Indeed, but there is a difference between [cmpxchg, bswap, cmov, nopl]
> > on one side and [sse*] on the other : distros are built assuming the
> > former are always available while they are not always. And the distro
> > which make the difference have to provide an dedicated build for earlier
> > systems just for compatibility. SSE*, 3dnow* etc... are only used by a
> > handful of media players/converters/encoders which are able to detect
> > themselves what to use and already have the necessary fallbacks because
> > these instruction sets vary too much between processors and vendors.
> > 
> 
> That is increasingly not true since gcc is now doing autovectorization.

But programs have to be built to use that specific platform anyway ; this
is different from all programs built with support for CMOV enabled by
default and which will work on 95% of the platforms.

(...)
> I could 970 cmovs in libc out of 322660 instructions.  That is one in
> 333 instruction.

Not bad, I agree ! But on the C3, CMOV from/to register is implemented.
It's only CMOV from/to memory which has to be emulated, which makes it
a lot less common. Anyway that's why we need counters, so that the user
knows when he really ought to recompile.

(...)
> I don't see any particular subset as being more obvious than the other,
> with the *possible* exception of NOPL, simply because NOPL was
> undocumented for so long.

well, simply the availability of binaries making use of them. I'm not
sure you would find SSE* instructions in your libc where you found the
970 cmov. For NOPL, that's different, I first heard about it in this
thread, and my C3 running with the CMOV patch has never complained from
missing it :-)

Regards,
Willy

