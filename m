Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbYIVEVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbYIVEVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 00:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbYIVEVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 00:21:14 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:32192 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084AbYIVEVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 00:21:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhYFAEy61kg7p+/x/2dsb2JhbACBXbJ8gWY
X-IronPort-AV: E=Sophos;i="4.32,444,1217773800"; 
   d="scan'208";a="197490103"
Message-ID: <48D71D0B.8000405@call-direct.com.au>
Date: Mon, 22 Sep 2008 14:20:27 +1000
From: Iwo Mergler <iwo@call-direct.com.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080302)
MIME-Version: 1.0
To: Meng Sun <meng.sun@sesca.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: More things for writing new CPU ports.
References: <48D0B629.7070401@sesca.com>
In-Reply-To: <48D0B629.7070401@sesca.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Meng Sun wrote:
> Hi all,
> 
> What should I do for implement Linux kernel on a new CPU and target
> board? I just read FAQ but it's just general information. Could you
> please tell me which documents(except CPU datasheets and target board
> documents) I should read?
> 
> Cheers,

That depends on what you mean by new CPU.

1) Your new CPU is an ASIC variant of an existing one. That is, it has a different
part number, but is based on a supported processor core, e.g. MIPS, ARM, etc.
In this case, you add a new board directory in arch/YourProc/. If the processor
architecture has ASIC variant support, use it to cover the stuff internal to the ASIC.

2) Your new CPU is an extension or modification of an existing processor core.
You have already updated GCC to support the extensions and now want kernel
support for the OS relevant ones.
In this case, you probably need to update the CPU common files files in arch/YourProc,
as well as create a board file for your target board.

3) You have designed a completely new processor core from scratch. You have
implemented support for this core in GNU binutils, GCC, etc. You have ported
a bootloader and now want Linux on your new system.
In this case, you create your own processor directory in arch/ and implement
the primitives, probably using an existing similar architecture as a template.
That directory is all yours, so you may decide using board or ASIC subdirectories.


In other words, the kernel is fairly modular and there is a good chance that you
new CPU is already 90% supported.

Kind regards,

Iwo

