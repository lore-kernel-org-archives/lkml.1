Return-Path: <linux-kernel-owner+w=401wt.eu-S1751627AbYITGB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbYITGB1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 02:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbYITGBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 02:01:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42614 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbYITGBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 02:01:18 -0400
Date: Sat, 20 Sep 2008 08:00:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic
	option
Message-ID: <20080920060059.GA25713@elte.hu>
References: <20080920012322R.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080920012322R.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> This patch against tip/x86/iommu virtually reverts
> 2842e5bf3115193f05dc9dac20f940e7abf44c1a. But just reverting the
> commit breaks AMD IOMMU so this patch also includes some fixes.
> 
> The above commit adds new two options to x86 IOMMU generic kernel boot
> options, fullflush and nofullflush. But such change that affects all
> the IOMMUs needs more discussion (all IOMMU parties need the chance to
> discuss it):
> 
> http://lkml.org/lkml/2008/9/19/106
> 
> For me, adding these boot parameters doesn't make sense.
> 
> All the hardware IOMMUs could use 'fullflush' for lazy IOTLB flushing
> but Calgary doesn't support it. Intel VT-d has the different option
> for it (and we can't rename it). [...]

Well if the new option is desired, you dont have to rename the old 
option - just alias it to the new too and deprecate the old one 
eventually. Boot options are not really ABIs in the traditional sense 
anyway.

But, in general, it's pretty pointless to add boot options for anything 
but debugging - nobody will use them unless there's a _problem_ with the 
default. So the right approach is to not add boot options and to make 
sure that the defaults are sane and intelligent.

So could we work towards removing unnecessary boot options please? _If_ 
we want any strategy switch then that should be runtime anyway - nobody 
sane will reboot a server just to tune it slightly, and no distro will 
litter the boot commandline with hardware dependent tunings either. So 
it's only the default that matters, plus boot parameters for debugging.

	Ingo
