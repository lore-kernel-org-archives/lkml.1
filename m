Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbXL2JGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbXL2JGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 04:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXL2JGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 04:06:35 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38904 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbXL2JGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 04:06:34 -0500
Date: Sat, 29 Dec 2007 11:06:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: errandir_news@mph.eclipse.co.uk, m.kozlowski@tuxland.pl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1: some section mismatches on sparc64
Message-ID: <20071229090619.GB27360@does.not.exist>
References: <20071228232255.GB9105@does.not.exist> <20071229.001411.210630819.davem@davemloft.net> <20071229084846.GA27360@does.not.exist> <20071229.005408.76652528.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071229.005408.76652528.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 12:54:08AM -0800, David Miller wrote:
> From: Adrian Bunk <bunk@kernel.org>
> Date: Sat, 29 Dec 2007 10:48:46 +0200
> 
> > On Sat, Dec 29, 2007 at 12:14:11AM -0800, David Miller wrote:
> > > That's why I'm not worried about this issue and it's not critical at
> > > all.
> > 
> > If a module calls sunserial_console_match() that's an Oops.
> 
> That's true.
> 
> I'm trying to figure out a way to fix this.

#ifdef FOO_CONSOLE around the sunserial_console_match() calls in the  
drivers should work.

If you consider this too many #ifdef's, an alternative solution would be 
doing the following in drivers/serial/suncore.h:

#ifndef MODULE
extern int sunserial_console_match(struct console *, struct device_node *,
                                   struct uart_driver *, int);
#else
static inline int sunserial_console_match(struct console *, struct device_node *,
                                          struct uart_driver *, int);
{ return 0; }
#endif

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

