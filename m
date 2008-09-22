Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbYIVLR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbYIVLR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 07:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYIVLRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 07:17:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40658 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbYIVLRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 07:17:50 -0400
Date: Mon, 22 Sep 2008 13:17:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic
	option
Message-ID: <20080922111730.GF5987@elte.hu>
References: <20080920012322R.fujita.tomonori@lab.ntt.co.jp> <20080920060059.GA25713@elte.hu> <20080920225705C.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080920225705C.fujita.tomonori@lab.ntt.co.jp>
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

> > But, in general, it's pretty pointless to add boot options for 
> > anything but debugging - nobody will use them unless there's a 
> > _problem_ with the default. So the right approach is to not add boot 
> > options and to make sure that the defaults are sane and intelligent.
> 
> In general (or ideally), I agreed. But we can't do that in some cases.
> 
> And IOMMUs has some options for non general cases. For example, the 
> option, we are talking about, 'fullflush' for disabling lazy IOTLB 
> flushing, has no correct setting for everyone. It's kinda policy. The 
> boot option changes the policy that the IOMMU maintainer set by 
> default.

yes. But boot options really have a lot less relevance in practice. In 
99.99% of cases they are only used if things go wrong. They are almost 
never used to tune production systems. (yes, there are exceptions - in 
0.01% of the cases)

so ... i'd really suggest for you to get the bootup defaults right, and 
then just to give enough boot option flexibility to turn something off 
that might break in practice.

Otherwise, dont bother - if you want to offer advanced performance 
tuning then at _minimum_ it should be debugfs or sysctl exposed. It's 
totally PITA to performance-tune a system via a boot option.

> > So could we work towards removing unnecessary boot options please? _If_ 
> > we want any strategy switch then that should be runtime anyway - nobody 
> > sane will reboot a server just to tune it slightly, and no distro will 
> > litter the boot commandline with hardware dependent tunings either. So 
> > it's only the default that matters, plus boot parameters for debugging.
> 
> Ok, though I still think that deprecating and removing the existing 
> kernel parameter is bad for users.

yes - the solution could be as easy as to add back that single option to 
the affected iommu alone. (i.e. create a compatibility alias in essence)

> Joerg's patch does two things, adding fullflush and nofullflush to the 
> generic option. The former needs more discussion though it might be a 
> correct idea. The latter is clearly wrong (as Joerg agreed).
> 
> I sent you the patch to revert his patch. But If you like to fix 
> things in a different way, then it's fine.

well, i'd like you two to agree on how to proceed. Could you send a 
patch please that adds back the option that Joerg's patch removed? I 
certainly dont argue with the point that we should preserve existing 
options.

	Ingo
