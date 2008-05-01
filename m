Return-Path: <linux-kernel-owner+w=401wt.eu-S1759128AbYEACih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbYEACih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbYEACi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:38:27 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:37556 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbYEACi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=dmLFMXEJgWhAKZSr6hNl6pZVFcBi9nzwlqgy73Ak+1r9iiDWMCPOnfGUvUoe+kTqGxSbaZzSdsPTTlXCpa6Px4Dhkw7R9jqJxj55lmqF/EfY1y4BnBbaJ0ptoZidn4H//9n5vsay/t0mHi60HHq4Vo2w4K8dLqZo4C3L9/RKuGQ=
Date: Wed, 30 Apr 2008 22:36:42 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jan Engelhardt <jengelh@gmx.de>, Richard Purdie <rpurdie@rpsys.net>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch, -git] input: CONFIG_INPUT_APANEL build fix
Message-ID: <20080501023642.GA7063@anvil.corenet.prv>
References: <20080430185345.GA27224@elte.hu> <20080430150021.ZZRA012@mailhub.coreip.homeip.net> <20080430202013.GB14164@elte.hu> <20080430163924.ZZRA012@mailhub.coreip.homeip.net> <20080430212029.GA28813@elte.hu> <20080430222645.GB2629@anvil.corenet.prv> <20080430223828.GA31878@elte.hu> <20080430224701.GC2629@anvil.corenet.prv> <Pine.LNX.4.64.0805010213530.30555@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805010213530.30555@scrub.home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roman,

On Thu, May 01, 2008 at 02:51:47AM +0200, Roman Zippel wrote:
> Hi,
> 
> On Wed, 30 Apr 2008, Dmitry Torokhov wrote:
> 
> > You still did not answer to the main question - do you think we should
> > revert the commit that actually introduced breakage in the sense that
> > anything depending on LEDS_CLASS should also add NEW_LEDS dependancy?
> > That will take care of the problem (as far as LEDs are concerned) for
> > _all_ subsystems and drivers at once.
> 
> Well, that would mean reverting the complete led subsystem, since the 
> menuconfig patch you pointed at, isn't really the problem (did you 
> actually try to revert that patch?).
> 

Yes, I did. The revert fixed the apanel driver which does not select
but rather "depends on" LEDS_CLASS for me.

> Anyway, the actual issue are all the drivers that select LEDS_CLASS
> without selecting NEW_LEDS.
>

This is a different issue from the original reported one.
 
> The patch below fixes the dependency problem without adding a lot of new 
> selects by using LEDS_CORE, which is selected by LEDS_CLASS/LEDS_TRIGGERS 
> as needed.
> I removed the comments as they were a little redundant and I removed the 
> selects of NEW_LEDS as these are not needed anymore.
> 
> Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
> 

The patch appears to fix both problems at once (select and depends on + if),
I like it. Could we please have it applied to mainline, please?

BTW, does this mean that all 'if'-guarded symbols should be converted to
this style?

-- 
Dmitry
