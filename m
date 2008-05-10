Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbYEJVPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbYEJVPg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 17:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbYEJVP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 17:15:27 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57690 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbYEJVP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 17:15:26 -0400
Date: Sat, 10 May 2008 23:16:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc1 on x86: ld: warning: dot moved backwards before `.text'
Message-ID: <20080510211602.GA32339@uranus.ravnborg.org>
References: <18470.787.498329.144701@harpo.it.uu.se> <482604D1.7020804@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482604D1.7020804@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2008 at 01:25:53PM -0700, H. Peter Anvin wrote:
> Mikael Pettersson wrote:
> >
> >The resulting kernel hasn't broken on me yet, however.
> >
> >A search through the LKML archives showed that this was reported
> >for 2.6.25-rc3-mm1, but I couldn't find any discussion about it
> >after that:
> >
> ><http://marc.info/?l=linux-kernel&m=120470303728010&w=2>
> >
> >The .config causing this warning is available in
> ><http://user.it.uu.se/~mikpe/linux/ale/config-2.6.26-rc1>
> >
> 
> This is because the organization of the file was changed, and the linker 
> script wasn't changed to match:
> 
> SECTIONS
> {
>         . = HEADER_OFFSET;
>         .header : {
>                  *(.header)
>         }
> 
>         . = 0;
>         .text : {
>                  *(.text*)
>         }
> 
> This is crap; the sections should be listed *in order* so the linker can 
> warn properly when something bad happens.
> 
> The code should be correct; reorganizing the linker script correctly 
> should fix the problem.

I need Pavel to comment on this.
Why we start with . equal 0x3f00 and then later as . equals 0x0000
I dunno.
I did not look into this part of the code back then - but I should anyway
have seen this flaw in the linker script :-(

	Sam
