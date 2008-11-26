Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbYKZDUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbYKZDUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 22:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbYKZDU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 22:20:29 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:38866 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbYKZDU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 22:20:27 -0500
Subject: Re: [RFC] Reentrant clock sources
From: john stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Magnus Damm <magnus.damm@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       lethal@linux-sh.org, mingo@redhat.com
In-Reply-To: <20081126030720.GC8242@elte.hu>
References: <20081125132823.8698.83248.sendpatchset@rx1.opensource.se>
	 <alpine.LFD.2.00.0811252215270.3235@localhost.localdomain>
	 <20081126030720.GC8242@elte.hu>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 19:20:24 -0800
Message-Id: <1227669624.6298.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-26 at 04:07 +0100, Ingo Molnar wrote:
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > > +	cycle_t (*vread)(struct clocksource *cs);
> > 
> > This is crap. vread can not access the clocksource.
> 
> i think 'reentrant' in the sense of creating self-sufficient driver 
> entities. vread wont (and shouldnt) call ->vread() recursively - but 
> it might want to access fields on the clocksource.

I think Thomas' issue is that vread() *cannot* access fields on the
clocksource (since vread has to be careful not to access any
non-vsyscall mapped memory).

However not all clocksources use vread(), but really I'm not quite clear
on what one would want to access in the clocksource structure when
making a ->read() call.

So maybe a further description of what specific need motivates this
change would be helpful? The brief description of power management
doesn't quite click in my head yet.

thanks
-john

