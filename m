Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbYCNTxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbYCNTxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 15:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbYCNTxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 15:53:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60114 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbYCNTxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 15:53:09 -0400
Date: Fri, 14 Mar 2008 20:55:20 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: merge the simple bitops and move them to bitops.h
Message-ID: <20080314195520.GV2522@one.firstfloor.org>
References: <20080312200128.GA24983@mailshack.com> <47DABEFB.3050704@goop.org> <1205523826.7441.1242464129@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205523826.7441.1242464129@webmail.messagingengine.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The CMOV define should probably be dependent on what CPU the kernel
is tuned for. It was originally written for when x86-64 was only
K8 which has fast CMOV, but e.g. on P4 CMOV is actually deprecated
over jumps.

> Both define fls64(), but i386 uses a generic one and x86_64 defines
> one all by itself. The generic one is currently not suitable for
> use by 64-bit archs... that can change.

It is very unlikely a generic one will ever be able to compete
with a single instruction.

> x86_64 defines ARCH_HAS_FAST_MULTIPLIER, i386 not. This affects a
> choice of generated code in the (generic) hweight function. It would
> be nice if that could move to some other file.

It depends on the CPU, but it can be probably safely set on pretty much
all modern x86 cores.

> x86_64 has a mysterious inline function set_bit_string, which is
> only used by pci-calgary_64.c and pci-gart_64.c. Not sure what to
> do with it.

It's generic and could really live in linux/bitops.h

-Andi

