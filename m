Return-Path: <linux-kernel-owner+w=401wt.eu-S1762164AbYASBL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762164AbYASBL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 20:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757309AbYASBLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 20:11:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60433 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454AbYASBLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 20:11:48 -0500
Date: Sat, 19 Jan 2008 02:15:06 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Andi Kleen <andi@firstfloor.org>, Chodorenko Michail <misha@one.by>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Celeron Core
Message-ID: <20080119011506.GA23798@one.firstfloor.org>
References: <3ed23423adebae08e8f75b6a6a7ce7ff@one.by> <p73prvyalfl.fsf@bingen.suse.de> <1200702477.25782.41.camel@cinder.waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1200702477.25782.41.camel@cinder.waste.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 06:27:57PM -0600, Matt Mackall wrote:
> 
> On Fri, 2008-01-18 at 22:11 +0100, Andi Kleen wrote:
> > Chodorenko Michail <misha@one.by> writes:
> > 
> > > I have a laptop "Extensa 5220", with the processor Celeron based on 'core'
> > > technology.
> > > There is ~ / arch/i386/kernel/cpu/cpufreq/p4-clockmod.c in the kernel
> > > source code
> > > but there's no line identification of my CPU for apply freqency change
> > > need to add a ID line 0х16
> > 
> > Note that driver will likely do clock throttling on your CPU.
> > Using that is usually a bad idea because it does not actually
> > safe power. It's only intended to let the CPU cool down in some situations.
> 
> Power consumption is more or less exactly equal to heat production
> (that's where the power goes, after all!), so either clock throttling
> DOES save power or it DOES NOT cool the CPU.

No actually the way it works on modern x86 CPUs is that the best
strategy for saving power is to do things quickly and then
idle longer. That means on anything that has reasonably
deep sleep modi e.g. on older server/desktop systems things might
be slightly different because they had very little power saving
features enabled, but it's definitely true for all
laptop systems from the last several years. But even
on desktop/server throttling tends to be a bad idea.

Intel style throttling makes the CPU skip cycles so the maximum built
up heat for a time unit is less, but it will run active for longer that 
makes it overall take more power for a given work unit.

Here's a better description from Dominik:

http://article.gmane.org/gmane.linux.kernel.cpufreq/3497

Note the conditions he describes are quite common. Also the OP
CPU likely has C2 and even deeper sleep modi.

Another problem with throttling / p4-clockmod is that on
at least some CPUs (not necessarily P-M, but we saw this on
some P4s) is that they can create quite long user visible
latencies. You might actually get "hanging mouse pointers" 
from it if you use it with an aggressive governour like ondemand.

The normal use case for Intel throttling is to just do 
an emergency cool down in case the CPU fails (down to thermal
shutdown). And that is done transparently behind Linux's back.

-Andi


