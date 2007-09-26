Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbXIZOK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbXIZOK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 10:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbXIZOKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 10:10:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51843 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbXIZOKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 10:10:47 -0400
Message-ID: <46FA6858.5060908@zytor.com>
Date: Wed, 26 Sep 2007 07:10:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Joerg Pommnitz <pommnitz@yahoo.com>
CC: Jordan Crouse <jordan.crouse@amd.com>, cebbert@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Regression in 2.6.23-pre Was: Problems with 2.6.23-rc6 on AMD
 Geode LX800
References: <637040.99806.qm@web51411.mail.re2.yahoo.com>
In-Reply-To: <637040.99806.qm@web51411.mail.re2.yahoo.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Pommnitz wrote:
> Hello all,
> this is what git bisect told me about the problem:
> 
> jpo@jpo-laptop:~/linux-2.6$ git bisect good
> 4fd06960f120e02e9abc802a09f9511c400042a5 is first bad commit
> commit 4fd06960f120e02e9abc802a09f9511c400042a5
> Author: H. Peter Anvin <hpa@zytor.com>
> Date:   Wed Jul 11 12:18:56 2007 -0700
> 
>     Use the new x86 setup code for i386
> 
>     This patch hooks the new x86 setup code into the Makefile machinery.  It
>     also adapts boot/tools/build.c to a two-file (as opposed to three-file)
>     universe, and simplifies it substantially.
> 
>     Signed-off-by: H. Peter Anvin <hpa@zytor.com>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> :040000 040000 6560eb5b7e40d93813276544bced8c478f9067f5 fe5f90d9ca08e526559815789175602ba2c51743 M      arch
> 

There is something very fishy.

The only documentation you've given us so far is a screen shot which
contained a message ("BIOS data check successful") which doesn't occur
in the kernel.

The loader string doesn't look all that familiar either; it looks like
an extremely old version of SYSLINUX, but that doesn't contain that
message either.

INT 6 is #UD, the undefined instruction exception.  This is consistent with:

> Its hitting a bug - specifically (from bootmem.c:125):
> BUG_ON(PFN_DOWN(addr) >= bdata->node_low_pfn);

However, all that tells us is that reserve_bootmem_core() was either
called with a bad address or bdata->node_low_pfn is garbage.  In
particular, without knowing how it got there it's hard to know for sure.

Could you send me the boot messages from a working kernel boot?

	-hpa

