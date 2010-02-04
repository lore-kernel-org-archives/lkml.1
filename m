Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046Ab0BDPyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 10:54:13 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:52141 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932552Ab0BDPyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 10:54:10 -0500
Date: Thu, 4 Feb 2010 16:54:19 +0100
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
Message-ID: <20100204155419.GD32711@aftab>
References: <20100201124825.cc024f2a.akpm@linux-foundation.org>
 <20100203133951.GA24357@localhost>
 <20100203070825.e36b3932.akpm@linux-foundation.org>
 <1265210157.24455.646.camel@laptop>
 <20100203074251.e2caa3f3.akpm@linux-foundation.org>
 <20100203181425.GB1367@aftab>
 <1265222875.24455.1020.camel@laptop>
 <4B69D362.10608@zytor.com>
 <20100204151050.GC32711@aftab>
 <1265296432.22001.18.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265296432.22001.18.camel@laptop>
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

On Thu, Feb 04, 2010 at 04:13:52PM +0100, Peter Zijlstra wrote:
> hweight_long() isn't an arch primitive, only __arch_hweight{8,16,32,64}
> are.

Yeah, I'm still looking for the proper location. hweight_long() is the
generic version so do we want to do the

#ifndef __HAVE_ARCH_POPCNT
static inline unsigned long hweight_long(unsigned long w)
...

#endif

thing and define a x86-specific version?

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
