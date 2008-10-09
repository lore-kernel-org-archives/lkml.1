Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbYJIUqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbYJIUqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 16:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYJIUpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 16:45:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:30840 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbYJIUpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 16:45:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UziBeP7UnB2DEBvUeuaOCFnBgRJOv1ed0rwjTeW5avZ9L59ORMhnSjVyulDmS2WucA
         MEYn9ZScPbVfy/md3ezBXUSbBgqS+Gxcfp/gKhxXWDpZplI3lu2o8XJJYOc5vd9NsHM2
         AYT8YhEj9O3eVqSvVQE44EWDpsyM565eOcGUY=
Message-ID: <35f686220810091345h253d71e8s4fe9d7ea8e636ccc@mail.gmail.com>
Date: Thu, 9 Oct 2008 13:45:52 -0700
From: "Alok kataria" <alokkataria1@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH] Re: x86_32 tsc/pit and hrtimers
Cc: "Jeff Hansen" <x@jeffhansen.com>, "Chris Snook" <csnook@redhat.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, akataria@vmware.com
In-Reply-To: <alpine.LFD.2.00.0810092152410.3271@apollo>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0810071640110.25661@ren>
	 <48ED1728.5060708@redhat.com> <Pine.LNX.4.64.0810081542300.14815@ren>
	 <48ED2A89.3000902@redhat.com> <Pine.LNX.4.64.0810081554380.14982@ren>
	 <alpine.LFD.2.00.0810090910510.3237@apollo>
	 <48EE4FC4.7070902@redhat.com>
	 <alpine.LFD.2.00.0810092118100.3271@apollo>
	 <Pine.LNX.4.64.0810091344250.24851@ren>
	 <alpine.LFD.2.00.0810092152410.3271@apollo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2008 at 12:53 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 9 Oct 2008, Jeff Hansen wrote:
>
>> OK, so are we all agreed that something like clocksource_trust=tsc would be
>> the best?
>
> No, it's per affected device: tsc=trust or tsc=stable or whatever
> unintuitive name we want to come up. And it is a modification to TSC
> not to the clocksource layer.

Yep, this is cool. I too have a patch in my local tree which does a
similar thing i have a tsc_reliable flag which is set right now only
when we are running under a VMware hypervisor.
Along with marking the no_verify flag for TSC, this patch of mine also
skips the TSC synchornization checks.

        The TSC synchronization loop which is run whenever a new cpu is
brought up is not actually needed on systems which are known to have a
reliable TSC. TSC between 2 cpus can be off by a marginal value on such
systems and thats okay for timekeeping, since we do check for tsc going
back in read_tsc.

Can this reasoning be included and synchronization skipped for all
these systems with reliable aka trustworthy TSC's  ?

Thanks,
Alok
>
> Thanks,
>
>        tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
