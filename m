Return-Path: <linux-kernel-owner+w=401wt.eu-S933140AbZAQXh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140AbZAQXh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 18:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761680AbZAQXht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 18:37:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761620AbZAQXhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 18:37:48 -0500
Date: Sun, 18 Jan 2009 10:37:22 +1100 (EST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kyle McMartin <kyle@infradead.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Mikael Pettersson <mikpe@it.uu.se>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "eliminate warn_on_slowpath()" change causes many gcc-3.2.3
 warnings
In-Reply-To: <20090117204421.GA1700@bombadil.infradead.org>
Message-ID: <alpine.LFD.2.00.0901181032350.3006@localhost.localdomain>
References: <200901171519.n0HFJZuf028704@harpo.it.uu.se> <20090117161817.GA10825@elte.hu> <49723912.6020108@zytor.com> <20090117204421.GA1700@bombadil.infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 17 Jan 2009, Kyle McMartin wrote:
> 
> How about something utterly evil? (Since you can't pass a zero-length
> string to a printf attributed function either...)

Don't do this. That just forces a load off a complex pointer instead, with 
no upsides. At least if it was

	extern const char warn_slowpath_nofmt[];

it would only load the pointer itself, which is still a fairly  expensive 
op, but at least doesn't require the extra memory load.

But you'd be better off jusst making it something like

	#define NO_FMT ((const char *)(-1))

instead, which is really much more obvious, and doesn't need any of that 
"get a pointer" overhead.

		Linus
