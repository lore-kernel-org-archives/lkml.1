Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYCQWqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYCQWqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 18:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYCQWqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 18:46:12 -0400
Received: from [128.224.252.2] ([128.224.252.2]:53957 "EHLO
	yow-pgortmak-d1.corp.ad.wrs.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751896AbYCQWqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 18:46:11 -0400
Date: Mon, 17 Mar 2008 18:46:08 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Adrian Bunk <bunk@kernel.org>, Kumar Gala <galak@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: powerpc: cuImage.* creation error
Message-ID: <20080317224607.GA10732@windriver.com>
References: <20080317193652.GA9550@cs181133002.pp.htv.fi> <20080317200754.GA7383@windriver.com> <fa686aa40803171541t6357d304i2e7e5292f084d09d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa686aa40803171541t6357d304i2e7e5292f084d09d@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message: Re: powerpc: cuImage.* creation error
on 17/03/2008 Grant Likely wrote:

> On Mon, Mar 17, 2008 at 2:07 PM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
> > In message: powerpc: cuImage.* creation error
> >
> >  @@ -253,8 +253,8 @@ image-$(CONFIG_TQM8540)                     += cuImage.tqm8540
> >   image-$(CONFIG_TQM8541)                        += cuImage.tqm8541
> >   image-$(CONFIG_TQM8555)                        += cuImage.tqm8555
> >   image-$(CONFIG_TQM8560)                        += cuImage.tqm8560
> >  -image-$(CONFIG_SBC8548)                        += cuImage.tqm8548
> >  -image-$(CONFIG_SBC8560)                        += cuImage.tqm8560
> >  +image-$(CONFIG_SBC8548)                        += cuImage.sbc8548
> >  +image-$(CONFIG_SBC8560)                        += cuImage.sbc8560
> 
> No, the suffix in the cuImage targets has a 1:1 relationship with dts
> files in arch/powerpc/boot/dts/.  If a file doesn't exist there, then
> the target cannot be built.

You should have both the sbc8548.dts and the sbc8560.dts in your tree.
They have been in there for several weeks now.

I just tested with the above here, and I was just about to hit send on
this extra chunk to fix the second half of the problem.

Note that I didn't lump the tqm8540 in with the other tqm, because the
defconfig tends to indicate it doesn't need 85xx-cpm2;  just 85xx.

Thanks,
Paul.

--

Author: Paul Gortmaker <paul.gortmaker@windriver.com>
Date:   Mon Mar 17 18:33:52 2008 -0400

    wrapper: Add entries for tqm8540 and sbc85xx
    
    The wrapper script didn't have entries for the TQM8540 board and the
    SBC8548 or SBC8560 boards.  I've assumed that the TQM8540 console is
    8250 based and not CPM based by looking at its defconfig.  There was
    also a trailing * on the TQM8555 entry that I removed too.
    
    Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arch/powerpc/boot/wrapper b/arch/powerpc/boot/wrapper
index d50e498..8ec8ea8 100755
--- a/arch/powerpc/boot/wrapper
+++ b/arch/powerpc/boot/wrapper
@@ -174,7 +174,10 @@ cuboot*)
     *-mpc83*)
         platformo=$object/cuboot-83xx.o
         ;;
-    *-tqm8541|*-mpc8560*|*-tqm8560|*-tqm8555*)
+    *-tqm8540|*-sbc85*)
+        platformo=$object/cuboot-85xx.o
+        ;;
+    *-tqm8541|*-mpc8560*|*-tqm8560|*-tqm8555)
         platformo=$object/cuboot-85xx-cpm2.o
         ;;
     *-mpc85*)
