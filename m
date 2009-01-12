Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbZALReq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbZALReq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbZALReh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:34:37 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:36708 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbZALReg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:34:36 -0500
Date: Mon, 12 Jan 2009 11:33:49 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Ingo Molnar <mingo@elte.hu>
cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, andi@firstfloor.org, ak@linux.intel.com,
       rth@twiddle.net, sfr@canb.auug.org.au, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] compiler-gcc.h: add more comments to RELOC_HIDE
In-Reply-To: <20090110122945.GA28033@elte.hu>
Message-ID: <Pine.LNX.4.64.0901121128470.30369@quilx.com>
References: <200901100040.n0A0eruc013680@imap1.linux-foundation.org>
 <200901102211.45603.rusty@rustcorp.com.au> <20090110122945.GA28033@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2009, Ingo Molnar wrote:

> 2) Special structure sizes
>
>  For example we want to load a value from "&var + LARGE_OFFSET" (common
>  percpu construct). If 'var' is a C structure that happens to have a size
>  of 255 bytes, then GCC could legitimately assume that 'LARGE_OFFSET' is
>  0..255 [inclusive], and could optimize LARGE_OFFSET to be truncated to a
>  single byte.


But that is not what is occurring. We do not do &var + LARGE_OFFSET.
Instead one does

	((void *)&var) + LARGE_OFFSET

or
	((unsigned long)&var) + LARGE_OFFSET


The cast should cause the C compiler to drop all assumptions about size.
And the definition of RELOC_HIDE for icc and generic compilers in the tree
show that this is working.

