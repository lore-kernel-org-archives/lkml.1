Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbYEDMQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbYEDMQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 08:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbYEDMQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 08:16:13 -0400
Received: from barikada.upol.cz ([158.194.242.200]:59510 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbYEDMQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 08:16:13 -0400
Date: Sun, 4 May 2008 14:37:10 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, Roman Zippel <zippel@linux-m68k.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kconfig - a suggestion how to fix the select issue
Message-ID: <20080504123710.GA24008@flower.upol.cz>
References: <20080504071041.GA15315@uranus.ravnborg.org> <20080504081145.GG5838@cs181133002.pp.htv.fi> <20080504082732.GB17276@uranus.ravnborg.org> <20080504090429.GH5838@cs181133002.pp.htv.fi> <20080504103848.GC17276@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080504103848.GC17276@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

> > Given:
> > - CONFIG_A=y
> > - CONFIG_B=n
> > - CONFIG_D=y
> > - CONFIG_E=n
> > 
> > Will C be visible?
> The above has a syntax error. A 'depends on' cannot have an
> if caluse.

would you please write logic rules with more neutral language, like

(A || B) && C

or similar. Depencies (forward or backward) can be described as

SYM_FOO <- { # depencies/value

  ($SYM_DEP1 || !$SYM_DEP2) && $SYM_DEP3=xx
  # implicit or
  $SYM_DEP4 || $SYM_DEP5

} -> { # selects

  SYM_2SELECT1 = $SYM_BAR ? foo_bar : bar_for
  SYM_2SELECT2 = bar; SYM_BA; SYM_ZZ

# SYM_BA && SYM_ZZ will have value of SYM_FOO
}

or something.

> And I did not get your point either.

I try to design TUI now for better multidimensional walking/selecting on
the web of symbols and decencies, and i don't get those kconfig
constructs.

> Are you trying to say that we cannot improve kconfig to better
> express the dependencies or what is your point?
> 
> Puzzeled...

Thanks.
____
