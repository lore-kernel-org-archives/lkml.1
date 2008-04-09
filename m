Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbYDIKvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbYDIKvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 06:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbYDIKvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 06:51:21 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:41082 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbYDIKvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 06:51:20 -0400
Date: Wed, 9 Apr 2008 07:50:45 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Ray Lee <ray-lk@madrabbit.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n-Apple
Message-ID: <20080409105045.GB3786@localhost.ift.unesp.br>
References: <pdYe6zNQVl.A.AOB.6GW9HB@albercik> <924EFEDD5F540B4284297C4DC59F3DEED0EA1E@orsmsx423.amr.corp.intel.com> <20080404011053.GA21254@localhost.ift.unesp.br> <2c0942db0804032015y57e91811r37b729cd836cef6d@mail.gmail.com> <20080404114756.GA3890@localhost.ift.unesp.br> <924EFEDD5F540B4284297C4DC59F3DEED0EB77@orsmsx423.amr.corp.intel.com> <20080404155155.GA6578@localhost.ift.unesp.br> <924EFEDD5F540B4284297C4DC59F3DEED0EEC6@orsmsx423.amr.corp.intel.com> <20080406205610.GA4647@localhost.ift.unesp.br> <924EFEDD5F540B4284297C4DC59F3DEED0F279@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEED0F279@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun  6.Apr'08 at 22:31:17 -0700, Pallipadi, Venkatesh wrote:
> >On Fri  4.Apr'08 at 13:41:45 -0700, Pallipadi, Venkatesh wrote:
> >> [...]
> >> >>> >I've uploaded the picture where it hangs, it is in the very 
> >> >>beginning
> >> >>> >of the boot process:
> >> >>> >
> >> >>> >http://www.ift.unesp.br/users/crmafra/dsc04673.jpg
> >> >>> 
> >> >>> 
> >> >>> Can you try the latest git and see whether this still is 
> >a problem?
> >> >>
> >> >>I've just updated to latest git, but it may take some time for it 
> >> >>to happen again (the first 3 boots were okay). Last time 
> >it happened
> >> >>with 2.6.25-rc7-00149-gaf8be4e (I checked now). 
> >> >>
> >> >>Do you have reasons to believe this issue was fixed since then?
> >> >
> >> >Yes. I think the patch here should have fixed the problem....
> >> >Patch : http://marc.info/?l=linux-kernel&m=120674502201007&w=4
> >> >
> >> 
> >> Hmmmm.... Looking at latest git,
> >> The above patch is not yet in git. Can you please apply the 
> >above patch
> >> and see whether do you still see the problem.....
> >
> >I applied Venkatesh's patch from the link above on top of 
> >v2.6.25-rc8-139-ge315c12, but my laptop hung at the 11th boot with the
> >same state show here:
> >http://www.ift.unesp.br/users/crmafra/dsc04673.jpg
> >
> >I waited 3'30" but the boot process never resumed, so I pressed
> >the power button.
> >
> >Any further patches I might try?
> 
> Carlos,
> 
> Hmm. So, we still have some bug hidden in there..
> As this is similar to 10117, we should probably track this there.
> 10093 is a different cpuidle specific bug looks like, as it happens at a
> different place while switching between governors.
> 
> Can you attach your kernel config, acpidump output and dmesg when kernel
> boots ok to that bugzilla.
> Also, if you can please try processor.max_cstate=2 boot option and see
> whether you still can reproduce the problem. If you can, then try
> processor.max_cstate=1. For this boot option to work, you have to have
> ACPI_PROCESSOR built into your kernel (and should not be a module).

I booted the laptop many times yesterday (to test these things):

1) CONFIG_CPUIDLE=n seems to help. It didn't hang after 17 boots

2) processor.max_cstate=2 doesn't help, it hung at the 10th boot

3) processor.max_cstate=1 survived 20 boots without hanging

And when it hung, it always stop at the same point shown in
the picture quoted above.

I hope this will help.

Thanks for taking a look at the problem!

