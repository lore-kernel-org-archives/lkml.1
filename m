Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbYI3NGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbYI3NGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 09:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYI3NGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 09:06:12 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:33347 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYI3NGL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 09:06:11 -0400
Date: 30 Sep 2008 15:06:06 +0200
From: krzysztof.h1@poczta.fm
Subject: Re: [PATCH] x86: enable CPUID on Cyrix cpus with CPUID disabled
To: Ingo Molnar <mingo@elte.hu>, Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Samuel Sieb <samuel@sieb.net>
MIME-Version: 1.0
Content-Type: TEXT/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-ORIGINATE-IP: 83.17.101.58
X-Mailer: PSE
Message-Id: <20080930130606.66276199B265@f14.poczta.interia.pl>
X-EMID: 99d40acc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * Krzysztof Helt <krzysztof.h1@poczta.fm> wrote:
> 
> > From: Krzysztof Helt <krzysztof.h1@wp.pl>
> > 
> > The macros setCx86_old() and getCx86_old() do not
> > work as a comment says in the processor-cyrix.h.
> > 
> > Use working inline functions instead to enable
> > the CPUID instriction on Cyrix cpus. 
> > 
> > Tested on IBM 6x86MX cpu with disabled the
> > CPUID instruction.
> > 
> > Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> > ---
> > 
> > This patch is against the linux-next tree (20080819)
> > as it contains the following patch:
> > 
> > x86, cyrix: debug
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> >
> http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=026e2c05ef58ef413e2d52696f125d5ea1aa8bce
> > 
> > The linux-2.6-tip tree has not the Ingo's patch so it 
> > does not require my patch.
> > 
> > I am confused. Is the x86 detection code for Cyrix
> > cpus is right in the linux-next or in the linux-2.6-tip?
> > Should I prepare patches against the linux-2.6-tip
> > or linux-next?
> 
> now that the bug is correctly understood and fixed, could you please 
> send a patch that cleans it all up and gets rid of the setCx86_old() / 
> setCx86() API distinction? I.e. revert commit 026e2c0 ("x86, cyrix: 
> debug"). Against tip/master please.
> 
> note that this was all done in connection to:
> 
>  commit c6744955d0ec0cb485c28c51eeb7185e260f6172
>  Author: Samuel Sieb <samuel@sieb.net>
>  Date:   Wed Aug 6 22:06:29 2008 -0700
> 
>     x86: fix "kernel won't boot on a Cyrix MediaGXm (Geode)"
> 

I know that it was connected with the Geode booting, but I read the cyrix.c file and most paths are Geode specific and I won't be able to test them. I tested that reverting the commit 026e2c0 ("x86, cyrix: debug") does not break anything on 6x86MX cpu.

If the tip/master is a correct tree, please revert the commit 026e2c0 in the linux-next and drop this patch. This way everything is correct.

Regards,
Krzysztof

----------------------------------------------------------------------
Dzwon taniej na zagraniczne komorki!
Sprawdz >> http://link.interia.pl/f1f26 

