Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbXKRAfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbXKRAfa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 19:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbXKRAfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 19:35:21 -0500
Received: from gw.goop.org ([64.81.55.164]:46650 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbXKRAfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 19:35:21 -0500
Message-ID: <473F88B0.1030309@goop.org>
Date: Sat, 17 Nov 2007 16:34:56 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: David <david@unsolicited.net>, Ingo Molnar <mingo@elte.hu>, gregkh@suse.de,
       Javier Kohen <jkohen@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Soft lockups since stable kernel upgrade to 2.6.23.8
References: <1195323695.5240.16.camel@null.tough.com.ar> <20071117191211.GA12757@kroah.com> <473F498D.9090703@unsolicited.net> <20071117203705.GA21045@kroah.com>
In-Reply-To: <20071117203705.GA21045@kroah.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Great, thanks for tracking this down.
>
> Ingo, this corrisponds to changeset
> a115d5caca1a2905ba7a32b408a6042b20179aaa in mainline.  Is that patch
> incorrect?  Should this patch in the -stable tree be reverted?
>   

Hm, I've never observed a problem with this in mainline. 

Ah.  The significant difference between 2.6.23 and -git is that the
former used sched_clock as the softlockup timebase, versus cpu_clock in
git.  If sched_clock() is tsc-based, and the tsc isn't stable when using
cpufreq, then the softlockup with get confused and fire spuriously. 
Ingo's fix to reporting exposed the fact that softlockup is terminally
broken in that kernel.

I think the best course for now is to revert it, since softlockup is
hardly a critical feature.  The proper fixes would either be to backport
cpu_clock() to 2.6.23, or make it go back to using ticks.

    J
