Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbZBVRz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbZBVRz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 12:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZBVRzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 12:55:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44942 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbZBVRzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 12:55:15 -0500
To: "Kevin O'Connor" <kevin@koconnor.net>
Cc: Stefan Reinauer <stepan@coresystems.de>, linux-kernel@vger.kernel.org,
       coreboot@coreboot.org
Subject: Re: MPTable can not be high-memory on Linux
From: Andi Kleen <andi@firstfloor.org>
References: <499DB40C.1060205@coresystems.de>
	<499DB480.1000909@coresystems.de> <499DB6D8.5040706@coresystems.de>
	<499DBDA0.2010606@coresystems.de> <499DCE79.8020809@coresystems.de>
	<20090222152530.GA30576@morn.localdomain>
Date: Sun, 22 Feb 2009 18:53:41 +0100
In-Reply-To: <20090222152530.GA30576@morn.localdomain> (Kevin O'Connor's message of "Sun, 22 Feb 2009 10:25:31 -0500")
Message-ID: <87tz6muzmi.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin O'Connor <kevin@koconnor.net> writes:
>
> It looks like the problem is that the MPTable is located in the last
> 64K of memory (instead of the first few megabytes).  There is a
> comment about this in arch/x86/kernel/mpparse.c:
>
>    /*
>     * We cannot access to MPC table to compute
>     * table size yet, as only few megabytes from
>     * the bottom is mapped now.
>     * PC-9800's MPC table places on the very last
>     * of physical memory; so that simply reserving
>     * PAGE_SIZE from mpg->mpf_physptr yields BUG()
>     * in reserve_bootmem.
>     */
>
> However, that comment is in an #ifdef specific to 32bit kernels.
> (Though, it's not clear to me how that code would help as it sets size
> to be a negative number.)
>
> The easiest way to fix this is to change SeaBIOS to copy the whole
> mptable to the first megabyte.  Also, we need to fix your SMBIOS so
> that ACPI is used instead of the mptable.

The kernel should just use early_ioremap to access it I guess.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
