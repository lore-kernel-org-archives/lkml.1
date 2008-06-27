Return-Path: <linux-kernel-owner+w=401wt.eu-S1763135AbYF0UDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763135AbYF0UDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758135AbYF0UD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:03:28 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:46945 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762825AbYF0UD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:03:27 -0400
Date: Fri, 27 Jun 2008 22:04:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: -tip build failure: No rule to make target `/etc/sound/dsp001.ld'
Message-ID: <20080627200414.GA19361@uranus.ravnborg.org>
References: <19f34abd0806271225q409dfa51haca8de843eeec76f@mail.gmail.com> <20080627194047.GD4306@cs181140183.pp.htv.fi> <19f34abd0806271259r338ec2c3w3b34e1703d4d97ba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806271259r338ec2c3w3b34e1703d4d97ba@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 09:59:50PM +0200, Vegard Nossum wrote:
> On Fri, Jun 27, 2008 at 9:40 PM, Adrian Bunk <bunk@kernel.org> wrote:
> > On Fri, Jun 27, 2008 at 09:25:05PM +0200, Vegard Nossum wrote:
> >> Hi,
> >>
> >> I was just building a randconfig in tip/master and hit this:
> >>
> >> make[2]: *** No rule to make target `/etc/sound/dsp001.ld', needed by
> >> `sound/oss/pss_boot.h'.  Stop.
> >>
> >> It seems to be done like this on purpose, but it breaks randconfig
> >> builds. Is this something that should be using firmware API?
> >>
> >> I'm attaching the config. Please forward this in the right direction,
> >> if such a thing exists.
> >
> > It's your fault - compile errors with CONFIG_STANDALONE=n are expected.
> 
> Ah, I see. In that case, shouldn't 'make randconfig' also make sure
> that this option is always =n? Or do I have to do
> 
> make randconfig
> make CONFIG_STANDALONE=n

Create a file fixed.config with the config options that may not change
and use:

make KCONFIG_ALLCONFIG=fixed.config randconfig

STANDALONE is one of them - I recall Ingo has a well tested set of options
he always forces to specific values.

[I may have the syntax wrong for KCONFGI_ALLCONFIG - please see README].

	Sam
