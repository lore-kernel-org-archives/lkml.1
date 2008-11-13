Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbYKMDro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbYKMDro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 22:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYKMDrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 22:47:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44037 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbYKMDrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 22:47:35 -0500
Subject: Re: [PATCH] x86 - Make CONFIG_OLPC dependent on CONFIG_MGEODE_LX
From: Jeremy Katz <katzj@redhat.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andres Salomon <dilinger@queued.net>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jordan Crouse <jordan.crouse@amd.com>, linux-kernel@vger.kernel.org,
       dsaxena@laptop.org
In-Reply-To: <s5hbpwlj9w1.wl%tiwai@suse.de>
References: <s5h3ahyqwmn.wl%tiwai@suse.de> <20081111125402.GB14989@elte.hu>
	 <s5hzlk6pea6.wl%tiwai@suse.de> <20081111135306.GA32709@elte.hu>
	 <s5hwsfapdoj.wl%tiwai@suse.de> <20081111140406.GA3244@elte.hu>
	 <20081109201710.4c490f04@debxo> <1226498050.12791.45.camel@aglarond.local>
	 <s5hbpwlj9w1.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Wed, 12 Nov 2008 22:44:58 -0500
Message-Id: <1226547898.13077.83.camel@aglarond.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-12 at 15:29 +0100, Takashi Iwai wrote:
> At Wed, 12 Nov 2008 08:54:10 -0500, Jeremy Katz wrote:
> > It's not about angering, it's about causing regressions in
> > functionality.  Doing this will completely break the ability to run
> > generic distros on the OLPC hardware without a special kernel.  Which
> > has been something that a lot of work has gone on upstream to avoid for
> > all sorts of cases (VMI, Xen, SMP, ...).  
> 
> But, it is broken.  The asm/olpc includes asm/geode.h and it refers
> geode_gpio*() there.

The geode_gpio() users in asm/olpc.h are for some defines that really
probably don't belong there and which aren't used elsewhere in the main
tree afaict from a quick grep.  I'd be glad to send the patch to remove
it :-)

> > > but what we really need to
> > > do is to make geode_gpio* defined even when we're not specifically
> > > building with MGEODE_LX.  I'm not sure how best to do that, but the
> > > answer probably includes using the generic x86 gpio api.
> > 
> > This probably needs to be done as a precondition for getting the alsa
> > changes merged or the alsa changes need to have the bits which depend on
> > geode_gpio ripped out until it can be done.
> 
> Then let's stop inclusion of asm/geode.h from asm/olpc.h at first.
> Any driver codes including asm/geode.h can be broken potentially
> without a proper dependency.

Yes, but having a driver dependent on building for a specific x86
variant is quite wrong.  What would people think about a driver which
was dependent on CONFIG_M586?  Keep in mind that CONFIG_M686 wouldn't
then apply...

Jeremy

