Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbYAFDFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbYAFDFR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 22:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYAFDEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 22:04:55 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38004 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189AbYAFDEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 22:04:54 -0500
Date: Sat, 5 Jan 2008 19:05:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: benh@kernel.crashing.org
Cc: "Robin H. Johnson" <robbat2@gentoo.org>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
Subject: Re: Idle loadavg of ~1, maybe MD related
Message-Id: <20080105190506.38dcf45e.akpm@linux-foundation.org>
In-Reply-To: <1199528332.7291.53.camel@pasglop>
References: <20071230100614.GX17327@curie-int.orbis-terrarum.net>
	<20080105013037.a354b33a.akpm@linux-foundation.org>
	<20080105100455.GB911@curie-int.orbis-terrarum.net>
	<1199528332.7291.53.camel@pasglop>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Jan 2008 21:18:52 +1100 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Sat, 2008-01-05 at 02:04 -0800, Robin H. Johnson wrote:
> > On Sat, Jan 05, 2008 at 01:30:37AM -0800, Andrew Morton wrote:
> > > >From that I'd suspect that kwindfarm is being a bad citizen.
> > > If a process is consistently stuck in D state, run
> > Windfarm.
> 
> It's an unfortunate artifact that kernel threads that do
> non-interruptible sleep are counted as load...
> 
> In the case of windfarm, it does a lot (a _LOT_) of accesses to various
> i2c busses and the SMU (the system management unit which controls the
> fans). All those are done in the form of short requests during which the
> process is doing a wait_for_completion() or similar.
> 
> I don't see a better way to do that, I think we could have good use of
> something that stops counting those in the load average...

Maybe, but we can usually work around it pretty comfortably.

If smu_set_fan() is only ever called by a kernel thread then we can simply
flip it over to using wait_for_completion_interruptible().

If smu_set_fan() is also called from user processes then things aren't so
easy...

