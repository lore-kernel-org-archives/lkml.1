Return-Path: <linux-kernel-owner+w=401wt.eu-S1751959AbYDNI7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbYDNI7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756218AbYDNI66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:58:58 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:33796 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbYDNI66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:58:58 -0400
Date: Mon, 14 Apr 2008 10:59:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jacek Luczak <difrost.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: pgtable_32.h - prototype and section mismatch fixes
Message-ID: <20080414085927.GC11372@uranus.ravnborg.org>
References: <48022990.3060104@gmail.com> <20080414072645.GG16163@elte.hu> <20080414084127.GA11372@uranus.ravnborg.org> <20080414085307.GG19865@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414085307.GG19865@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 10:53:07AM +0200, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > > hm, that's an interesting case: we need those annotations probably 
> > > because gcc decided to not inline those functions. (this is possible 
> > > via the new CONFIG_OPTIMIZE_INLINING=y option) Sam, what's your take 
> > > on that?
> > 
> > gcc uses different heuristics for inlining between the different 
> > versions. Therefore to achieve somehow predictable results I added 
> > -fno-inline-functions-called-once when CONFIG_DEBUG_SECTION_MISMATCH 
> > is enabled.
> > 
> > So in the above case for any normal kernel build we would see that gcc 
> > inlined the above and everything is fine. But for the 
> > CONFIG_DEBUG_SECTION_MISMTCH cases we do not inline and thus we see 
> > that we have a section mismatch.
> 
> ah, ok. So i guess this will result in a few isolated cases of __init 
> annotations added to inline functions - Jacek fixed one such case - but 
> it should not result in the general spreading of __init annotations to 
> inline functions, correct? (which i was worried about)
I do not think so. The need for small isolated inline functions
in the init paths are minimal and last I did a section mismatch free
sweep on the kernel it was only few if any inline functions(*) I had
to annotate.

(*) Considering only the minimal amount of function that ought
to be annotated inlined.

	Sam
