Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbZHJH3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbZHJH3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 03:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZHJH3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 03:29:11 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:53066 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbZHJH3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 03:29:11 -0400
Message-ID: <4A7FCC42.40809@petalogix.com>
Date: Mon, 10 Aug 2009 09:29:06 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: microblaze-uclinux@itee.uq.edu.au
CC: John Linn <John.Linn@xilinx.com>, David DeBonis <david.debonis@xilinx.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [microblaze-uclinux] Rethinking MicroBlaze commandline precedence
References: <1d3f23370908092328l6e980f3ft2d5a8f8f37c26fcf@mail.gmail.com>
In-Reply-To: <1d3f23370908092328l6e980f3ft2d5a8f8f37c26fcf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

John Williams wrote:
> Hi,
> 
> Currently, MicroBlaze commandline handling in order of lowest to
> highest priority, looks like this:
> 
> 1. pointer in r5 from bootloader
> 2. CONFIG_CMDLINE=...
> 3. "chosen" section in DTS/DT
> 4. CONFIG_CMDLINE=... && CONFIG_CMDLINE_FORCE
> 
> I'm wondering if a cmdline in r5 should override the DTS.  My thinking
> is based on two observations:
> 
> (a) not everyone will use a bootloader like u-boot that can manipulate
> DTBs easily before kernel boot
> (b) a custom cmdline string in r5 allows the latest possible binding
> (runtime), where as the DTB is typically created at compile time.
> 
> So, how about this order instead:
> 
> 1. CONFIG_CMDLINE=...
> 2. "chosen" section in DTS/DT
> 3. pointer in r5 from bootloader
> 4. CONFIG_CMDLINE=... and CONFIG_CMDLINE_FORCE
> 
> Then, apart from CMDLINE_FORCE, the precedence goes from earliest
> binding (kernel build) to latest (runtime via bootloader/r5).
> 
> Thoughts?

I see there one big problem which can easily arise. Kernel expect that r5 points to
NULL string and DTS/DTB and CMDLINE will contain correct string. Kernel just copy it and use
it. There will be undefined behavior for more cases than for current handling. It will be
less error prune.

Ad observation a)

My expectation is that users will use s.....I.... format (I don't like that name - What about
renaming it?) with dtb - they setup commandline at once and they don't change it.

Ad observation b) - for final product they will use only one command line. For testing you can setup
kernel to use only r5.

I understand that you are trying to pass to kernel for example MTD map which could be possible but
IMHO better to do this in script which one with sed erase/comment/setup command line in DTS before
compilation.

Regards,
Michal


> 
> John

-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
