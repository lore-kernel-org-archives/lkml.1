Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbZF1Cg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbZF1Cg5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 22:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbZF1Cgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 22:36:48 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:42505 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbZF1Cgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 22:36:47 -0400
To: Rob Landley <rob@landley.net>
Subject: Re: Can't boot 2.6.30 powerpc kernel under qemu.
Cc: linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Content-Disposition: inline
From: Jeremy Kerr <jk@ozlabs.org>
Date: Sun, 28 Jun 2009 10:33:09 +0800
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906281033.09842.jk@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

> I bisected the problem in the linux kernel repository, and wound up
> here:
>
> 60ee031940c1b09c137b617a8829e2f081961fe0 is first bad commit
> commit 60ee031940c1b09c137b617a8829e2f081961fe0
> Author: Jeremy Kerr <jk@ozlabs.org>
> Date:   Tue Feb 17 11:44:14 2009 +1100
>
>     powerpc/spufs: Use correct return value for spu_handle_mm_fault

I think it's very unlikely that this commit would be causing the
problem, as qemu doesn't have any SPEs (they're specific to the Cell
architecture), which would be required to hit this code. Also, you're 
not compiling with CONFIG_SPU_BASE, so the file that this changed 
shouldn't even be built.

Perhaps try the bisect again?

> P.S.  Is there a powerpc list I should have cc:'d this to? 
> vger.kernel.org just has kvm-ppc, no other "ppc" or "power".  Google
> suggests ozlabs, but their mailing lists only see to have cell, which
> this isn't...

linuxppc-dev@lists.ozlabs.org is the one you want for this:

 https://lists.ozlabs.org/listinfo/linuxppc-dev

Cheers,


Jeremy

