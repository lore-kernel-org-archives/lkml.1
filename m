Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbZGVNEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbZGVNEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbZGVNEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:04:04 -0400
Received: from www.tglx.de ([62.245.132.106]:55269 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592AbZGVNED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:04:03 -0400
Date: Wed, 22 Jul 2009 15:03:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Kacur <jkacur@redhat.com>
cc: rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <williams@redhat.com>, Dave Airlie <airlied@linux.ie>
Subject: Re: i915_driver_irq_handler - BUG: NULL pointer dereference
In-Reply-To: <20090722084424.GA3507@tycho.redhat.com>
Message-ID: <alpine.LFD.2.00.0907221500160.2813@localhost.localdomain>
References: <20090722084424.GA3507@tycho.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 22 Jul 2009, John Kacur wrote:

> Hello Thomas et al
> 
> I'm still seeing this sometimes, in this case during shutdown with the experimental rt kernel
> based off of 2.6.31-rc3
> 
> The system is going down for reboot NOW!
> Disabling monthly Smolt update: [  OK  ]
> Shutting down Avahi daemon: [drm:gm45_get_vblank_counter] *ERROR* trying to get1
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000084
> IP: [<ffffffffa05df8ef>] i915_driver_irq_handler+0x848/0x8e9 [i915]

So it crashes in the i915 interrupt handler. Smells like a
synchronization problem on shutdown which is exposed by the threaded
handler.

Dave, any idea ?

Thanks,

	tglx
