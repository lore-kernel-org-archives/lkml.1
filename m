Return-Path: <linux-kernel-owner+w=401wt.eu-S1762295AbXGYKIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762295AbXGYKIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 06:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757185AbXGYKIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 06:08:12 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:49844 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698AbXGYKIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 06:08:10 -0400
Subject: Re: modpost warning question
From: chengong <g.chen@freescale.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       netdev@vger.kernel.org
In-Reply-To: <20070725072712.GB24093@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0707250210520.14366@blarg.am.freescale.net>
	 <20070725072712.GB24093@uranus.ravnborg.org>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 18:08:03 +0800
Message-Id: <1185358083.4996.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jul 2007 10:08:05.0632 (UTC) FILETIME=[B1806000:01C7CEA3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-25 at 09:27 +0200, Sam Ravnborg wrote:
> On Wed, Jul 25, 2007 at 02:14:12AM -0500, Kumar Gala wrote:
> > I'm seeing the following warning:
> > 
> > WARNING: vmlinux.o(.init.text+0x1acdc): Section mismatch: reference to
> > .exit.text:gfar_mdio_exit (between 'gfar_init' and 'gfar_mdio_init')
> > 
> > I don't understand why its not ok to access .exit.text from .init.text
> 
> Several architectures discards .exit.text in the final linker
> script (arch/$(ARCH)/kernel/vmlinux.lds.S
> 
> So any references to .exit.text will when a module is build-in result
> in a linker error because ld will flag it as an error when we reference
> a symbol in a discarded section.
But why? Just make kernel size smaller?
> 
> For the popular architectures (i386,x86_64) we discard .exit.text at
> runtime so here we do not see the error from ld (sadly).
>From which version? On my machine I have seen the same problem when
building i386 target with the version 2.6.21.
> 
> 	Sam
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

