Return-Path: <linux-kernel-owner+w=401wt.eu-S932343AbYDUNex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbYDUNex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932163AbYDUN2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:28:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46661 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932961AbYDUN2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:28:03 -0400
Message-ID: <480C930D.3090706@zytor.com>
Date: Mon, 21 Apr 2008 09:13:49 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mitch Bradley <wmb@firmworks.com>
CC: Andres Salomon <dilinger@queued.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	<20080419031024.GC3503@nineveh.local>	<20080418202925.b18452c5.akpm@linux-foundation.org>	<20080419092544.378664a8@ephemeral>	<20080419133909.5aa6b63e@ephemeral>	<86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>	<480B321B.5020802@zytor.com> <20080420135948.61bdb4c9@ephemeral> <480B8E9F.8000701@firmworks.com> <480B95B4.5030203@zytor.com> <480C0C5B.2050403@firmworks.com> <480C7C4E.6070309@zytor.com>
In-Reply-To: <480C7C4E.6070309@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, stepping back a few steps, it's pretty clear that most of my 
objections aren't really an issue for Geode/OLPC; however, I *really* 
don't want others to pick it up as being "the" Open Firmware interface.

Within those constraints it makes sense to set up the PDEs in 
swapper_pg_dir and let them propagate using the normal mechanisms.

** This is assuming that your OF interface does not rely on a 1:1 
mapping of low memory being present at the time it makes a call.  If it 
*does*, then a separate page directory needs to be maintained for the OF 
class. **


Thus, I'm willing to accept this with these changes:

- Please name things specific to the interface (as opposed to Open 
Firmware in general, like the device tree) olpc_ofw or olpcfw, to denote 
that this is an OLPC-specific interface.  Thus, 
CONFIG_OLPC_OPEN_FIRMWARE or something along those lines.

- Make it explicit in Kconfig that OLPC_OPEN_FIRMWARE conflicts with 
X86_PAE, 64BIT, or X86_PAT.

- Change VMALLOC_END in include/asm-x86/pgtable_32.h so the kernel will 
know to avoid this virtual memory range.

- Add a memory region to arch/x86/mm/dump_tabletables.c.

	-hpa
