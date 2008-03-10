Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYCJWMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYCJWMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYCJWM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:12:29 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:51188 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbYCJWM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:12:28 -0400
Date: Mon, 10 Mar 2008 22:02:01 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: P6 NOPs again: MPSC?
In-Reply-To: <47D59743.7040709@zytor.com>
Message-ID: <Pine.LNX.4.64.0803102142440.2464@blonde.site>
References: <Pine.LNX.4.64.0803041929230.14934@blonde.site>
 <20080304210111.GB31546@elte.hu> <47CDBE09.3060000@zytor.com>
 <Pine.LNX.4.64.0803101853090.15511@blonde.site> <47D59743.7040709@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008, H. Peter Anvin wrote:
> Hugh Dickins wrote:
> > 
> > I'm suspecting that the patch below is actually wrong, and that it's
> > really the "(X86_64 || !X86_GENERIC) &&" which should be changed;
> > but very unsure of my ground and what's right for CPU_GENERIC -
> > the 32/64 heritage of x86/Kconfig.cpu rather confuses me.
> 
> X86_64 && !X86_GENERIC comes from not wanting to be a compatibility issue when
> compiling for generic CPUs.  There are some 32-bit otherwise i686-compatible
> chips (from VIA and Transmeta) which don't have these NOPs.

Yup, I realized that (with || in place of &&): I meant that perhaps
it was supposed to say X86_64 || (!X86_GENERIC && (M686 || ....))
since quite a lot of other options there have "|| X86_64" to cover
all the 64-bit possibilities at once i.e. is it only MPSC that
needs to be added, or both MPSC and CPU_GENERIC?

(But I've lost my way around here.  A good example of the 32/64
confusion is how one has to remember that X86_GENERIC is peculiar
to 32-bit, and CPU_GENERIC peculiar to 64-bit.  And CPU_GENERIC is
understandably an alternative to the specific 64-bit models, but
X86_GENERIC is strangely in addition to the specific 32-bit models.)

Hugh
