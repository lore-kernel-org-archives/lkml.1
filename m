Return-Path: <linux-kernel-owner+w=401wt.eu-S1762769AbYENOMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762769AbYENOMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762169AbYENOMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:12:34 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:35711 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbYENOMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:12:33 -0400
Date: Wed, 14 May 2008 17:10:56 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andreas Schwab <schwab@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: main.c:(.init.text+0x730): undefined reference to
	`strlen'
Message-ID: <20080514141056.GB19909@cs181133002.pp.htv.fi>
References: <Pine.LNX.4.64.0805140958400.5778@anakin> <jeprrpth5m.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <jeprrpth5m.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 10:37:57AM +0200, Andreas Schwab wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
> 
> > My first guess is gcc is turning sizeof() into strlen() again.
> 
> Definitely not.  sizeof is a compile-time constant, strlen is not.  More
> likely the strlen call is embedded in the expansion of strncat.

m68k is one of the architectures not using -ffreestanding, so this 
kind of problems is somehow expected...

We could add -ffreestanding on m68k.

Or replace all the strlen stuff in include/asm-m68k/string.h with a 
function prototype, which lets gcc choose itself whether it wants to use 
the builtin or the version from lib/string.c, and makes an out-of-line 
version of the function available for caes like the one we face here.

> Andreas.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

