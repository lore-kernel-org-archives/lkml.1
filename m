Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYAFLY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYAFLY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 06:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYAFLYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 06:24:49 -0500
Received: from ozlabs.org ([203.10.76.45]:45022 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbYAFLYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 06:24:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18304.47573.556627.975776@cargo.ozlabs.ibm.com>
Date: Sun, 6 Jan 2008 22:21:57 +1100
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: benh@kernel.crashing.org, "Robin H. Johnson" <robbat2@gentoo.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Idle loadavg of ~1, maybe MD related
In-Reply-To: <20080105190506.38dcf45e.akpm@linux-foundation.org>
References: <20071230100614.GX17327@curie-int.orbis-terrarum.net>
	<20080105013037.a354b33a.akpm@linux-foundation.org>
	<20080105100455.GB911@curie-int.orbis-terrarum.net>
	<1199528332.7291.53.camel@pasglop>
	<20080105190506.38dcf45e.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> Maybe, but we can usually work around it pretty comfortably.
> 
> If smu_set_fan() is only ever called by a kernel thread then we can simply
> flip it over to using wait_for_completion_interruptible().
> 
> If smu_set_fan() is also called from user processes then things aren't so
> easy...

I believe most of the time spent waiting is actually spent inside the
i2c layer in uninterruptible sleeps.

Robin, what does the "motherboard" line in /proc/cpuinfo say on your
machine?

Paul.
