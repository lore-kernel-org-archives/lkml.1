Return-Path: <linux-kernel-owner+w=401wt.eu-S1763096AbZEHJsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763096AbZEHJsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 05:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZEHJsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 05:48:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57593 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbZEHJsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 05:48:00 -0400
Date: Fri, 8 May 2009 11:47:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, tglx@linutronix.de, ebiederm@xmission.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 03/14] x86, config: change defaults PHYSICAL_START and
	PHYSICAL_ALIGN
Message-ID: <20090508094726.GE3559@elte.hu>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> <1241735222-6640-4-git-send-email-hpa@linux.intel.com> <20090508073606.GC12808@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508073606.GC12808@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Thu, May 07, 2009 at 03:26:51PM -0700, H. Peter Anvin wrote:
> > From: H. Peter Anvin <hpa@zytor.com>
> > 
> > Change the default for CONFIG_PHYSICAL_START to 16 MB; 4 MB if
> > EMBEDDED.  Change the default for CONFIG_PHYSICAL_ALIGN to match up
> > with a large page alignment datum (4 MB for non-PAE, 2 MB for PAE.)
> > 
> > The default of 16 MB is designed to avoid occupying ZONE_DMA, as well
> > as avoiding a 15-16 MB memory hole, which some vendors inexplicably
> > still have in their systems.
> > 
> > [ Impact: minor performance improvement, leave ZONE_DMA free ]
> > 
> > Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> > ---
> >  arch/x86/Kconfig |   19 +++++++++++--------
> >  1 files changed, 11 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 039c3f0..13b3a5a 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1455,17 +1455,20 @@ config KEXEC_JUMP
> >  
> >  config PHYSICAL_START
> >  	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
> > -	default "0x1000000" if X86_NUMAQ
> > -	default "0x200000" if X86_64
> > -	default "0x100000"
> > +	default "0x400000" if EMBEDDED
> > +	default "0x1000000"
> >  	---help---
> >  	  This gives the physical address where the kernel is loaded.
> >  
> >  	  If kernel is a not relocatable (CONFIG_RELOCATABLE=n) then
> >  	  bzImage will decompress itself to above physical address and
> > -	  run from there. Otherwise, bzImage will run from the address where
> > -	  it has been loaded by the boot loader and will ignore above physical
> > -	  address.
> > +	  run from there. Otherwise, bzImage will run from the either
> > +	  the above physical address or where it has been loaded by
> > +	  the boot loader, whichever is higher.
> > +
> > +	  For embedded machines with very small memory (less than
> > +	  about 24 MB) this may need to be adjusted downward from the
> > +	  default value of 0x1000000 (16 MB).
> 
> But in the above you say that default is "0x400000" if EMBEDDED
> That is in contradiction with the help - no?

Yes, the help text is wrong.

	Ingo
