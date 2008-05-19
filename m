Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbYESEAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbYESEAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 00:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbYESEAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 00:00:48 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:18226 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbYESEAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 00:00:47 -0400
X-IronPort-AV: E=Sophos;i="4.27,506,1204531200"; 
   d="scan'208";a="27653188"
From: Roland Dreier <rdreier@cisco.com>
To: corbet@lwn.net (Jonathan Corbet)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH, RFC] Char dev BKL pushdown v2
References: <19845.1211148908@vena.lwn.net>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 18 May 2008 21:00:45 -0700
In-Reply-To: <19845.1211148908@vena.lwn.net> (Jonathan Corbet's message of
	"Sun, 18 May 2008 16:15:08 -0600")
Message-ID: <adatzgv7xjm.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 May 2008 04:00:46.0322 (UTC) FILETIME=[EA8FCD20:01C8B964]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Great work, Jon!  It's really cool to see some real momentum towards
getting rid of the BKL at last.

 >  drivers/infiniband/core/ucm.c                |    2 +
 >  drivers/infiniband/core/user_mad.c           |    7 ++++
 >  drivers/infiniband/core/uverbs_main.c        |    9 ++++--
 >  drivers/infiniband/hw/ipath/ipath_file_ops.c |    2 +

All of these changes look fine from a pure "push the BKL down" point of
view.  However I am 99% sure no BKL use is required in any of these (and
I will think deeper to get another .9% surer tomorrow).

Is the plan that we have a pure "push the BKL down" changeset merged,
and then I can merge BKL removal patches for these places that never
needed the BKL?  (I guess I can send you such a patch to base on top of
your tree for when Linus pulls it?  Is 2.6.27 the plan?)  The
alternative is to never add the BKL to these places as part of this
patch -- which seems to be a bad, risky plan, since if any mistakes are
made, then bisection just lands on some giant patch.

Thanks,
  Roland
