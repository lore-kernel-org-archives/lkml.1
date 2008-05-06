Return-Path: <linux-kernel-owner+w=401wt.eu-S1763468AbYEFA0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763468AbYEFA0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbYEFA0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:26:30 -0400
Received: from uki.us.mooball.net ([66.98.178.13]:51738 "EHLO
	uki.us.mooball.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549AbYEFA03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:26:29 -0400
X-ClientAddr: 220.233.82.121
Subject: RE: [PATCH 07/56] microblaze_v2: Signal support
From: John Williams <john.williams@petalogix.com>
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Cc: monstr@seznam.cz, linux-kernel@vger.kernel.org, arnd@arndb.de,
       linux-arch@vger.kernel.org, John Linn <linnj@xilinx.com>,
       matthew@wil.cx, will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
In-Reply-To: <20080506001339.619971A58057@mail55-wa4.bigfish.com>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
	 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
	 <20080505213244.8DC757A0084@mail70-wa4.bigfish.com>
	 <1210030436.5798.148.camel@localhost>
	 <20080506001339.619971A58057@mail55-wa4.bigfish.com>
Content-Type: text/plain
Organization: PetaLogix
Date: Tue, 06 May 2008 10:25:50 +1000
Message-Id: <1210033550.5798.185.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
X-Mooball.com-MailScanner-Information: Please contact the ISP for more information
X-Mooball.com-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: john.williams@petalogix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-05 at 17:13 -0700, Stephen Neuendorffer wrote:
> I'm somewhat ignorant about what this code is attempting to do, but with
> some quick poking around (m68knommu, blackfin) seems to suggest that
> other architectures don't do this, while others (v850) have almost
> exactly the same code (although they are somewhat smarter and are
> careful not to flush the whole cache).
> 
> At the very least, it seems like there is some work in this area needed.

flush_cache_sigtramp should just invalidate 8 bytes up from the base
address of the trampoline.  This is just the region on the process stack
where we insert a kind of call-back back.  Writing the opcodes goes via
the dcache, and so there's a vanishingly small possibility that the CPU
will get a false hit on on an icache fetch when the code is executed.

That was what Michal's patch had when I scanned it yesterday.  It
certainly won't/shouldn't be invalidating the entire cache.

Cheers,

John


