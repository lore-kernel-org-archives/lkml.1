Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab0CBAmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 19:42:05 -0500
Received: from claw.goop.org ([74.207.240.146]:40988 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab0CBAmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 19:42:04 -0500
Message-ID: <4B8C5ED9.1040109@goop.org>
Date: Mon, 01 Mar 2010 16:42:01 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>, linux-kernel@vger.kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 0/7][v4] PV extension of HVM (Hybrid) for
 Xen
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com>
In-Reply-To: <1267436315-24486-1-git-send-email-sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2010 01:38 AM, Sheng Yang wrote:
> I'd like to have your comments on this patch series. We think the patches are
> prepared for check in pv_ops domU tree.
>
> The PV extension of HVM is started from real mode like HVM guest, but also with a
> a range of PV features(e.g. PV halt, PV timer, event channel, as well as PV
> drivers). So guest with this feature can takes the advantages of both H/W
> virtualization and Para-Virtualization.
>    

The PV device side of this has a lot of overlap with the older PV driver 
for HVM domains code.  Aside perhaps for the details of how 
interrupts/events are actually delivered, that seems like a completely 
distinct piece of work which could be done separately.

Also, I'd like to see a clearer statement of what you're specifically 
trying to optimise for here.  What is inefficient in an unmodified HVM 
domain, and how do your patches address these things.  What measurements 
have you made?

> The first two of the patchset imported several header file from Jeremy's tree
> and Xen tree, respect to Jeremy and Keir's works.
>
> The whole patchset based on Linux upstream.
>
> You need a line like:
>
> cpuid = [ '0x40000002:edx=0x3' ]
>
> in HVM configuration file to expose hybrid feature to guest, and
>
> CONFIG_XEN
>
> in the guest kernel configuration file to enable the hybrid support.
>
> And the compiled image can be used as native/pv domU/hvm guest/pv feature hvm kernel.
>
> Current the patchset support x86_64 only.
>    

Please add a new config option for the new code, and make it dependent 
on x86-64, rather than scattering random #ifdef CONFIG_X86_64s around 
the code.  Make sure all the code is controlled by this CONFIG variable 
so it disappears in a 32-bit build (ideally by putting it into a new 
file where possible, and only building it when enabled).

> I've discussed the vector-evtchn mapping with Stefano, and we agreed on that
> it's more complex than we thought, and can't brought much benefit for
> pvops domU. So there is no major change in this update.
>
> Change from v3:
> 1. Rebase to Linux 2.6.33 release.
>    

Why 2.6.33?  I'm currently working on 2.6.32; I intend to move to .33 
shortly, but .32 is a much more convenient base (particularly if you're 
interested in getting these changes into any distro kernels).

I rebased it to .32 without much effort.


I'll make specific comments in the patches.

     J
