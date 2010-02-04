Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab0BDEhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 23:37:51 -0500
Received: from mail-yw0-f189.google.com ([209.85.211.189]:64090 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab0BDEhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 23:37:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cX2YjVc7rfSSnbrm0Gv+FEF7SW/0Fmr9S4T++Uw7u325an2zgszw2JBU5AXRlGu1wt
         9R50PDMFsc9qy37dXJtRknaWwk57V28nfpcL2wTM3a2ptbblDLj9k8FHUHCSGjf9yiBV
         mCfDeSwVsELBqcrPkkW/biadmo6b46rIPLoFc=
Message-ID: <4B6A4F17.2080806@lwfinger.net>
Date: Wed, 03 Feb 2010 22:37:43 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-1.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-pci@vger.kernel.org, Peter Haight <peterh@sapros.com>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v1 0/7] PCI: try enabling "pci=use_crs" again
References: <20100203233617.10803.92102.stgit@bob.kio>
In-Reply-To: <20100203233617.10803.92102.stgit@bob.kio>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2010 05:38 PM, Bjorn Helgaas wrote:
> Historically, Linux has assumed a single PCI host bridge, with that bridge
> claiming all the address space left after RAM and legacy devices are taken out.
> 
> If the system contains multiple host bridges, we can no longer operate under
> that assumption.  We have to know what parts of the address space are claimed
> by each bridge so that when we assign resources to a PCI device, we take them
> from a range claimed by the upstream host bridge.
> 
> We use ACPI to enumerate all the PCI host bridges in the system, and part of
> the host bridge description is the "_CRS" (current resource settings" property,
> which lists the address space used by the bridge.  On x86, we currently ignore
> most of the _CRS information.  This patch series changes this, so we will use
> _CRS to learn about the host bridge windows.
> 
> Since most x86 machines with multiple host bridges are relatively new, this
> series only turns this on for machines with BIOS dates of 2010 or newer and for
> a few machines that we know need it.
> 
> These apply on 0148b041be4e7, which is the current head of the linux-next
> branch of Jesse's pci-2.6 git tree.  The first patch is just Jeff Garrett's
> patch to remove intel_bus.c, so that is only here for people who want to test
> the rest of the patches.  I expect Jesse will pick up Jeff's patch via Linus'
> tree.
> 
> Gary and Peter have some of these problem machines, so I'm hoping they can give
> this a whirl.
> 
> Larry, you reported the problem the last time I tried to turn on "pci=use_crs"
> by default.  This series shouldn't affect your machine because it's not in the
> whitelist, but I expect that if you boot the current kernel with "pci=use_crs",
> it should still fail, and if you boot with these patches and "pci=use_crs", it
> *should* work.  I know it's a lot to ask, but it'd be great if you had a chance
> to try that.

On my system, "git describe" returns v2.6.33-rc6-146-gc80d292. Patch 1 does not
apply and can be reverted. That is not a problem, but beginning with patch 5,
these do not apply.

In addition to the above, my system now boots with "pci=use_crs", unlike when I
filed the Bugzilla.

What kernel should I be running to test these patches?

Larry
