Return-Path: <linux-kernel-owner+w=401wt.eu-S1758958AbYEFHtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958AbYEFHtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 03:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbYEFHtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 03:49:41 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:59555 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753791AbYEFHtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 03:49:40 -0400
Message-ID: <48200DCE.50106@seznam.cz>
Date: Tue, 06 May 2008 09:50:38 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: John Williams <john.williams@petalogix.com>
CC: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>, monstr@seznam.cz,
       linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       John Linn <linnj@xilinx.com>, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca
Subject: Re: [PATCH 10/56] microblaze_v2: Generic dts file for platforms
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>	 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>	 <20080505172535.9710319B8086@mail101-wa4.bigfish.com>	 <1210029394.5798.140.camel@localhost>	 <20080505233234.59C381488046@mail76-wa4.bigfish.com> <1210032615.5798.174.camel@localhost>
In-Reply-To: <1210032615.5798.174.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John and Steve,

>> The .dts is not board specific, it's design specific.  
> 
> Sure.  I'm not sure how that changes where the .DTS files should be
> stored.

I will not change this handling with platform now.

> I find it extremely helpful from a configuration management point of
> view to cluster together all of the platform-specific code and data.  I
> also think it simplifies things for users, and that makes my life easier
> in answering questions on the MicroBlaze list.

ACK. I use platforms for testing too.

>> In my opinion,
>> this is not something that 'a vendor might maintain multiple versions
>> of': instead it is in most cases simply fundamental to the FPGA design
>> flow.
> 
> Sure it is.  Here's an ML505 design using the DVI video out.  Here's one
> using the LL_TEMAC in SGMII mode.  Multiple designs, same board, all
> will use the same board init but different DTS files.
> 
> These could be thrown down in /boot along with every other tree, but
> why?  They have nothing in common with the other files down there, and
> everything in common with the board/design-specific code.
> 
> Am I missing something?

yes. One board many designs that's all.

>>   In fact, in most cases, I'd like to make the .dts file part of
>> the bitstream and not compiled into the kernel.
> 
> Well, I've just run out of BRAM on a V5LX50T design so please don't ask
> for more of it to store a DTC! :)  Or do you mean to piggyback on the
> tail of the configuration stream and read with some kind of JTAG user
> code?

snip

>> Although powerpc has a bit more boot-time complexity than the microblaze
>> does currently, I think it makes alot of sense to have some consistency
>> here, and there is already a pattern to follow here which nicely
>> orthogonalizes multiple .dts files for the same platform code.
> 
> arch/powerpc/boot is building a bootloader, so maybe that's why .dts
> files belong there.  The bootloader is really the only thing that cares
> about them as objects.  Once the kernel starts, it's just dereferencing
> a pointer that happens to point to a datastructure it understands (or
> copying it as a blob before doing same).
> 
> In fact, you could mount an argument that .dts files don't belong
> anywhere near the MicroBlaze kernel, since our build process never
> actually touches them.  

In fact. PowerPC has almost the same boot-time complexity as Microblaze has.
Just use U-BOOT and you can see. You can handle with DTB, you can change
everything there. I think it's good time for Xilinx to look at it. You will be
surprised what is there. :-)

I designed a startup part as complex can be. Passing three parameters to kernel
direct everything. You can compile DTB to kernel for final products - only set
one param to address in kernel. You can load DTB externally. You can use
compiled in FS you can use special image with FS. (I haven't tested Initramfs).
U-BOOT supports FIT where you can have many kernels, many fs with many DTB. All
in one pack. :-)
http://git.denx.de/?p=u-boot.git;a=tree;f=doc/uImage.FIT;h=b47619b84e4c1aa70911156af5aae6f52a5f8e1f;hb=HEAD

Michal
