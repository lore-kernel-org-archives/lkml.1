Return-Path: <linux-kernel-owner+w=401wt.eu-S1761557AbYEXUP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557AbYEXUP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 16:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbYEXUPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 16:15:19 -0400
Received: from gw.goop.org ([64.81.55.164]:58496 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbYEXUPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 16:15:17 -0400
Message-ID: <48387736.9050004@goop.org>
Date: Sat, 24 May 2008 21:14:46 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [RFC PATCH] kconfig: introduce KCONFIG_* symbols for .c files
References: <20080524192540.GA28067@uranus.ravnborg.org> <20080524125316.4b969936.akpm@linux-foundation.org>
In-Reply-To: <20080524125316.4b969936.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> It could help to get us out of the occasional sticky situation, but it
>   

I think if you know you can use the if(KCONFIG_) technique, then one 
would tend to structure things so that you do it as much as possible.  
Ideally you'd use CONFIG vars in Makefiles to make code go away 
entirely, and if (KCONFIG_) in .c files to do conditional compilation.

> does seem a bit risky.  What happens with Kconfig variables which are
> just not known about at all with some .configs?
>
> Silly example, one could add
>
> 	if (KCONFIG_DVB_VES1820)
>
> to kernel/sched.c and that would work happily until someone sets DVB=n,
> in which case I assume KCONFIG_DVB_VES1820 doesn't get defined
> anywhere?
>
> A more realistic example might be using an x86-only KCONFIG_* in non-x86
> code.
>   

Well, logically that means that all config vars are always "known", even 
if they can never be defined.  I don't know what the practicalities of 
that are: can all Kconfig files everywhere reasonably be scanned to 
produce the symbol list?

    J

