Return-Path: <linux-kernel-owner+w=401wt.eu-S1759379AbYHVAkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379AbYHVAkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 20:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYHVAj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 20:39:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53091 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbYHVAj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 20:39:56 -0400
Date: Thu, 21 Aug 2008 20:36:59 -0400
From: Dave Jones <davej@redhat.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123
	send_IPI_mask_bitmask+0xc3/0xe0()
Message-ID: <20080822003659.GA7581@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <19f34abd0808191251x4eb61c50n13ecf7c90f0f3d9f@mail.gmail.com> <20080820013930.GN9807@one.firstfloor.org> <19f34abd0808192326jc10e758m99e76bbd5714c5b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808192326jc10e758m99e76bbd5714c5b8@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 08:26:19AM +0200, Vegard Nossum wrote:
 > On Wed, Aug 20, 2008 at 3:39 AM, Andi Kleen <andi@firstfloor.org> wrote:
 > > On Tue, Aug 19, 2008 at 09:51:44PM +0200, Vegard Nossum wrote:
 > >> Hi,
 > >>
 > >> With latest -git (1fca25427482387689fa27594c992a961d98768f), I got
 > >> this on reading from /dev/cpu/*/* while hot-unplugging cpu1.
 > >
 > > It's generally known the oprofile doesn't support CPU hotplug well.
 > > Someone needs to make a project out of fixing it properly. Right now
 > > it's just a "don't do that when it hurts"
 > 
 > Hm. What you say is true, but this one in particular has nothing to do
 > with oprofile! It has something to do with reading /dev/cpu/*/msr
 > while hot-unplugging cpu1:
 > 
 >  [<c011733e>] msr_read+0x6e/0xa0
 >  [<c01a87b4>] vfs_read+0x94/0x130
 > 
 > I wasn't using oprofile when this happened. So I think it should also
 > be considered a separate issue. Though yes -- CPU hotplug in general
 > tends to break a lot of things.

>From my reading of the msr code, we check that the cpu is online in ->open,
but we never check it again, and also, we make no guarantees that it
won't go away before we ->read or even ->close it.

Would adding a get_cpu/put_cpu across the open/close solve this?
Peter?

	Dave

-- 
http://www.codemonkey.org.uk
