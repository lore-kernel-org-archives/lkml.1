Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbYEFEeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbYEFEeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 00:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbYEFEeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 00:34:07 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:44135 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbYEFEeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 00:34:06 -0400
Date: Tue, 6 May 2008 06:34:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kconfig: introduce K= support
Message-ID: <20080506043439.GA13366@uranus.ravnborg.org>
References: <20080502204729.GA6534@uranus.ravnborg.org> <20080504185737.GA23063@uranus.ravnborg.org> <20080504185918.GB23063@uranus.ravnborg.org> <Pine.LNX.4.64.0805060438220.30555@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805060438220.30555@scrub.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 04:55:55AM +0200, Roman Zippel wrote:
> Hi,
> 
> On Sun, 4 May 2008, Sam Ravnborg wrote:
> 
> Below is patch which adds a library function to set the default values in 
> a much simpler way.
> The behaviour is slightly different, now it's closer to generating a 
> .config with all possible symbols set to some value and using that to 
> generate the final config. It has the advantage of not being as dependend 
> on the order of the symbols, e.g. with allmodconfig this sets a few more 
> symbols to 'm'.

Thanks. I will rework the patch to use this function.

> 
> > +# An arch may use KBUILD_DEFCONFIG to specify defconfig file
> > +# fallback to arch/$ARCH/defconfig
> > +defconfig-file := $(if $(KBUILD_DEFCONFIG),            \
> > +        arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG),   \
> > +        arch/$(SRCARCH)/defconfig)
> > +defconfig-file := $(strip $(defconfig-file))
> 
> init/Kconfig has a DEFCONFIG_LIST which is intended to be used for this.

The plan is to drop arch/$(SRCARCH)/defconfig and solely rely
on KBUILD_DEFCONFIG.
And I see KBUILD_DEFCONFIG thus for a "make defconfig" the
DEFCONFIG_LIST becomes unused.

But I guess your point is that we should dropt KBUILD_DEFCONFIG
entirely and rely on DEFCONFIG_LIST instead.

I will try it out.

> 
> > +	if (ac < 2) {
> > +		usage();
> > +		exit(1);
> > +	}
> > +	if (strcmp(av[1], "allnoconfig") == 0)
> > +		default_value = set_no;
> > +	else if (strcmp(av[1], "allyesconfig") == 0)
> > +		default_value = set_yes;
> > +	else if (strcmp(av[1], "allmodconfig") == 0)
> > +		default_value = set_mod;
> > +	else if (strcmp(av[1], "alldefconfig") == 0)
> > +		default_value = set_default;
> > +	else if (strcmp(av[1], "randconfig") == 0) {
> > +		default_value = set_random;
> > +		srand(time(NULL));
> > +	} else {
> > +		usage();
> > +		exit(1);
> > +	}
> > +	if (strcmp(av[2], "-b") == 0) {
> > +		config_file = av[3];
> > +		kconfig_file = av[4];
> > +	} else {
> > +		kconfig_file = av[2];
> > +	}
> 
> Even if it has only a single option, please keep using getopt().

OK.

Thanks for your feedback.
PS. I will post the updated patches in the weekend. Not that they
are difficult but I'm on the way out of the door for a few days
travelling.

	Sam
