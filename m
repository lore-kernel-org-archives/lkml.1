Return-Path: <linux-kernel-owner+w=401wt.eu-S933323AbZAQXnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323AbZAQXnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 18:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbZAQXni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 18:43:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52358 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbZAQXnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 18:43:37 -0500
Message-ID: <49726C56.6080905@zytor.com>
Date: Sat, 17 Jan 2009 15:40:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Kyle McMartin <kyle@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Mikael Pettersson <mikpe@it.uu.se>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "eliminate warn_on_slowpath()" change causes many gcc-3.2.3 warnings
References: <200901171519.n0HFJZuf028704@harpo.it.uu.se> <20090117161817.GA10825@elte.hu> <49723912.6020108@zytor.com> <20090117204421.GA1700@bombadil.infradead.org> <alpine.LFD.2.00.0901181032350.3006@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901181032350.3006@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Don't do this. That just forces a load off a complex pointer instead, with 
> no upsides. At least if it was
> 
> 	extern const char warn_slowpath_nofmt[];
> 
> it would only load the pointer itself, which is still a fairly  expensive 
> op, but at least doesn't require the extra memory load.
> 
> But you'd be better off jusst making it something like
> 
> 	#define NO_FMT ((const char *)(-1))
> 
> instead, which is really much more obvious, and doesn't need any of that 
> "get a pointer" overhead.
> 

At least on x86, the two ops should be the same cost?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

