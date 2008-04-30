Return-Path: <linux-kernel-owner+w=401wt.eu-S1765848AbYD3U5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765848AbYD3U5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbYD3U44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:56:56 -0400
Received: from linux-m68k.xs4all.nl ([82.95.193.92]:41249 "EHLO
	scrub.xs4all.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753848AbYD3U4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:56:55 -0400
Date: Wed, 30 Apr 2008 22:56:05 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch, -git] input: CONFIG_INPUT_APANEL build fix
In-Reply-To: <20080430202013.GB14164@elte.hu>
Message-ID: <Pine.LNX.4.64.0804302232060.30555@scrub.home>
References: <20080430185345.GA27224@elte.hu> <20080430150021.ZZRA012@mailhub.coreip.homeip.net>
 <20080430202013.GB14164@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 30 Apr 2008, Ingo Molnar wrote:

> > Thank you Ingo. Isn't this a Kconfig issue though? I know that Roman 
> > is not willing to fix SELECT to evaluate the whole dependency chain, 
> > but in this case it is "depens on" that does not evaluate properly...
> 
> yes and no. It can be fixed in Kconfig but i'm not going to flame yet 
> another person about long-existing unfixed infrastructure bugs ;-)

You don't have to, because this simply is no infrastructure bug...
Don't blame Kconfig for abusing select for something it was never 
intendend for. There is no bug!

In this case there is now a mixture of depends and selects on leds. First 
decide whether led support should be automatically included or the driver 
is only available when led support is enabled. In the first case it's 
probably better to create LEDS_SUPPORT, which then again selects 
everything necessary.

bye, Roman
