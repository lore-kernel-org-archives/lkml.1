Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbZGAWwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbZGAWwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 18:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbZGAWwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 18:52:25 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:41557 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbZGAWwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 18:52:24 -0400
MIME-Version: 1.0
In-Reply-To: <4A4B49D0.2090101@monstr.eu>
References: <cover.1245345894.git.arnd@arndb.de>
	 <7a92dd639b7887bc972118d16a5fda6093200b96.1245347640.git.arnd@arndb.de>
	 <4A4B49D0.2090101@monstr.eu>
Date: Thu, 2 Jul 2009 08:52:27 +1000
Message-ID: <1d3f23370907011552h5b3c96b9h208d5567e7a2a615@mail.gmail.com>
Subject: Re: [microblaze-uclinux] [PATCH 03/11] microblaze: fall back on 
	generic header files for the ABI
From: John Williams <john.williams@petalogix.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Arnd Bergmann <arnd@arndb.de>, John Linn <John.Linn@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal, Arnd,

On Wed, Jul 1, 2009 at 9:34 PM, Michal Simek<monstr@monstr.eu> wrote:
> Added to next branch for test.
>
> I had to do one change.
> Microblaze needs __kernel_mode_t as short.
>
> + I removed __kernel_size_t and I'll recompile toolchain
> for removing warning messages

We need to be a little bit mindful here regarding which of the
asm-generic changes we merge immediately.

Ones that do not change the ABI at all, but simply pull from
asm-generic instead of asm-microblaze are obviously fine (identical
structures, bitfields etc).

However, we've just "broken" the ABI in 2.6.31, if we merge further
ABI breakage in 2.6.32 it's more pain and confusion.

So, unless we can merge and validate this ABI breakage during the
2.6.31-rc cycle, I think we need to hold on changes that would break
the ABI again, so soon.

Longer term there will be a complete redo of glibc up to the latest
version, which will obviously require a new toolchain for users - I
think that is the right place to do the next round of ABI breakage.

Any thoughts?

John
-- 
John Williams, PhD, B.Eng, B.IT
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663
