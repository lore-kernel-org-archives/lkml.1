Return-Path: <linux-kernel-owner+w=401wt.eu-S932957AbYDPQsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957AbYDPQsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 12:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759747AbYDPQr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 12:47:58 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:38691 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760091AbYDPQr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 12:47:57 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Oliver Neukum <oliver@neukum.org>, Ingo Oeser <ioe-lkml@rameria.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Bart Van Assche <bart.vanassche@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace completions with semaphores
References: <4803AD91.5020001@firstfloor.org>
	<200804161831.10510.oliver@neukum.org>
	<20080416163413.GL9191@parisc-linux.org>
	<200804161842.52739.oliver@neukum.org>
	<20080416164404.GM9191@parisc-linux.org>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 16 Apr 2008 09:47:55 -0700
In-Reply-To: <20080416164404.GM9191@parisc-linux.org> (Matthew Wilcox's
	message of "Wed, 16 Apr 2008 10:44:04 -0600")
Message-ID: <adafxtllpac.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Apr 2008 16:47:55.0889 (UTC) FILETIME=[9EB09610:01C89FE1]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > The cookies aren't checked by the kcounter implementation if
 > CONFIG_DEBUG_KCOUNTER isn't set.  So you can avoid storing them if it's
 > *really* that important to shrink your data structures.

I guess if anyone cared we could have something analogous to
DECLARE_PCI_UNMAP_ADDR() et al that compiles to nothing if
CONFIG_DEBUG_KCOUNTER isn't set.  But I'm not sure it's worth it.
Certainly for the mthca/mlx4 cases of semaphore use there's no problem
holding onto a cookie.

 - R.
