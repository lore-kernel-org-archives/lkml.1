Return-Path: <linux-kernel-owner+w=401wt.eu-S1760483AbYENQEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760483AbYENQEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 12:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbYENQDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 12:03:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:65287 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYENQDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 12:03:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=EaRogo7SZlRn9sfrU3khrMjVnB+jmqiucTDAkDyNIkD6hZ0vDaMtU2Ov0KJXnfp7qroC+os7g2aq0Sjg16jT/6qOT/Ii3GtYt+e1cA4FY2YRs00jZKmR0A2odRqCam2meTcM4rWQa1W3eZfDrx7xIM7pcQQ56gQJInVWrfBhr7c=
Date: Wed, 14 May 2008 20:03:41 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andreas Schwab <schwab@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: main.c:(.init.text+0x730): undefined reference to
	`strlen'
Message-ID: <20080514160341.GH6902@cvg>
References: <Pine.LNX.4.64.0805140958400.5778@anakin> <jeprrpth5m.fsf@sykes.suse.de> <20080514141056.GB19909@cs181133002.pp.htv.fi> <jeabitt0xj.fsf@sykes.suse.de> <20080514153059.GA22115@cs181133002.pp.htv.fi> <20080514154801.GG6902@cvg> <20080514155611.GB22115@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514155611.GB22115@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adrian Bunk - Wed, May 14, 2008 at 06:56:11PM +0300]
| On Wed, May 14, 2008 at 07:48:01PM +0400, Cyrill Gorcunov wrote:
| > [Adrian Bunk - Wed, May 14, 2008 at 06:30:59PM +0300]
| > | On Wed, May 14, 2008 at 04:28:24PM +0200, Andreas Schwab wrote:
| > | > Adrian Bunk <bunk@kernel.org> writes:
| > | > 
| > | > > Or replace all the strlen stuff in include/asm-m68k/string.h with a 
| > | > 
| > | > I don't think the strlen macros has any influence in this case (it
| > | > already uses __builtin_strlen anyway).
| > | 
| > | The problem is that it sets __HAVE_ARCH_STRLEN, and therefore the 
| > | out-of-line function in lib/string.c is not built.
| > | 
| > | That breaks when gcc replaces a call to a different function with a call 
| > | to strlen().
| > | 
| > | > I'd rather guess that gcc is
| > | > expanding strncat internally to something involving strlen with
| > | > non-constant argument,
| > | 
| > | We agree on this one.
| > | 
| > | > although I cannot see how that can happen from a
| > | > quick look.
| > | 
| > | It isn't the first time we have these problems in the kernel...
| > | 
| > | > Andreas.
| > | 
| > | cu
| > | Adrian
| > 
| > Adrian, I've just sent the updated patch, and accidentally forget
| > to CC you - please take a look on http://lkml.org/lkml/2008/5/14/267
| 
| It removes the strncat() calls and should therefore remove the current 
| compile error.
| 
| But the underlying problem that actually causes the compile error is not 
| fixed and might occur again in other places (but that's nothing you 
| have to worry about).
| 
| > 		- Cyrill -
| 
| cu
| Adrian
| 
| -- 
| 
|        "Is there not promise of rain?" Ling Tan asked suddenly out
|         of the darkness. There had been need of rain for many days.
|        "Only a promise," Lao Er said.
|                                        Pearl S. Buck - Dragon Seed
| 

Yes, this problem is still here but I was really frowned 'cause
it's my patch introduced potential memory overflow :(

		- Cyrill -
