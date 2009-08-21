Return-Path: <linux-kernel-owner+w=401wt.eu-S932862AbZHUVig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862AbZHUVig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932803AbZHUVif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:38:35 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:42755 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326AbZHUVie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:38:34 -0400
Date: Fri, 21 Aug 2009 23:38:33 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Beulich <JBeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: properly annotate alternatives.c
Message-ID: <20090821213833.GA16210@merkur.ravnborg.org>
References: <4A8BC8A00200007800010823@vpn.id2.novell.com> <20090821200908.GF5356@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821200908.GF5356@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 10:09:08PM +0200, Ingo Molnar wrote:
> 
> * Jan Beulich <JBeulich@novell.com> wrote:
> 
> > Some of the NOPs tables aren't used on 64-bits, quite some code and
> > data is needed post-init for module loading only, and a couple of
> > functions aren't used outside that file (i.e. can be static, and don't
> > need to be exported).
> > 
> > The change to __INITDATA/__INITRODATA is needed to avoid an assembler
> > warning.
> > 
> > Signed-off-by: Jan Beulich <jbeulich@novell.com>
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> > 
> > ---
> >  arch/x86/include/asm/alternative.h |    7 ----
> >  arch/x86/kernel/alternative.c      |   56 +++++++++++++++++++++----------------
> >  include/linux/init.h               |   12 ++++++-
> >  3 files changed, 42 insertions(+), 33 deletions(-)
> 
> looks like a nice improvement. Sam, what do you think?
I briefly looked at the __INIT*DATA cahnges.
I recall that I had something similar only that I used @progbits which
arm does not support. And I did not want to specialcase arm.

It is only recently I learned that we can always use %progbits.

So it has my:
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
