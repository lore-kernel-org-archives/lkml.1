Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbYBAPBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbYBAPBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbYBAPBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:01:04 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40784 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753494AbYBAPBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:01:03 -0500
Subject: Re: Are Section mismatches out of control?
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>
In-Reply-To: <20080201030329.9b760777.akpm@linux-foundation.org>
References: <20080201104718.GA11717@uranus.ravnborg.org>
	 <20080201030329.9b760777.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 09:00:59 -0600
Message-Id: <1201878059.3134.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-01 at 03:03 -0800, Andrew Morton wrote:
> On Fri, 1 Feb 2008 11:47:18 +0100 Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > James said in a related posting that the Section mismatch
> > warnings were getting out of control.
> 
> eh.  They're easy - the build system tells you about them!
> 
> > The list is here:
> 
> Question is: why do people keep adding new ones when they are so easy to
> detect and fix?
> 
> Asnwer: because neither they nor their patch integrators are doing adequate
> compilation testing.

That's because certain configurations, where this shows up, like !
CONFIG_HOTPLUG or !CONFIG_HOTPLUG_CPU simply aren't anything other than
extremely weird configs for most modern HW and distributions.

I'm not saying we can't fix the problem with tools or that we can't
invest huge amounts of time patching and fixing this.  I am saying we
should be questioning the value of the investment in doing so.

I also claim that getting rid of the __dev.* sectional attributes (for
which I've already submitted a small patch) fixes 90% of the problems
(since they're mainly caused by driver writers not understanding what
all of these things mean).  The remaining ones are clearer and
additionally, show up on every build (whether HOTPLUG or not).

Before we start to pillory driver writers for not caring about configs
they rightly don't give a toss about, could we at least get someone
(anyone!) in the community that cares about extreme low memory
configurations to give us reasons why there's value to all this effort
(rather than spending it on say reducing cache footprints or eliminating
space in structures)?  All the people I've asked so far (mainly in arm,
admittedly) have said they have bigger things to worry about.

James


