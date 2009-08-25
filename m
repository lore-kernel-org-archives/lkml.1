Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbZHYWJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbZHYWJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 18:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbZHYWJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 18:09:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753181AbZHYWJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 18:09:38 -0400
Date: Tue, 25 Aug 2009 15:07:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: mailing54 <mailing54@plzk.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, Eric Anholt <eric@anholt.net>,
       dri-devel@lists.sourceforge.net, Ma Ling <ling.ma@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: Re: Linux 2.6.31-rc7
In-Reply-To: <4A94599F.9020508@plzk.org>
Message-ID: <alpine.LFD.2.01.0908251456530.3218@localhost.localdomain>
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain> <4A941E8B.8080902@plzk.org> <alpine.LFD.2.01.0908251057260.3218@localhost.localdomain> <4A94599F.9020508@plzk.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 Aug 2009, mailing54 wrote:

> Linus Torvalds schrieb:
> > Are you using the same config? It sounds very much like your -rc7 problems
> > are due to the Intel KMS (kernel mode setting) driver, which I know has had
> > problems on at least Mac Mini's. And I wonder if the -rc6 kernel deb used
> > different config options and didn't enable KMS, for example. Because I don't
> > think anything actually changed in the KMS code itself between rc6 and rc7.
>   
> Not sure what settings to look for, but this looks like you are completely
> correct:
> 
> tobias@tbox:~$ cat /boot/config-2.6.31-020631rc6-generic | grep KMS
> # CONFIG_DRM_I915_KMS is not set
> # CONFIG_DRM_RADEON_KMS is not set
> tobias@tbox:~$ cat /boot/config-2.6.31-020631rc7-generic | grep KMS
> CONFIG_DRM_I915_KMS=y
> CONFIG_DRM_RADEON_KMS=y

Yeah, so it's i915 kms.

You can disable it dynamically at boot time with the 

	i915.modeset=0

kernel command line (or I guess with "nomodeset" too, for that matter, 
which should disable both i915 and radeom kms).

However, the problem remains that KMS gets the output wrong, in ways that 
clearly X does not. Eric - it's clearly not just Mac Mini and my 
experimental machine that have problems, but also a Macbook 2.1.

I wonder why the Intel KMS logic doesn't look at which output was driven 
before it got invoked. Instead, it seems to want to try to detect 
everything from scratch, even though we should be able to assume that if 
you boot from BIOS (or EFI, for that matter), the current state of the 
graphics pipeline is likely meaningful.

And clearly distros are trying to enable this. Which means that this is 
getting way more important to solve.

			Linus
