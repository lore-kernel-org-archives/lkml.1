Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbYHXLs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbYHXLs6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 07:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYHXLst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 07:48:49 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:22307 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbYHXLss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 07:48:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XQLnOL9GWETAuh9SWk8U8acAQ1ErJZPIwuaPC37Jenh55W7VFnAlS1rXvUtqE2TptM
         NTRtK2r34jHVqFWLS2r/CsJAs90dNWI8+p0vX864bXtr1lbYjN5t/Lhx//OQhFGHxdXt
         XJ19hMNr70lvefK+z18clqHWB1oWgiFKIbLQ8=
Message-ID: <19f34abd0808240448w5facaee2gec77662c14b9364f@mail.gmail.com>
Date: Sun, 24 Aug 2008 13:48:47 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Mikael Pettersson" <mikpe@it.uu.se>
Subject: Re: [BUG] get_rtc_time() triggers NMI watchdog in hpet_rtc_interrupt()
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
In-Reply-To: <18609.14516.873317.52292@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808230948.m7N9mUc1016360@harpo.it.uu.se>
	 <19f34abd0808240214o22748804s45e8487d62b34cb8@mail.gmail.com>
	 <18609.14516.873317.52292@harpo.it.uu.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 12:32 PM, Mikael Pettersson <mikpe@it.uu.se> wrote:
>  > I also just got this during shutdown:
>  >
>  > Syncing hardware clock to system time BUG: NMI Watchdog detected
>  > LOCKUP on CPU0, ip c011d922, registers:
>  > Pid: 4181, comm: hwclock Not tainted (2.6.27-rc3-00464-g1fca254-dirty #42)
[...]

> See my reply in the thread following Ingo's patch
> <http://lkml.org/lkml/2008/8/23/158>. I've only seen the lockup
> while hwclock was setting or flushing the system time, so I suspect
> broken interaction between the hpet rtc emulation and the rtc
> user-space interface.

Oops, I picked the wrong thread :-)

Anyway, I guess it wouldn't be too hard to make a test cast by running
"hwclock" (or the corresponding initscript) in a tight loop? (Sorry, I
am not able to test this myself at the moment). That would make it
easier to test the patch too, I guess. Maybe something like:

    $ while true; do /etc/init.d/ntpdate up; /etc/init.d/ntpdate down; done

(At least "ntpdate" is the one that runs hwclock for me on F9.)

I will try this later unless you beat me to it :-)

Thanks,


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
