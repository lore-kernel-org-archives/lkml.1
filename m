Return-Path: <linux-kernel-owner+w=401wt.eu-S1761268AbXKHOvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761268AbXKHOvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 09:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758615AbXKHOvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 09:51:47 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47515 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758614AbXKHOvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 09:51:46 -0500
Date: Thu, 8 Nov 2007 15:51:20 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unification of cfufreq/Kconfig
Message-ID: <20071108145119.GI26163@stusta.de>
References: <11943900793940-git-send-email-sam@ravnborg.org> <20071107060220.GX26163@stusta.de> <20071107070644.GA13937@uranus.ravnborg.org> <20071107071801.GY26163@stusta.de> <20071107160629.GA17238@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071107160629.GA17238@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 05:06:29PM +0100, Sam Ravnborg wrote:
> On Wed, Nov 07, 2007 at 08:18:01AM +0100, Adrian Bunk wrote:
> > On Wed, Nov 07, 2007 at 08:06:44AM +0100, Sam Ravnborg wrote:
> > > On Wed, Nov 07, 2007 at 07:02:20AM +0100, Adrian Bunk wrote:
> > > > On Wed, Nov 07, 2007 at 12:01:12AM +0100, Sam Ravnborg wrote:
> > > > >...
> > > > >  config X86_SPEEDSTEP_CENTRINO
> > > > > -	tristate "Intel Enhanced SpeedStep"
> > > > > +	tristate "Intel Enhanced SpeedStep (deprecated)"
> > > > >  	select CPU_FREQ_TABLE
> > > > > -	select X86_SPEEDSTEP_CENTRINO_TABLE
> > > > > +	select X86_SPEEDSTEP_CENTRINO_TABLE if X86_32
> > > > > +	depends on X86_64 && ACPI_PROCESSOR
> > > > >...
> > > > 
> > > > No.
> > > > 
> > > > 	depends on ACPI_PROCESSOR if X86_64
> > > 
> > > Gives syntax error.
> > 
> > That happens when you review something without trying it...
> > 
> > 	depends on (ACPI_PROCESSOR || !X86_64)
> 
> Got confused by the if and did the wrong conversion.
> To make it look like the other config options I will use:
> 
> 	depends on X86_64 || (X86_32 && ACPI_PROCESSOR)
> 
> It is longer but simpler.

But wrong...

	depends on X86_32 || (X86_64 && ACPI_PROCESSOR)

> Thanks,
> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

