Return-Path: <linux-kernel-owner+w=401wt.eu-S1759954AbZIPUYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954AbZIPUYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbZIPUYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:24:10 -0400
Received: from claw.goop.org ([74.207.240.146]:41492 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbZIPUYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:24:10 -0400
Message-ID: <4AB1496B.9070705@goop.org>
Date: Wed, 16 Sep 2009 13:24:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eddie Dong <eddie.dong@intel.com>, linux-kernel@vger.kernel.org,
       Jun Nakajima <jun.nakajima@intel.com>
Subject: Re: [Xen-devel] [RFC][PATCH 03/10] xen/hybrid: Xen Hybrid Extension
 initialization
References: <1253090551-7969-1-git-send-email-sheng@linux.intel.com> <1253090551-7969-4-git-send-email-sheng@linux.intel.com>
In-Reply-To: <1253090551-7969-4-git-send-email-sheng@linux.intel.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/09 01:42, Sheng Yang wrote:
> As we know that PV guest have performance issue with x86_64 that guest kernel
> and userspace resistent in the same ring, then the necessary TLB flushes when
> switch between guest userspace and guest kernel cause overhead, and much more
> syscall overhead is also introduced. The Hybrid Extension estimated these
> overhead by putting guest kernel back in (non-root) ring0 then achieve the
> better performance than PV guest.
>
> The Hybrid Extension is started from real mode like HVM guest, but also with a
> component based PV feature selection(e.g. PV halt, PV timer, event channel,
> then PV drivers). So guest with Hybrid extension feature can takes the
> advantages of both H/W virtualization and Para-Virtualization.
>
> This patch introduced the Hybrid Extension guest initialization.
>
> Guest would detect Hybrid capability using CPUID 0x40000002.edx, then call
> HVMOP_enable_hybrid hypercall to enable hybrid support in hypervisor.
>   

I think having an option to put PV guests into an HVM container is a
good one, but as I mentioned in the other mail, I don't think this is
the right approach.

It would be much better to make it so that an unmodified guest works in
such a mode; even with no specific optimisations the guest would get
benefit from faster kernel<->usermode switches.

Then we can add specific optimisations to take advantage of, say,
running in ring 0 (=fast syscalls) and having access to HAP hardware
(=direct pagetable updates, no pinning).


    J
