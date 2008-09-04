Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbYIDSuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbYIDSuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758837AbYIDSoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:44:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41775 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758832AbYIDSoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:44:07 -0400
Date: Thu, 4 Sep 2008 20:47:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Prarit Bhargava <prarit@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       arozansk@redhat.com, Thomas.Mingarelli@hp.com, ak@linux.intel.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
Message-ID: <20080904184720.GI18288@one.firstfloor.org>
References: <20080904130048.31841.3329.sendpatchset@prarit.bos.redhat.com> <1220535463.8609.223.camel@twins> <48BFF0C0.7060208@redhat.com> <20080904145617.GB28095@elte.hu> <87y727vrgu.fsf@basil.nowhere.org> <20080904172052.GN3400@redhat.com> <20080904175231.GH18288@one.firstfloor.org> <20080904182637.GP3400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904182637.GP3400@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 02:26:37PM -0400, Don Zickus wrote:
> On Thu, Sep 04, 2008 at 07:52:31PM +0200, Andi Kleen wrote:
> > On Thu, Sep 04, 2008 at 01:20:52PM -0400, Don Zickus wrote:
> > > On Thu, Sep 04, 2008 at 05:52:17PM +0200, Andi Kleen wrote:
> > > > Then if there's a chipset specific NMI driver it could
> > > > also check if the chipset raised it. That would be a possible
> > > > solution for HP -- they would need to implement such a driver
> > > > for their systems with the special watchdog.
> > > 
> > > The thing with HP's special watchdog timer is that it does _not_ have a
> > > chipset specific NMI it is trying to catch.  HP is going on the assumption
> > > that _all_ NMIs are /bad/ and they want to catch _every_ NMI, log it, and
> > > reboot the system.
> > 
> > That's my point. If you have drivers which can identify all other
> > NMIs then the left over NMIs must come from that watchdog driver.
> > So they just need drivers which can do that for their chipsets.
> 
> Except their chipsets are _not_ producing NMIs.  They just want to

They will produce NMIs when the suitable error conditions are true.
That is why the fallback is assuming a chipset problem.

So the only reliable way to find out if the event really came from
the misdesigned watchdog (whoever designed it didn't understand
NMIs I would say) you have to check the chipset (and all other
sources). Hopefully they are all better designed and can
actually tell you if they triggered or not.

Also there's the issue that sometimes people want
the fallback to be the NMI button.

> > It's not race free, but that's simply not possible with the x86
> > NMI architecture.
> 
> I agree.
> 
> > 
> > Better would be probably to just configure the watchdog 
> > to reboot the system directly on its own. Most other watchdogs
> > I'm aware of do that. That's more reliable anyways because the system
> > might be wedged enough to not be able to process NMIs anymore.
> 
> The trick is they want to log it in a special way (BIOS or NVRAM or
> something I forget) before rebooting.

Then why tell the OS? It should be an SMI then.


-Andi
-- 
ak@linux.intel.com
