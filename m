Return-Path: <linux-kernel-owner+w=401wt.eu-S1752738AbYJSCxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbYJSCxv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 22:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYJSCxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 22:53:41 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:51758 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbYJSCxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 22:53:40 -0400
Date: Sat, 18 Oct 2008 23:53:23 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Scott Wood <scottwood@freescale.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       paulus@samba.org, benh@kernel.crashing.org
Subject: Re: [PATCH] powerpc: enable heap randomization for linkstations
Message-ID: <20081019025323.GA7887@ime.usp.br>
References: <20081013040703.GA11059@ime.usp.br> <20081013045116.GA11637@ime.usp.br> <Pine.LNX.4.64.0810132003350.9041@axis700.grange> <20081013184443.GA20612@ld0162-tx32.am.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081013184443.GA20612@ld0162-tx32.am.freescale.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Oct 13 2008, Scott Wood wrote:
> On Mon, Oct 13, 2008 at 08:05:09PM +0200, Guennadi Liakhovetski wrote:
> > On Mon, 13 Oct 2008, Rogério Brito wrote:
> > > The current defconfig for Linkstation/Kuroboxes has the "Disable
> > > Heap Randomization" option enabled.
> > > 
> > > Since some of these machines are facing the internet, it helps to
> > > have heap randomization enabled. This patch enables it.
> > 
> > Same as the previous patch - this is one of options, that users
> > select according to their needs. If any specific distribution
> > enables this option by default in their kernels, they can do this
> > too, don't think this is critical enough to patch the defconfig.

I guess, Guennadi, that this is questionable. Many people would base
their configs on the defconfig.

Also, the defconfig has many questionable settings for an embedded
platform like the Kurobox.

And it seems that there is something not quite right for these embedded
systems. Here is something that I get with a vanilla linkstation_defconfig:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

This gets me (with bootlogd enabled):

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Wed Dec 31 21:00:15 1969: Cannot access the Hardware Clock via any known method.
Wed Dec 31 21:00:15 1969: Use the --debug option to see the details of our search for an access method.
Wed Dec 31 21:00:15 1969: Unable to set System Clock to: Thu Jan 1 00:00:15 UTC 1970 ^[[33m(warning).^[[39;49m
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

I just saw that in the default config:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# CONFIG_PPC_CLOCK is not set
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Maybe this should be enabled? I can iterate once more to see if this
option would make any difference here.

> Just because users/distros can change it doesn't mean it's pointless
> to discuss what default is sane, and make changes if the current
> default isn't.

100% agreed again, Scott. To repeat myself here, I think that the
defconfig should show the users the best current practices.

> For security-related options it's usually best to default to the more
> secure state, especially since the option description talks about it
> being needed mainly for libc5 compatibility -- did libc5 ever even
> exist for powerpc?
> 
> The only reason it was turned on in the first place was likely the
> "default y", which in turn is there to avoid breaking old x86 distros.

I'm including both Paul and BenH here.


Regards, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
