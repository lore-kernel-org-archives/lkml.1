Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYJAVf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYJAVf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 17:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbYJAVfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 17:35:18 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:41478 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbYJAVfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 17:35:16 -0400
Message-ID: <48E3ECD1.30809@codemonkey.ws>
Date: Wed, 01 Oct 2008 16:34:09 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: akataria@vmware.com, "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Daniel Hecht <dhecht@vmware.com>, Zach Amsden <zach@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and	Linux.
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607@goop.org> <1222894878.9381.63.camel@alok-dev1> <48E3E8DE.1080602@goop.org>
In-Reply-To: <48E3E8DE.1080602@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Alok Kataria wrote:
>
> I guess, but the bulk of the uses of this stuff are going to be 
> hypervisor-specific.  You're hard-pressed to come up with any other 
> generic uses beyond tsc.

And arguably, storing TSC frequency in CPUID is a terrible interface 
because the TSC frequency can change any time a guest is entered.  It 
really should be a shared memory area so that a guest doesn't have to 
vmexit to read it (like it is with the Xen/KVM paravirt clock).

Regards,

Anthony Liguori

>   In general, if a hypervisor is going to put something in a special 
> cpuid leaf, its because there's no other good way to represent it.  
> Generic things are generally going to appear as an emulated piece of 
> the virtualized platform, in ACPI, DMI, a hardware-defined cpuid leaf, 
> etc...

