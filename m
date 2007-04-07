Return-Path: <linux-kernel-owner+w=401wt.eu-S1751260AbXDGJpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260AbXDGJpZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 05:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbXDGJpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 05:45:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47723 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbXDGJpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 05:45:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: tglx@linutronix.de
Subject: Re: [patch] high-res timers: UP resume fix
Date: Sat, 7 Apr 2007 11:48:42 +0200
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070407082554.GA1943@elte.hu> <1175935730.28263.510.camel@localhost.localdomain>
In-Reply-To: <1175935730.28263.510.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704071148.43136.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 7 April 2007 10:48, Thomas Gleixner wrote:
> On Sat, 2007-04-07 at 10:25 +0200, Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > [...] Soeren, can you confirm that you are using a !CONFIG_SMP kernel, 
> > > and if yes, does the patch below fix the resume problem for you?
> > 
> > hm, you seem to have a CONFIG_SMP=y kernel. I dont immediately see where 
> > we re-enable interrupts in the SMP case, but could you try my patch 
> > nevertheless
> 
> We do in on_each_cpu() unconditionally. I missed that.

BTW, the on_each_cpu() in clock_was_set() is unnecessary, because
timekeeping_resume() is always run on one CPU.

Greetings,
Rafael
