Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbYEaXpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbYEaXpH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 19:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbYEaXox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 19:44:53 -0400
Received: from 82-69-137-158.dsl.in-addr.zen.co.uk ([82.69.137.158]:37832 "EHLO
	uklogin.uk.level5networks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754904AbYEaXox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 19:44:53 -0400
Date: Sun, 1 Jun 2008 00:44:27 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] cputopology: Add default CPU topology information [3rd try]
Message-ID: <20080531234426.GE30769@solarflare.com>
References: <20080531214429.GQ1743@solarflare.com> <19f34abd0805311611x29b6a4aas572ee180ef7eb2c7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0805311611x29b6a4aas572ee180ef7eb2c7@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> On Sat, May 31, 2008 at 11:44 PM, Ben Hutchings
> <bhutchings@solarflare.com> wrote:
> > Define the macros topology_{physical_package,core}_id() and
> > topology_{thread,core}_siblings() in <asm-generic/topology.h> if they are not
> > already defined.
> >
> > Move inclusion of <asm-generic/topology.h> after definitions of these
> > macros in <asm-powerpc/topology.h> and <asm-x86/topology.h>.
> 
> Hi again :)
> 
> As I said in my previous e-mail, having #includes in the middle of
> headers is nasty. This kind of dependency is really subtle and makes
> later modification much harder. (Actually, it hurts readability as
> well.)

It is a bit nasty, but it seems to be reasonably common to include
<asm-generic/foo.h> toward the end of <asm-bar/foo.h>.  So I think
anyone working with an asm header should expect that.

> The standard way to do this seems to be:
> 
> asm/topology.h should define ARCH_HAS_* macros if it wishes to
> override the defaults
> linux/topology.h should #include asm/topology.h at the top of the file
> linux/topology.h should define the generic functions/macros only if
> the ARCH_HAS_* macros are undefined
> 
> Other files wishing to use these definitions should then include
> linux/topology.h.
> 
> Or is that unfeasible in this case?

It seem feasible, though there is no need for ARCH_HAS_* macros given that
the features being described are themselves macros.  I would be happy to
move the defaults to <linux/topology.h>.  Actually, everything in
<asm-generic/topology.h> could probably be moved to <linux/topology.h>.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
