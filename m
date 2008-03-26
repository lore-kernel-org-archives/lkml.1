Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbYCZLMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbYCZLMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbYCZLMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:12:09 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:34707 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbYCZLMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:12:08 -0400
Date: Wed, 26 Mar 2008 14:12:04 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Meyer <thomas@m3y3r.de>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
	regressions from 2.6.24)
Message-ID: <20080326111204.GB9060@jurassic.park.msu.ru>
References: <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org> <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org> <47E807EE.2030902@m3y3r.de> <47E8217C.9080400@s5r6.in-berlin.de> <20080325073117.GA8469@elte.hu> <20080325165007.GA7775@elte.hu> <47E94557.4030001@m3y3r.de> <20080325201125.GD15330@elte.hu> <20080325202954.GA22007@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325202954.GA22007@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 09:29:54PM +0100, Ingo Molnar wrote:
> OTOH, before this system worked for you before, i start to suspect that 
> ioremap is a red herring here and that it's the code that gets to that 
> physical address (which is ioremap-ed) is at fault here.
> 
> the hard hang might be your southbridge totally dumbfounded by the host 
> OS attempting to do an MMIO access to an above-4GB address?

The Intel 94x chipsets must be OK wrt >4Gb MMIO accesses, as far as I know.
You should just get all 1s on read of non-existent MMIO address, as usual.
Not a hard hang.

So I suspect something is still broken in 64-bit ioremap... It would be nice
to sort that out, even though it seems to be unrelated to this particular
problem.

Ivan.
