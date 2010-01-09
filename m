Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911Ab0AIXkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab0AIXkF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 18:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839Ab0AIXkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 18:40:04 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:38797 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab0AIXkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 18:40:03 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Marcel Selhorst <m.selhorst@sirrix.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tpm_infineon: Fix suspend/resume handler for pnp_driver
References: <87d41xu18p.fsf@devron.myhome.or.jp>
	<20100105155900.7cf92358.akpm@linux-foundation.org>
Date: Sun, 10 Jan 2010 08:39:56 +0900
In-Reply-To: <20100105155900.7cf92358.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 5 Jan 2010 15:59:00 -0800")
Message-ID: <87vdfasv8z.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>> With recent quick review, I found the bug of tpm_infineon. (I don't have
>> this device, and compile test only)
>> 
>
> hm.  What bug?  Is there a bugzilla reference, or do you have a
> description of that bug?  Perhaps the device is not functional after
> suspend/resume?

Unfortunately, the thing what I can say for this is small.

With review, it seems anybody doesn't call pnp_driver->driver.suspend/resume().
(pnp_bus calls pnp_device->pnp_driver->suspend/resume())

> This matters because people who are experiencing problems with this
> device will want to know whether this patch is likely to fix them
> (although that'll be pretty obvious in this case).
>
> It also matters because people (ie: me) will want to know whether the
> bug is sufficiently serious to warrant backporting the fix into earlier
> -stable kernels.

I guess it might be tpm_infineon can't suspend/resume properly. However,
with it, I don't know what happen actually. (it might be, tpm can't
verify the security issue on suspend/resume process? or can't wakeup
from tpm? or spend power?  or other?)

> Is the patch actually needed in earlier kernels?  It applies cleanly. 
> When did this pnp_driver->suspend/resume requirement come about?

With quick search, I found commit 1b8333b02aa281a2849331ad62ee595c46a1c5ac.
It converts tpm from pci to pnp, and start to use
pnp_devier.driver.suspend/resume.

But, I'm not sure there is the actual user of
pnp_driver->driver.suspend/resume() at that commit time.

>> PNP driver must use pnp_driver->suspend/resume anymore.
>
> I assume this text should have read "PNP driver must use
> pnp_driver->suspend/resume.".

Yes.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
