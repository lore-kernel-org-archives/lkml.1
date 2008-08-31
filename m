Return-Path: <linux-kernel-owner+w=401wt.eu-S1758465AbYHaUIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465AbYHaUIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 16:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482AbYHaUIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 16:08:37 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42929 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYHaUIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 16:08:36 -0400
Date: Sun, 31 Aug 2008 13:08:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, jes@sgi.com,
       manfred@colorfullife.com, akpm@linux-foundation.org
Subject: Re: [PATCH] prevent ia64 from invoking irq handlers on offline CPUs
Message-ID: <20080831200833.GJ7015@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080831172814.GA15087@linux.vnet.ibm.com> <19f34abd0808311046g47907414wf3ef939d0a7bbfdb@mail.gmail.com> <20080831175100.GD7015@linux.vnet.ibm.com> <19f34abd0808311053m2fbaa711j5bfc846d81cf34b4@mail.gmail.com> <20080831180630.GF7015@linux.vnet.ibm.com> <19f34abd0808311208v4caa9bdbhaac6ca5177c1994a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808311208v4caa9bdbhaac6ca5177c1994a@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 09:08:34PM +0200, Vegard Nossum wrote:
> On Sun, Aug 31, 2008 at 8:06 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Sun, Aug 31, 2008 at 07:53:32PM +0200, Vegard Nossum wrote:
> >> On Sun, Aug 31, 2008 at 7:51 PM, Paul E. McKenney
> >> <paulmck@linux.vnet.ibm.com> wrote:
> >> >> > @@ -751,6 +749,7 @@ int __cpu_disable(void)
> >> >> >        remove_siblinginfo(cpu);
> >> >> >        cpu_clear(cpu, cpu_online_map);
> >>
> >> Here ^^^
> >>
> >> >> >        fixup_irqs();
> >> >> > +       cpu_clear(cpu, cpu_online_map);
> >> >> >        local_flush_tlb_all();
> >> >> >        cpu_clear(cpu, cpu_callin_map);
> >> >> >        return 0;
> >> >>
> >> >> Hm. Maybe my eyes are going bad. But isn't that now clearing the cpu
> >> >> both before and after calling fixup_irqs()?
> >> >
> >> > I don't believe so...  I removed the earlier one and added the later
> >> > one.  Or is there another one hidden somewhere that I missed?
> >>
> >> See marker above. It's not removed, is it?
> >
> > Right you are!!!  There were two to begin with, and I moved the first
> > one only.  The attached updated patch removes the extra one.
> 
> Good, I am not blind yet! (Though I did have to look more than once.)
> 
> On the other hand... Paul; human after all!

Very much so, I am afraid!  ;-)

							Thanx, Paul
