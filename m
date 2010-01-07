Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996Ab0AGU5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab0AGU5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256Ab0AGU5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:57:31 -0500
Received: from isilmar.linta.de ([213.133.102.198]:34275 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753116Ab0AGU5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:57:30 -0500
Date: Thu, 7 Jan 2010 21:57:28 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kbuild@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Valdis.Kletnieks@vt.edu
Subject: Re: linux-next: Tree for January 7 (pcmcia)
Message-ID: <20100107205728.GA19115@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-kbuild@vger.kernel.org, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, Valdis.Kletnieks@vt.edu
References: <20100107172134.af71c742.sfr@canb.auug.org.au> <20100107101006.e59989a8.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100107101006.e59989a8.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, Jan 07, 2010 at 10:10:06AM -0800, Randy Dunlap wrote:
> > Hi all,
> > 
> > Changes since 20100106:
> 
> 
> drivers/built-in.o: In function `yenta_probe':
> yenta_socket.c:(.devinit.text+0x1e582): undefined reference to `pccard_nonstatic_ops'
> 
> CONFIG_PCCARD=y
> CONFIG_PCMCIA=m
> CONFIG_PCCARD_NONSTATIC=m
> CONFIG_YENTA=y
> 
> so yenta code (built-in) tries to reference data that lives in a
> loadable module.

Uh, that was I. If kconfig can't be fixed easily, I'll revert the change

>  But I would expect this Kconfig:
> 
> config YENTA
> 	tristate "CardBus yenta-compatible bridge support"
> 	depends on PCI
> 	select CARDBUS if !EMBEDDED
> 	select PCCARD_NONSTATIC if PCMCIA
> 
> to make PCCARD_NONSTATIC=y instead of =m.  Has something changed in
> kconfig recently that would make that different?

Best,
	Dominik
