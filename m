Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbYADPvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbYADPvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 10:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbYADPvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 10:51:35 -0500
Received: from lixom.net ([66.141.50.11]:36081 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbYADPvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:51:35 -0500
Date: Fri, 4 Jan 2008 10:00:15 -0600
From: Olof Johansson <olof@lixom.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mpm@selenic.com, paulus@samba.org
Subject: Re: [patch 1/2] move WARN_ON() out of line
Message-ID: <20080104160015.GA29770@lixom.net>
References: <477D52ED.7000403@linux.intel.com> <20080104074149.GC17447@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104074149.GC17447@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 08:41:49AM +0100, Ingo Molnar wrote:
> 
> * Arjan van de Ven <arjan@linux.intel.com> wrote:
> 
> > This patch build on top of Olof's patch that introduces __WARN, and 
> > places the slowpath out of line. It also uses Ingo's suggestion to not 
> > use __FUNCTION__ but to use kallsyms to do the lookup; this saves a 
> > ton of extra space since gcc doesn't need to store the function string 
> > twice now:
> >
> > 3936367  833603  624736 5394706  525112 vmlinux.before
> > 3917508  833603  624736 5375847  520767 vmlinux-slowpath
> >
> > 15Kb savings...
> 
> hey, cool!
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> i'm wondering how we could put this into x86.git to get it tested some 
> more. Olof's patch touches other architectures so it's not really 
> appropriate. Maybe a portion of Olof's patch could be applied to make 
> your patch apply cleanly?

My base patch only touches other architectures to remove the no longer
needed HAVE_ARCH_BUG. Given the new ifdef in bug.h, there's nothing
functional that breaks if they're left in (i.e. split up in two
patches).

The only problem with merging it up the x86 path is that the powerpc
patch that builds on it would need to be ordered after the x86 merge
(in mm etc), or it'll cause build breaks. Keeping it in -mm is nice in
that way since Andrew could sequence them right when sending to Linus.

Easiest of all might be to get an Acked-by from Paul on the powerpc patch,
and merge it all up through x86.git?

(Paul: This is powerpc-switch-to-generic-warn_on-bug_on.patch in -mm
I'm talking about).


-Olof

