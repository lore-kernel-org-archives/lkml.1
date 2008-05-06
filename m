Return-Path: <linux-kernel-owner+w=401wt.eu-S1763443AbYEFAL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763443AbYEFAL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759737AbYEFAK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:10:57 -0400
Received: from uki.us.mooball.net ([66.98.178.13]:51327 "EHLO
	uki.us.mooball.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758516AbYEFAK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:10:56 -0400
X-ClientAddr: 220.233.82.121
Subject: RE: [PATCH 10/56] microblaze_v2: Generic dts file for platforms
From: John Williams <john.williams@petalogix.com>
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Cc: monstr@seznam.cz, linux-kernel@vger.kernel.org, arnd@arndb.de,
       linux-arch@vger.kernel.org, John Linn <linnj@xilinx.com>,
       matthew@wil.cx, will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
In-Reply-To: <20080505233234.59C381488046@mail76-wa4.bigfish.com>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
	 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
	 <20080505172535.9710319B8086@mail101-wa4.bigfish.com>
	 <1210029394.5798.140.camel@localhost>
	 <20080505233234.59C381488046@mail76-wa4.bigfish.com>
Content-Type: text/plain
Organization: PetaLogix
Date: Tue, 06 May 2008 10:10:15 +1000
Message-Id: <1210032615.5798.174.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
X-Mooball.com-MailScanner-Information: Please contact the ISP for more information
X-Mooball.com-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: john.williams@petalogix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-05 at 16:32 -0700, Stephen Neuendorffer wrote:
> The .dts is not board specific, it's design specific.  

Sure.  I'm not sure how that changes where the .DTS files should be
stored.

I find it extremely helpful from a configuration management point of
view to cluster together all of the platform-specific code and data.  I
also think it simplifies things for users, and that makes my life easier
in answering questions on the MicroBlaze list.

> In my opinion,
> this is not something that 'a vendor might maintain multiple versions
> of': instead it is in most cases simply fundamental to the FPGA design
> flow.

Sure it is.  Here's an ML505 design using the DVI video out.  Here's one
using the LL_TEMAC in SGMII mode.  Multiple designs, same board, all
will use the same board init but different DTS files.

These could be thrown down in /boot along with every other tree, but
why?  They have nothing in common with the other files down there, and
everything in common with the board/design-specific code.

Am I missing something?

>   In fact, in most cases, I'd like to make the .dts file part of
> the bitstream and not compiled into the kernel.

Well, I've just run out of BRAM on a V5LX50T design so please don't ask
for more of it to store a DTC! :)  Or do you mean to piggyback on the
tail of the configuration stream and read with some kind of JTAG user
code?

> Although powerpc has a bit more boot-time complexity than the microblaze
> does currently, I think it makes alot of sense to have some consistency
> here, and there is already a pattern to follow here which nicely
> orthogonalizes multiple .dts files for the same platform code.

arch/powerpc/boot is building a bootloader, so maybe that's why .dts
files belong there.  The bootloader is really the only thing that cares
about them as objects.  Once the kernel starts, it's just dereferencing
a pointer that happens to point to a datastructure it understands (or
copying it as a blob before doing same).

In fact, you could mount an argument that .dts files don't belong
anywhere near the MicroBlaze kernel, since our build process never
actually touches them.  

cheers,

John


