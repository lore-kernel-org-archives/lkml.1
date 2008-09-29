Return-Path: <linux-kernel-owner+w=401wt.eu-S1753070AbYI2G4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbYI2G4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 02:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYI2G4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 02:56:00 -0400
Received: from il.qumranet.com ([212.179.150.194]:46577 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbYI2G4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 02:56:00 -0400
Date: Mon, 29 Sep 2008 09:55:57 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Alok Kataria <akataria@vmware.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, avi@redhat.com,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Dan Hecht <dhecht@vmware.com>, Jun.Nakajima@Intel.Com
Subject: Re: Use CPUID to communicate with the hypervisor.
Message-ID: <20080929065557.GB9952@redhat.com>
References: <1222472815.29886.43.camel@alok-dev1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222472815.29886.43.camel@alok-dev1>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 04:46:55PM -0700, Alok Kataria wrote:
> From: Alok N Kataria <akataria@vmware.com>
> 
> This patch proposes to use a cpuid interface to detect if we are running on an
> hypervisor.
> The discovery of a hypervisor is determined by bit 31 of CPUID#1_ECX, which is
> defined to be "hypervisor present bit". For a VM, the bit is 1, otherwise it is
> set to 0. This bit is not officially documented by either Intel/AMD yet, but
> they plan to do so some time soon, in the meanwhile they have promised to keep
> it reserved for virtualization.
> 
> Also, Intel & AMD have reserved the cpuid levels 0x40000000 - 0x400000FF for
> software use. Hypervisors can use these levels to provide an interface to pass
> information from the hypervisor to the guest. This is similar to how we extract
> information about a physical cpu by using cpuid.
> XEN/KVM are already using the info leaf to get the hypervisor signature.
> 
Can this interface be used to pass variable sized data from a hypervisor
to a gust? ACPI or DMI tables for instance.

--
			Gleb.
