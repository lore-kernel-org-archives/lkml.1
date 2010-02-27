Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966688Ab0B0ASL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 19:18:11 -0500
Received: from mail-yx0-f182.google.com ([209.85.210.182]:47306 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966663Ab0B0ASJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 19:18:09 -0500
MIME-Version: 1.0
In-Reply-To: <CDF924F6-56F9-4F3D-9CF9-BF321437C3B5@kernel.crashing.org>
References: <27bab769-0788-4b48-96a7-ced65e40144c@SG2EHSMHS007.ehs.local> 
	<CDF924F6-56F9-4F3D-9CF9-BF321437C3B5@kernel.crashing.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 26 Feb 2010 17:17:47 -0700
X-Google-Sender-Auth: 404b3d134249e5ec
Message-ID: <fa686aa41002261617m44af3379nd49e651c1edcf8de@mail.gmail.com>
Subject: Re: Proposal to move PCI out of arch/powerpc and into drivers/of
To: Kumar Gala <galak@kernel.crashing.org>
Cc: John Linn <John.Linn@xilinx.com>, devicetree-discuss@ozlabs.org,
       michal.simek@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       John Williams <john.williams@petalogix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 4:50 PM, Kumar Gala <galak@kernel.crashing.org> wrote:
>
> On Feb 26, 2010, at 5:07 PM, John Linn wrote:
>
>> Hi all,
>>
>> We are in the process of putting PCI/PCIe into the microblaze
>> architecture.
>>
>> In order to not duplicate/fork the PCI code in Powerpc, we're proposing
>> to move the PCI code from arch/powerpc into drivers/of such that it
>> would be common code for Powerpc and MicroBlaze.
>>
>> This would be the 1st part of a refactoring that would occur with the
>> PCI code.
>>
>> Ben H., would you mind if that happened (move arch/powerpc/kernel/pci*
>> to drivers/of/*)?
>>
>> Thanks,
>> John
>
> John,
>
> Does MicroBlaze firmware produce full OF style PCI device tree's or do what we do on embedded systems and just have the root and leave the probing to the kernel?

Mostly like we do on ppc embedded.  Let the kernel do the probing.
I'm also going to want to be able to do the same think on ARM, so I
also would like to make the code common.

>  I haven't looked at the OF side of what we do in PPC in a while but I know we have some major differences between PPC32 & PPC64 because of assumptions about what the firmware provides (or doesnt).

I'm not too worried about this.  I did some work on ppc32 to allow
both probing and static PCI device definition on the same bus segment
(although I didn't get all of it merged).  There are difference
between ppc32 & ppc64, but it seemed to me that the divergence was
more just a matter of convenience rather than any particular technical
hurdles preventing a common approach.  I think the 32 and 64 bit paths
can be mostly merged.

g.
