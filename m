Return-Path: <linux-kernel-owner+w=401wt.eu-S1751286AbXCUKC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286AbXCUKC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 06:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbXCUKC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 06:02:58 -0400
Received: from www.osadl.org ([213.239.205.134]:36291 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751286AbXCUKC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 06:02:57 -0400
Subject: Re: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andi Kleen <ak@suse.de>
Cc: Grzegorz Chwesewicz <grzegorz.chwesewicz@chilan.com>,
       Stefan Prechtel <stefan.prechtel@googlemail.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Len Brown <lenb@kernel.org>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <200703211046.20724.ak@suse.de>
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
	 <20070320164604.M60273@chilan.com>
	 <1174469047.10840.7.camel@localhost.localdomain>
	 <200703211046.20724.ak@suse.de>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 11:10:08 +0100
Message-Id: <1174471808.10840.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 10:46 +0100, Andi Kleen wrote:
> On Wednesday 21 March 2007 10:24, Thomas Gleixner wrote:
> > On Tue, 2007-03-20 at 17:47 +0100, Grzegorz Chwesewicz wrote:
> > > I have HP nx6325. I've tried to use WARN_ON_ONCE patch, but I don't see
> > > nothing special in dmesg. Just in case I'm posting my
> > > dmesg_2.6.20_WARN_ON_ONCE_on_battery log on
> > > http://bugzilla.kernel.org/show_bug.cgi?id=8235 .
> > >
> > > Below I post output of my /proc interrupts (10 sec. delay between reads).
> > >
> > > Other interesting thing on 2.6-git is that when I press a key on keyboard
> > > it doesn't repeat (on battery), but it repeats on 2.6-git on ac.
> >
> > Sigh. The periodic PIT interrupt pampers over the problem in <2.6.21-rc.
> > It prevents the BIOS to switch the CPU in lower power states.
> 
> I think I ran into the same problem with my initial noidletick patch.
> I don't have that test machine anymore though.
> 
> Normally the "use PIT when AMD && Cstate >= 2" check should
> have caught that though. Why did it here?

The BIOS/ACPI is broken and does only expose C1, which should not switch
off LAPIC. The BIOS is switching into deeper C-States behind the kernels
back somehow.

	tglx


