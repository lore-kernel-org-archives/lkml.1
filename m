Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab0BRLv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 06:51:58 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53050 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757996Ab0BRLvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 06:51:55 -0500
Date: Thu, 18 Feb 2010 12:51:55 +0100
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
Message-ID: <20100218115155.GA20473@aftab>
References: <4B6FDAED.9060204@zytor.com>
 <20100208095945.GA14740@a1.tnic>
 <20100211172424.GB19779@aftab>
 <4B743F7D.3090605@zytor.com>
 <20100212170649.GC3114@aftab>
 <4B758FC0.1020600@zytor.com>
 <20100212174751.GD3114@aftab>
 <4B75A66A.70005@zytor.com>
 <4B7BF5D6.3030701@suse.cz>
 <1266490310.26719.185.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266490310.26719.185.camel@laptop>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 11:51:50AM +0100, Peter Zijlstra wrote:
> I guess one way to achieve that is to create a arch/x86/lib/hweight.c
> that includes lib/hweight.c and give the x86 one special compile flags
> and not build the lib on.

That's what I thought initially too but that won't fly because the
lib/hweight.c helpers have to be inlined into arch/x86/lib/hweight.c so
that gcc can take care of the clobbered registers. Otherwise, it just a
"call __sw_hweightXX" that gets issued into asm.


-- 
Regards/Gruss,
Boris.

-
Advanced Micro Devices, Inc.
Operating Systems Research Center
