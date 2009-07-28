Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbZG1LVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbZG1LVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 07:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbZG1LVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 07:21:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40460 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbZG1LVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 07:21:41 -0400
Date: Tue, 28 Jul 2009 13:21:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, James Morris <jmorris@namei.org>,
       James Carter <jwcart2@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, Stephen Smalley <sds@tycho.nsa.gov>,
       spender@grsecurity.net, Daniel J Walsh <dwalsh@redhat.com>,
       cl@linux-foundation.org, Arjan van de Ven <arjan@infradead.org>,
       kees@outflux.net, Chad Sellers <csellers@tresys.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, mingo@elte.hu
Subject: Re: mmap_min_addr and your local LSM (ok, just SELinux)
Message-ID: <20090728112137.GF15310@basil.fritz.box>
References: <1248132223.2654.278.camel@localhost> <alpine.LRH.2.00.0907211258110.32400@tundra.namei.org> <1248187482.19456.90.camel@moss-lions.epoch.ncsc.mil> <alpine.LRH.2.00.0907221953190.15799@tundra.namei.org> <20090728011943.589176cb@lxorguk.ukuu.org.uk> <87zlapgo2u.fsf@basil.nowhere.org> <20090728110028.31fa9a6f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728110028.31fa9a6f@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 11:00:28AM +0100, Alan Cox wrote:
> On Tue, 28 Jul 2009 11:21:29 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> > 
> > > A dumb question perhaps, but while addling my brain over the tty layer I
> > > was wondering if for the specific case of jump through NULL (which seems
> > > to be the most common but by no means only problem case that gets
> > > exploited) is there any reason we can't set a default breakpoint for
> > 
> > You mean a hardware breakpoint? Hardware break points are a precious
> > scarce resource. The people who rely on them would be likely
> > unhappy if you take one way from them.
> 
> They are a tiny minority and could always turn such protection off.

"I don't use it so I don't care"

... in addition it doesn't help anyways because the x86 hardware
breakpoints can only trap an upto 4-8 bytes area. So if you set that
to 0 then a reference to >8(%reg),%reg==0 wouldn't trap.

That's a pretty common case with

	x->member

where offsetof(..,, member) >= 8 (or 4 on 32bit)

Was very likely even the case on the original exploit.

If you use all available break points (making all gdb users unhappy)
then you could still only cover 64 bytes on 64bit, 32 on 32bit.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
