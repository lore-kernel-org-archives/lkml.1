Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbYIYAPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbYIYAPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 20:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbYIYAPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 20:15:36 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:19298 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYIYAPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 20:15:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K4OmWuz3wQqGSaIDHYBHZzeGXRqtgYffntXjjCuRzudWdUG9kP13ayfEG1V5J/gJnm
         fHMQlL5qbDozb0dSknnNMbqwHu9SzjNDt58Il1RzVs6LBcr6d8lHchQDSC9dFyd5GStO
         xlyLtfOSqWgh36Y2tpwRtBDcwJn4/hpkLYPdI=
Date: Thu, 25 Sep 2008 08:15:21 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: Alok kataria <alokkataria1@gmail.com>
Cc: Yan Li <elliot.li.tech@gmail.com>,
       Cristi Magherusan <cristi.magherusan@net.utcluj.ro>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, joerg.roedel@amd.com,
       rjmaomao@gmail.com, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com,
       akataria@vmware.com, Zachary Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
Message-ID: <20080925001521.GB21049@yantp.cn.ibm.com>
References: <48D12490.5010003@zytor.com> <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com> <1222265424.5708.5.camel@localhost> <20080924142322.GA21049@yantp.cn.ibm.com> <35f686220809240919x631d8f98m5f1d20c2c8e98690@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35f686220809240919x631d8f98m5f1d20c2c8e98690@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 09:19:44AM -0700, Alok kataria wrote:
> Thanks for doing this patch.
> It would be really beneficial to detect if we are running on a
> hypervisor in general. Though i think the approach should be more
> generic,  so that we have a common interface for all the hypervisors.
> I have some patches which use "cpuid" to detect if we are running on a
> hypevisor and use various cpuid leafs to get some hypervisor specific
> info.
> This CPUID interface will be available only in the newer (read,
> Hardware version 7) version of VMware products. So still for the
> products which don't use the newer hardware version, this patch is
> helpful.

Hi Alok,

Thanks for your comments. Sure, it's good to add a common interface
for all the hypervisors. And I'd like to work on that.

> Btw, are you pushing these patches for the 2.6.27 release ? If this is
> for the x86 tree(2.6.28) i think we should hold on, until i post the
> proposal for the cpuid patches, so that we can unify this and have a
> generic way to detect on which hypervisor are we running .

My motivation behind this patch is to serve the MTRR codes to fix a
false warning, so I'd like to see it in 2.6.28 as soon as
possible. The latest 2.6.27-rc7 is issuing false warning when running
under the VMware Server 1.0.7, complaining that MTRR's all blank.
Currently the false warning has been confirmed under both KVM and
VMware so the detection for these two VMs are added in my [PATCH
2/2]. For this specific reason (fixing false warning), a common
interface maybe not necessary unless we are sure all VMs have their
CPU's MTRR blank (it would be very difficult to confirm this on all
VMs human has made). Therefore I'd like to make this patch as simple
as possible and make into 2.6.28 since it's fixing false warning (one
can say it's a regression since at least 2.6.24 doesn't issue a false
warning here).

Also I'd be very happy to work with you to combine this with your
CPUID detection code. I think VMware Server 2.0 is using Hardware
version 7 VM, right? So I can combine your and my code to test it.

But my concern is that for such a simple function (detecting VMware,
not a common interface), is it worth to have more codes to use two
different ways for detecting new and older VMwware while a simple
dmi_name_in_vendors() might be enough in both situation? I don't think
bloating the kernel is good.

Thanks!

-- 
Li, Yan
