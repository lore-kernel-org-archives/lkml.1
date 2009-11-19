Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbZKSNtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbZKSNtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbZKSNtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:49:51 -0500
Received: from n12b.bullet.mail.mud.yahoo.com ([209.191.125.179]:35753 "HELO
	n12b.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753421AbZKSNtu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:49:50 -0500
X-Yahoo-Newman-Id: 438448.87046.bm@omp425.mail.mud.yahoo.com
X-Yahoo-SMTP: qGLgp.mswBDSnFfWmYVMF5Rmg6NJ
X-YMail-OSG: 9V9ficEVM1nQMQ9WVbsb_JFc4EPnrwy0WeHgdKOT060u27t1Sl_xMKo65c4rD3A5OWKv0o5x7AM3hPusID4cD_aSkU3Zd5TNNfjnDjl5OIfWQt63kQsPe5VnAhTMs1BU9BrFfraxwZuaqyrDKo3STbrSiXlqLhJdLBQXXXJmfs3GGMa9fJnNnGzG.zbuxV67i5K.GbrkNy01wRxh8pXyxVYANUNsBSb.d9vSjLKP2eZ5HtF4Hsjxb7YSeKP28eJ57KEblmDfyRXZrT_KGD7HVGNUI7i.uz6ZjtTLO.ITSmSUoy3b5U5dw99e_cSAizGSPDzsKLiDISnxV8QKRXvi
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [Repost without wordwrapping] Merge m68k and m68knommu
Date: Thu, 19 Nov 2009 05:49:53 -0800
User-Agent: KMail/1.9.9
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
       uclinux-dev@uclinux.org, Greg Ungerer <gerg@snapgear.com>,
       Roman Zippel <zippel@linux-m68k.org>
References: <200910181655.40579.sfking00@yahoo.com> <10f740e80911181332u48f8e610o4354cfd3994c8510@mail.gmail.com>
In-Reply-To: <10f740e80911181332u48f8e610o4354cfd3994c8510@mail.gmail.com>
Organization: fdwdc.com
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911190549.53749.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 November 2009 01:32:25 Geert Uytterhoeven wrote:

> > The patch modifies the toplevel Makefile so that ARCH=m68knommu still
> > works (by setting SRCARCH=m68k) and adds the m68knommu Kconfig and
> > Makefile to the m68k Kconfig and Makefile, using the definition of ARCH
> > to select which values to use.
>
> (still dreaming of my pet Amiga-nommu project) I prefer to use
> CONFIG_MMU as the selector...

CONFIG_MMU is used as the selector elsewhere, but for Kconfig and the 
Makefiles something else was needed.
>
> > Thus when building for either a m68k or an m68knommu target, one still
> > specifies either ARCH=m68k or ARCH=m68knommu and everything should
> > build EXACTLY as it did pre-merge.  (I think).
>
> ... using CONFIG_MMU would change this?

Yes; originally I tried using CONFIG_MMU to choose between the mmu and nommu 
portions of the Kconfig and Makefile, but that broke the defconfigs.  Rather 
than patch the defconfigs or make a more elaborate patch for the Kconfig, for 
this initial patch I wanted to keep it as simple and as un-invasive as 
possible so that it would be trivial (?) to verify the merged kernel tree 
produces a kernel that is the same as the pre-merged kernel tree, thus 
providing a baseline for bisecting any problems with the subsequent patches 
that do the real merging of the individual files.  A later patch will do a 
better job of merging the Kconfigs and Makefiles.  Then you'd be able to have 
your Amiga-nommu and I can have my Coldfire 5484 either as mmu or nommu...

-- 
Steven King -- sfking at fdwdc dot com

