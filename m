Return-Path: <linux-kernel-owner+w=401wt.eu-S1765965AbYDPUwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765965AbYDPUwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 16:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765607AbYDPUwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 16:52:01 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33062 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765593AbYDPUwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 16:52:00 -0400
Date: Wed, 16 Apr 2008 22:52:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 and DEBUG_SECTION_MISMATCH
Message-ID: <20080416205230.GA4129@uranus.ravnborg.org>
References: <20080416175135.GN1677@cs181133002.pp.htv.fi> <20080416192306.GA3090@uranus.ravnborg.org> <20080416193102.GA16981@elte.hu> <20080416195504.GA2408@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416195504.GA2408@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 09:55:04PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Sam Ravnborg <sam@ravnborg.org> wrote:
> > 
> > > I would prefer we were down to less than 5 warnings so we could 
> > > enable it in kconfig but maybe after next merge window.
> > 
> > they get regenerated. More than 1 out of every 100 new patches. Quite 
> > expensive feature (in terms of maintenance overhead) for a rather 
> > theoretical memory saving benefit.
> 
> in v2.6.24 we had at least 200 section fixes:
> 
>   $ git-log v2.6.24.. | egrep -c 'WARNING:.*Section mismatch'
>   198
> 
> for 12671 commits - that's 1 section type fix for every 60 commits.
Please get your numbers right. What you count is the number of
Section mismatch warnings that has been fixed.
Sometime fixing up one line of code fixes >5 section mismatch warnings.

> and 90% of the problems could be reduced via the very simple patch below 
> ...
> 
> so ... why shouldnt we say that if someone wants to have this feature, 
> it should be done all automatically, in the link space. There's no 
> reason why the dependencies couldnt be figured out all automatically.

Or we could fix the blatant misuse of __cpuinit. If has
replaced a proper separation of code that is only relevant for
CPU hotplug and code that is used with and without CPUHOTPLUG.

I question that we have 580 functions that is used duing init in
normal cases and during CPU hotplug.

	Sam
