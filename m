Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab0BHJve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 04:51:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60125 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab0BHJvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 04:51:32 -0500
Message-ID: <4B6FDDA9.4000200@zytor.com>
Date: Mon, 08 Feb 2010 01:47:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] sched: Fix unused variable warning on UP (was: Re: 	linux-next:
 tip tree build warning)
References: <10f740e81002071157p11b78784i8091d4790c29f30d@mail.gmail.com>	 <1265572738.12224.278.camel@laptop>	 <10f740e81002071226g3290d276q4c9df0e79a1e7ac0@mail.gmail.com> <10f740e81002071231j6977c6c7ie3f9e82bd0170f21@mail.gmail.com>
In-Reply-To: <10f740e81002071231j6977c6c7ie3f9e82bd0170f21@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2010 12:31 PM, Geert Uytterhoeven wrote:
>
> <trying to completely destroy my credibility>
> Shouldn't put_cpu() take a (possibly dummy) `cpu' parameter, as
> returned by get_cpu()?
> </trying>
>

Please tell me that you're joking.

There is absolutely no reason for it, since there is only one CPU that 
you can put (the one you're already on.)  The only thing that will 
happen if you insist on carrying the CPU number forward (unless it is 
used anyway) is that the compiler will generate worse code.

get_cpu() returning the CPU you're on is a convenience; it's so you 
don't need to do a third operation just to get your current CPU number, 
but it could just as easily be done that way.

	-hpa
