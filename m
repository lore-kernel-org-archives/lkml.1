Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbYITN55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbYITN55 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 09:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYITN5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 09:57:48 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:44780 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbYITN5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 09:57:47 -0400
Date: Sat, 20 Sep 2008 22:57:21 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic
	option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080920060059.GA25713@elte.hu>
References: <20080920012322R.fujita.tomonori@lab.ntt.co.jp>
	<20080920060059.GA25713@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080920225705C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2008 08:00:59 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > This patch against tip/x86/iommu virtually reverts
> > 2842e5bf3115193f05dc9dac20f940e7abf44c1a. But just reverting the
> > commit breaks AMD IOMMU so this patch also includes some fixes.
> > 
> > The above commit adds new two options to x86 IOMMU generic kernel boot
> > options, fullflush and nofullflush. But such change that affects all
> > the IOMMUs needs more discussion (all IOMMU parties need the chance to
> > discuss it):
> > 
> > http://lkml.org/lkml/2008/9/19/106
> > 
> > For me, adding these boot parameters doesn't make sense.
> > 
> > All the hardware IOMMUs could use 'fullflush' for lazy IOTLB flushing
> > but Calgary doesn't support it. Intel VT-d has the different option
> > for it (and we can't rename it). [...]
> 
> Well if the new option is desired, you dont have to rename the old 
> option - just alias it to the new too and deprecate the old one
> eventually. Boot options are not really ABIs in the traditional sense 
> anyway.

I see. I thought that the similar rule is applied to boot options and
ABIs.


> But, in general, it's pretty pointless to add boot options for anything 
> but debugging - nobody will use them unless there's a _problem_ with the 
> default. So the right approach is to not add boot options and to make 
> sure that the defaults are sane and intelligent.

In general (or ideally), I agreed. But we can't do that in some cases.

And IOMMUs has some options for non general cases. For example, the
option, we are talking about, 'fullflush' for disabling lazy IOTLB
flushing, has no correct setting for everyone. It's kinda policy. The
boot option changes the policy that the IOMMU maintainer set by
default.


> So could we work towards removing unnecessary boot options please? _If_ 
> we want any strategy switch then that should be runtime anyway - nobody 
> sane will reboot a server just to tune it slightly, and no distro will 
> litter the boot commandline with hardware dependent tunings either. So 
> it's only the default that matters, plus boot parameters for debugging.

Ok, though I still think that deprecating and removing the existing
kernel parameter is bad for users.


Joerg's patch does two things, adding fullflush and nofullflush to the
generic option. The former needs more discussion though it might be a
correct idea. The latter is clearly wrong (as Joerg agreed).

I sent you the patch to revert his patch. But If you like to fix
things in a different way, then it's fine.
