Return-Path: <linux-kernel-owner+w=401wt.eu-S1750954AbXCUJQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750954AbXCUJQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 05:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbXCUJQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 05:16:57 -0400
Received: from www.osadl.org ([213.239.205.134]:53932 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750945AbXCUJQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 05:16:56 -0400
Subject: Re: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Grzegorz Chwesewicz <grzegorz.chwesewicz@chilan.com>
Cc: Stefan Prechtel <stefan.prechtel@googlemail.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Len Brown <lenb@kernel.org>, Andi Kleen <ak@suse.de>,
       john stultz <johnstul@us.ibm.com>
In-Reply-To: <20070320164604.M60273@chilan.com>
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
	 <1174326499.13341.517.camel@localhost.localdomain>
	 <b93822910703191153x20249f00vb604a0eda075a23a@mail.gmail.com>
	 <1174332477.13341.561.camel@localhost.localdomain>
	 <b93822910703191249i40a70418ka8165da52070ae82@mail.gmail.com>
	 <1174334646.13341.577.camel@localhost.localdomain>
	 <b93822910703191335i236cdc4av59cc9fd0685537ec@mail.gmail.com>
	 <1174337777.13341.621.camel@localhost.localdomain>
	 <b93822910703191451o216a8931v9023b174fdef750@mail.gmail.com>
	 <1174353329.13341.762.camel@localhost.localdomain>
	 <b93822910703200123g5b3ac0e4n1ba1122a7e90a838@mail.gmail.com>
	 <20070320164604.M60273@chilan.com>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 10:24:07 +0100
Message-Id: <1174469047.10840.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 17:47 +0100, Grzegorz Chwesewicz wrote:
> I have HP nx6325. I've tried to use WARN_ON_ONCE patch, but I don't see
> nothing special in dmesg. Just in case I'm posting my
> dmesg_2.6.20_WARN_ON_ONCE_on_battery log on
> http://bugzilla.kernel.org/show_bug.cgi?id=8235 .
> 
> Below I post output of my /proc interrupts (10 sec. delay between reads).
>
> Other interesting thing on 2.6-git is that when I press a key on keyboard it
> doesn't repeat (on battery), but it repeats on 2.6-git on ac.

Sigh. The periodic PIT interrupt pampers over the problem in <2.6.21-rc.
It prevents the BIOS to switch the CPU in lower power states.

I'm working on a detect LAPIC / BIOS madness check.

	tglx


