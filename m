Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbYJASgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbYJASgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 14:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYJASgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 14:36:35 -0400
Received: from gw.goop.org ([64.81.55.164]:47470 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbYJASge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 14:36:34 -0400
Message-ID: <48E3C32B.3090701@goop.org>
Date: Wed, 01 Oct 2008 11:36:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: akataria@vmware.com, "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>, Dan Hecht <dhecht@vmware.com>,
       Zachary Amsden <zach@vmware.com>,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and Linux.
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607@goop.org> <48E3BC47.60900@zytor.com> <48E3BD83.2090801@goop.org> <48E3BE65.2050909@zytor.com>
In-Reply-To: <48E3BE65.2050909@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> With a sufficiently large block, we could use fixed points, e.g. by 
> having each vendor create interfaces in the 0x40SSSSXX range, where 
> SSSS is the PCI ID they use for PCI devices.

Sure, you could do that, but you'd still want to have a signature in 
0x40SSSS00 to positively identify the chunk.  And what if you wanted 
more than 256 leaves?

> Note that I said "create interfaces".  It's important that all about 
> this is who specified the interface -- for "what hypervisor is this" 
> just use 0x40000000 and disambiguate based on that.

"What hypervisor is this?" isn't a very interesting question; if you're 
even asking it then it suggests that something has gone wrong.  Its much 
more useful to ask "what interfaces does this hypervisor support?", and 
enumerating a smallish range of well-known leaves looking for signatures 
is the simplest way to do that.  (We could use signatures derived from 
the PCI vendor IDs which would help with managing that namespace.)

    J
