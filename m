Return-Path: <linux-kernel-owner+w=401wt.eu-S1765033AbXGYH03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765033AbXGYH03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764378AbXGYHZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:25:59 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53124 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763196AbXGYHZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:25:58 -0400
Date: Wed, 25 Jul 2007 09:27:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Andy Fleming <afleming@freescale.com>, Jeff Garzik <jeff@garzik.org>,
       netdev@vger.kernel.org
Subject: Re: modpost warning question
Message-ID: <20070725072712.GB24093@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0707250210520.14366@blarg.am.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707250210520.14366@blarg.am.freescale.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 02:14:12AM -0500, Kumar Gala wrote:
> I'm seeing the following warning:
> 
> WARNING: vmlinux.o(.init.text+0x1acdc): Section mismatch: reference to
> .exit.text:gfar_mdio_exit (between 'gfar_init' and 'gfar_mdio_init')
> 
> I don't understand why its not ok to access .exit.text from .init.text

Several architectures discards .exit.text in the final linker
script (arch/$(ARCH)/kernel/vmlinux.lds.S

So any references to .exit.text will when a module is build-in result
in a linker error because ld will flag it as an error when we reference
a symbol in a discarded section.

For the popular architectures (i386,x86_64) we discard .exit.text at
runtime so here we do not see the error from ld (sadly).

	Sam
