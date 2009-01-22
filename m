Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbZAVUDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbZAVUDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 15:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbZAVUDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 15:03:23 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41588 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321AbZAVUDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 15:03:23 -0500
Subject: Re: System clock runs too fast after 2.6.27 -> 2.6.28.1 upgrade
From: john stultz <johnstul@us.ibm.com>
To: Miklos Vajna <vmiklos@frugalware.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Gabriel C <nix.or.die@googlemail.com>,
       =?ISO-8859-1?Q?CS=C9CSY_L=E1szl=F3?= <boobaa@frugalware.org>
In-Reply-To: <20090122195132.GZ21473@genesis.frugalware.org>
References: <20090121171423.GI21473@genesis.frugalware.org>
	 <1f1b08da0901211200l88fa89s78a51c4e90878d85@mail.gmail.com>
	 <20090121210726.GK21473@genesis.frugalware.org>
	 <1232573646.6997.21.camel@localhost.localdomain>
	 <20090122195132.GZ21473@genesis.frugalware.org>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 12:03:14 -0800
Message-Id: <1232654594.6678.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-22 at 20:51 +0100, Miklos Vajna wrote:
> On Wed, Jan 21, 2009 at 01:34:06PM -0800, john stultz <johnstul@us.ibm.com> wrote:
> > Miklos: Can you try bisecting this down some?
> 
> I did it two times when I finally realised that it depends on the
> config. So currently I have two config files, with "-good" the clock is
> fine, with "-bad" it's too fast.

Could you send the same info I requested before (available_clocksources,
current_clocksource, dmesg) for both good and bad configs? Also make
sure they're on the same kernel version (as the configs are from
slightly different kernel versions).


> Of course the diff contains unrelated changes as well, I'm trying to
> find which one is the problematic one.

Bisecting the config difference is probably the most reliable way, but
you might try some shots in the dark first:

CONFIG_X86_VISWS: If I recall, this is support for SGI workstations that
had different apics then most systems, and might be related.

CONFIG_PARAVIRT_GUEST: I really haven't been paying much attention to
the paravirt bits, but this has some clock related subconfig options
that might be affecting it.

thanks
-john

