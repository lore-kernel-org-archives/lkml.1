Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbXKGQFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbXKGQFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 11:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbXKGQEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 11:04:53 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:38322 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbXKGQEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 11:04:52 -0500
Date: Wed, 7 Nov 2007 17:06:29 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unification of cfufreq/Kconfig
Message-ID: <20071107160629.GA17238@uranus.ravnborg.org>
References: <11943900793940-git-send-email-sam@ravnborg.org> <20071107060220.GX26163@stusta.de> <20071107070644.GA13937@uranus.ravnborg.org> <20071107071801.GY26163@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107071801.GY26163@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 08:18:01AM +0100, Adrian Bunk wrote:
> On Wed, Nov 07, 2007 at 08:06:44AM +0100, Sam Ravnborg wrote:
> > On Wed, Nov 07, 2007 at 07:02:20AM +0100, Adrian Bunk wrote:
> > > On Wed, Nov 07, 2007 at 12:01:12AM +0100, Sam Ravnborg wrote:
> > > >...
> > > >  config X86_SPEEDSTEP_CENTRINO
> > > > -	tristate "Intel Enhanced SpeedStep"
> > > > +	tristate "Intel Enhanced SpeedStep (deprecated)"
> > > >  	select CPU_FREQ_TABLE
> > > > -	select X86_SPEEDSTEP_CENTRINO_TABLE
> > > > +	select X86_SPEEDSTEP_CENTRINO_TABLE if X86_32
> > > > +	depends on X86_64 && ACPI_PROCESSOR
> > > >...
> > > 
> > > No.
> > > 
> > > 	depends on ACPI_PROCESSOR if X86_64
> > 
> > Gives syntax error.
> 
> That happens when you review something without trying it...
> 
> 	depends on (ACPI_PROCESSOR || !X86_64)

Got confused by the if and did the wrong conversion.
To make it look like the other config options I will use:

	depends on X86_64 || (X86_32 && ACPI_PROCESSOR)

It is longer but simpler.

Thanks,
	Sam
