Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbYDSFWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbYDSFWx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 01:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbYDSFWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 01:22:43 -0400
Received: from ozlabs.org ([203.10.76.45]:47142 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbYDSFWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 01:22:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18441.33181.511355.338428@cargo.ozlabs.ibm.com>
Date: Sat, 19 Apr 2008 15:22:37 +1000
From: Paul Mackerras <paulus@samba.org>
To: David Miller <davem@davemloft.net>
Cc: jochen@scram.de, sfr@canb.auug.org.au, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, scottwood@freescale.com,
       i2c@lm-sensors.org, khali@linux-fr.org
Subject: Re: [PATCH] [POWERPC] i2c: fix build breakage introduced by OF
 helpers
In-Reply-To: <20080418.210933.01471700.davem@davemloft.net>
References: <4808AEC7.8040000@scram.de>
	<18441.28496.84724.411784@cargo.ozlabs.ibm.com>
	<20080418.210933.01471700.davem@davemloft.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:
> From: Paul Mackerras <paulus@samba.org>
> Date: Sat, 19 Apr 2008 14:04:32 +1000
> 
> > Jochen Friedrich writes:
> > 
> > > Fix build breakage introduced in commit
> > > "[POWERPC] i2c: OF helpers for the i2c API".
> > > If i2c-core is compiled as module, the helper needs to be
> > > compiled as module, as well. Rename i2c.c to of_i2c.c to
> > > avoid name space conflict.
> > 
> > Actually, since only powerpc has irq_of_parse_and_map, I'm now
> > inclined to think that drivers/of/i2c.c should live under arch/powerpc
> > for now, or at the least its option should depend on PPC_OF.
> 
> I specifically asked for this to not be PPC only so that I
> can make use of this infrastructure on sparc64 for I2C devices.

OK.

> It's OK if this breaks the sparc64 allmodconfig build, I'll take
> care of this once it's merged in.

It breaks the sparc32 allmodconfig build, which seems to be a
concern.  How do you suggest we fix that?

> Please merge the PPC tree to Linus soon, so that I can merge
> in my sparc64 NUMA bits which depend upon the LMB changesets
> in the PPC tree.

Sure, it's just this sparc32 breakage which is holding me up.

Paul.
