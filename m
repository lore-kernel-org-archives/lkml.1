Return-Path: <linux-kernel-owner+w=401wt.eu-S1759115AbZDOJfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115AbZDOJfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 05:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbZDOJfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 05:35:24 -0400
Received: from mailbox-us-s-12.mailhostingserver.com ([75.125.101.9]:58917
	"EHLO mailbox-us-s-12.mailhostingserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754985AbZDOJfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 05:35:23 -0400
Date: Wed, 15 Apr 2009 11:35:19 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Bill Gatliff <bgat@billgatliff.com>
Subject: Re: Linux 2.6.30-rc2: [PATCH] ARM OABI compatibility: fix build
	error
Message-ID: <20090415093519.GC12921@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Bill Gatliff <bgat@billgatliff.com>
References: <alpine.LFD.2.00.0904141628570.4132@localhost.localdomain> <20090415083326.GA12921@traven> <20090415090307.GH6058@n2100.arm.linux.org.uk> <20090415091223.GB12921@traven> <20090415092942.GJ6058@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415092942.GJ6058@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, Apr 15, 2009 at 10:29:42AM +0100 Russell King - ARM Linux ha dit:

> On Wed, Apr 15, 2009 at 11:12:23AM +0200, Matthias Kaehlcke wrote:
> > El Wed, Apr 15, 2009 at 10:03:07AM +0100 Russell King - ARM Linux ha dit:
> > 
> > > On Wed, Apr 15, 2009 at 10:33:26AM +0200, Matthias Kaehlcke wrote:
> > > > Building for ARM with CONFIG_OABI_COMPAT enabled fails due to a
> > > > missing include:
> > > 
> > > Yes, lots of people have been whinging about this over the last six days,
> > > but I'm only just catching up since returning from an Easter break.
> > > 
> > > Does anyone know /when/ this breakage happened, or even better what caused
> > > it?
> > 
> > a week ago i build v2.6.30-rc1 based on the same .config without
> > running into this issue. if i find some time i'll try bisecting it
> 
> Hmm, I think it's caused by 47788c58e66c050982241d9a05eb690daceb05a9.

you're right, bitsecting just pointed me to this commit
 
> The commit message looks rather interesting, including:
> 
>     arch/ia64/ia32/ia32priv.h:290:1: warning: "elf_check_arch" redefined
>     arch/ia64/include/asm/elf.h:19:1: warning: this is the location of the previous definition
> 
> surely the right answer is to only have _one_ definition of this thing,
> rather than two which may be different?  IOW, how do you know for certain
> which definition gets used where.
> 
> Not sure that I totally agree with the rationale in this commit, but I
> guess we have to live with it because it's x86.
> 
> Now, others have been putting out patches to solve the ARM build problem
> caused by the above commit, including one which includes linux/slab.h
> instead of linux/mm.h.  That seems to be a better fix than needlessly
> including lots of other stuff via linux/mm.h.  I notice that akpm picked
> up the linux/slab.h version yesterday.

i agree that linux/slab.h is preferable to linux/mm.h

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

                       El camino se hace al andar
                           (Antonio Machado)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
