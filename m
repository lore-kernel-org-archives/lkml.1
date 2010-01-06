Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857Ab0AFKsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab0AFKsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 05:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932107Ab0AFKs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 05:48:27 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:59014 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab0AFKsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 05:48:25 -0500
Date: Wed, 6 Jan 2010 11:48:23 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Artem Bityutskiy <dedekind1@gmail.com>, Michal Marek <mmarek@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: sections mismatch detection
Message-ID: <20100106104823.GA30439@merkur.ravnborg.org>
References: <1262772683.4263.147.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262772683.4263.147.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 12:11:23PM +0200, Artem Bityutskiy wrote:
> Hi,
> 
> I wonder is it good time to enable DEBUG_SECTION_MISMATCH by default
> now? I mean, remove the following from lib/Kconfig.debug:
> 
> config DEBUG_SECTION_MISMATCH
>         bool "Enable full Section mismatch analysis"
>         depends on UNDEFINED
>         # This option is on purpose disabled for now.
>         # It will be enabled when we are down to a resonable number
>         # of section mismatch warnings (< 10 for an allyesconfig build)
> 
> Just spotted this, and decided to remind.

My original criteria for enabling this was that we had a warnign free build
for all*config on x86 and a few other architectures.
While focusing on this I never reached this goal as I usually ended
up with some problems related to CPU hotplug.
I dunno how close we are today at the "zero warning" target.

When people implemented CPU hotplug they started to use __cpuinit
not only for code used during init time but also for code used
solely for CPU hotplugging. That made it difficult to solve
all the corner cases.
Because __cpu* annotation was used outside the original scope
I suggested to remove them from the checks but alas got no response.
Running out of time I gave up.

But I can see a steady flow of section mismatch fixes so I think the
situation looks better these days.

As the kbuild maintainer traditionally has been a central person
in this respect (due to the functionality in modpost),
I would like Michal to support this if we decide to enable the option.

	Sam
