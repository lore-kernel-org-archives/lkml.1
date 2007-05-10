Return-Path: <linux-kernel-owner+w=401wt.eu-S1760230AbXEJI6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbXEJI6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756672AbXEJI55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:57:57 -0400
Received: from opal.biophys.uni-duesseldorf.de ([134.99.176.7]:51261 "EHLO
	opal.biophys.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756017AbXEJI55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:57:57 -0400
Date: Thu, 10 May 2007 10:57:35 +0200 (CEST)
From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Timur Tabi <timur@freescale.com>,
       Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
Subject: Re: select is evil: another reason
In-Reply-To: <20070509091358.GA29994@flint.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.58.0705101055570.9218@xplor.biophys.uni-duesseldorf.de>
References: <20070509091358.GA29994@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Russell King wrote:

> drivers/net/Kconfig:2279:warning: 'select' used by config symbol 'UCC_GETH' refers to undefined symbol 'UCC_FAST'
> drivers/input/keyboard/Kconfig:170:warning: 'select' used by config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
> drivers/input/mouse/Kconfig:161:warning: 'select' used by config symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
>
> The select statements are in generic Kconfig files.  The symbols they
> are selecting are in arch-private Kconfig files.  Don't do that -
> those symbols are undefined for other architectures.
>
> If you must do that then do:
>
>  config ATARI_KBD_CORE
>  	bool
> +	default y if KEYBOARD_ATARI || MOUSE_ATARI
>
> in our m68k Kconfig file, and in arch/powerpc/sysdev/qe_lib/Kconfig:

Will fix. Thanks for reporting this.

	Michael

