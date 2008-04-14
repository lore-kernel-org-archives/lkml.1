Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbYDNJwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbYDNJwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 05:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYDNJwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 05:52:30 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:46183 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbYDNJw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 05:52:29 -0400
Date: Mon, 14 Apr 2008 11:52:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: pgtable_32.h - prototype and section mismatch fixes
Message-ID: <20080414095259.GA11966@uranus.ravnborg.org>
References: <48022990.3060104@gmail.com> <20080414072645.GG16163@elte.hu> <20080414084127.GA11372@uranus.ravnborg.org> <20080414085307.GG19865@elte.hu> <20080414085927.GC11372@uranus.ravnborg.org> <48031FA7.9050803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48031FA7.9050803@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 11:11:03AM +0200, Jacek Luczak wrote:
> Sam Ravnborg pisze:
> > On Mon, Apr 14, 2008 at 10:53:07AM +0200, Ingo Molnar wrote:
> >> * Sam Ravnborg <sam@ravnborg.org> wrote:
> >>
> >>>> hm, that's an interesting case: we need those annotations probably 
> >>>> because gcc decided to not inline those functions. (this is possible 
> >>>> via the new CONFIG_OPTIMIZE_INLINING=y option) Sam, what's your take 
> >>>> on that?
> >>> gcc uses different heuristics for inlining between the different 
> >>> versions. Therefore to achieve somehow predictable results I added 
> >>> -fno-inline-functions-called-once when CONFIG_DEBUG_SECTION_MISMATCH 
> >>> is enabled.
> >>>
> >>> So in the above case for any normal kernel build we would see that gcc 
> >>> inlined the above and everything is fine. But for the 
> >>> CONFIG_DEBUG_SECTION_MISMTCH cases we do not inline and thus we see 
> >>> that we have a section mismatch.
> >> ah, ok. So i guess this will result in a few isolated cases of __init 
> >> annotations added to inline functions - Jacek fixed one such case - but 
> >> it should not result in the general spreading of __init annotations to 
> >> inline functions, correct? (which i was worried about)
> > I do not think so. The need for small isolated inline functions
> > in the init paths are minimal and last I did a section mismatch free
> > sweep on the kernel it was only few if any inline functions(*) I had
> > to annotate.
> > 
> > (*) Considering only the minimal amount of function that ought
> > to be annotated inlined.
> 
> There's a lot of inline __init functions already - which, on the other hand
> should not result in more of such. Attached you can find grep on tree which
> shows all inline __init functions (you won't find my paravirt_pagetable_setup_*
> functions in output as I removed __init for test).

Most of the functionas listed should never have been annotated inline.
If you filter aways the functions that are in one one of their
incarnations longer than 8 lines or are located in a .c file the list
is much shorter. This is the real candidates (the figure '8' is just bad way
to filter away 'complex' functions).
Your paravirt_pagetable_setup_done is a real one btw.

> Sam, do -fno-inline-functions-called-once could affect
> paravirt_pagetable_setup_done? In general there was no section mismatch warning
> for this function, but I've annotated it also.
Most liekly yes - but I did not check.

	Sam
