Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYDIJIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYDIJIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 05:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbYDIJIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 05:08:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58360 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbYDIJIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 05:08:40 -0400
Date: Wed, 9 Apr 2008 11:13:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Zhao Forrest <forrest.zhao@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, discuss@x86-64.org,
       linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com, mingo@elte.hu,
       ak@suse.de
Subject: Re: Does Linux have plan to support memory hole remapping?
Message-ID: <20080409091307.GG19010@one.firstfloor.org>
References: <ac8af0be0804090054w47f48ddel387d80a0331d16e1@mail.gmail.com> <87iqyro3rc.fsf@basil.nowhere.org> <ac8af0be0804090204t79beaca2qe077a28fc4a515ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac8af0be0804090204t79beaca2qe077a28fc4a515ad@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 05:04:24PM +0800, Zhao Forrest wrote:
> On 4/9/08, Andi Kleen <andi@firstfloor.org> wrote:
> > "Zhao Forrest" <forrest.zhao@gmail.com> writes:
> > >
> > > As we can see from above information that the physical memory in system
> > > is 32768MB(32GB). However OS is only using about
> > > (32768-512)MB(MemTotal:     33010240 kB). Does this mean that this
> > > linux kernel can't use the physical memory remapped
> > > from (4G-512M, 4G) to (32G, 32G+512M)?
> >
> > The linux kernel can only use the memory passed to it by the BIOS.
> > Sometimes they need special BIOS setup options to enable remapping. If
> > there are no such options and you can't upgrade it you're out of luck
> 
> Yes, I have enabled mem hole remapping in BIOS SETUP.
> After looking into dmesg, I found that all 32GB physical memory has
> been allocated to 8 nodes, but why MemTotal shows a less amount of
> memory than 32GB? Interesting......

There is some loss of memory before MemTotal, both from the BIOS
(SMM, Frame Buffer for integrated graphics etc.) and from the kernel
(mem_map which costs a few percent and some other data structures
which are allocated early) 

I covered this in detail in http://halobates.de/memorywaste.pdf

> Does MemTotal means the amount of physical memory allocated to all
> nodes? Or it has different meanings?

Amount of memory left over after early boot on all nodes and visible
to the kernel (so e.g. minus reservations for kdump kernels) 

-Andi
