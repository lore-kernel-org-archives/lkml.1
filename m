Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbXKKNHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbXKKNHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 08:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbXKKNHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 08:07:39 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60088 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754227AbXKKNHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 08:07:38 -0500
Date: Sun, 11 Nov 2007 14:07:14 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kconfig: use $K64BIT to set 64BIT with all*config
	targets
Message-ID: <20071111130714.GN21669@stusta.de>
References: <20071110204038.GA13140@uranus.ravnborg.org> <11947274093185-git-send-email-sam@ravnborg.org> <11947274091127-git-send-email-sam@ravnborg.org> <3d8471ca0711101255m1647e27cm241f358cc49a9921@mail.gmail.com> <20071111051408.GC21669@stusta.de> <3d8471ca0711110443v46084714m709b2b713a536b19@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3d8471ca0711110443v46084714m709b2b713a536b19@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2007 at 01:43:28PM +0100, Guillaume Chazarain wrote:
> Hi Adrian,

Hi Guillaume,

> On 11/11/07, Adrian Bunk <bunk@kernel.org> wrote:
> > What exactly are the use cases where someone would need this?
> 
> Glad you asked. Today, when I want to recompile a kernel while
> changing a CONFIG_ option, I manually edit the .config,
> remove the appropriate line and then run make oldconfig.
> I'd like to be able to do: make oldconfig CONFIG_FOO=bar.

first of all it's obvious that there can't be any guarantee that your 
CONFIG_FOO variable will actually get the value bar since dependencies 
might enable or disable it despite you wanting the opposite.

Another important point is that users that know about and see CONFIG_* 
variables are kernel hackers, not the normal kconfig users.

> Also, when working on a specific feature of the kernel, I tend to
> install both a kernel with the CONFIG_ option set and one with
> the option unset. Scripts to do that can twiddle the .config file,
> but it would be more convenient if kbuild could avoid that.

I'm wondering why you don't use two different O= output directories 
instead?

Depending on the CONFIG_ option in question this might even greatly 
reduce your compile times.

And you won't upgrade the kernel you work against that
often compared to working on and testing of your own changes when 
developing code.

> As you see, I'm more interested in make oldconfig than
> make all*config.

That's clear.

> Cheers.
> Guillaume

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

