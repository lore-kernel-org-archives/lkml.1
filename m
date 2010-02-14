Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab0BNOTM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 09:19:12 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35600 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab0BNOTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 09:19:07 -0500
Date: Sun, 14 Feb 2010 15:19:06 +0100
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <petkovbb@googlemail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
Message-ID: <20100214141906.GA16715@aftab>
References: <4B6C93A2.1090302@zytor.com>
 <20100206093659.GA28326@aftab>
 <4B6E1DA3.50204@zytor.com>
 <20100208092845.GB12618@a1.tnic>
 <4B6FDAED.9060204@zytor.com>
 <20100208095945.GA14740@a1.tnic>
 <20100211172424.GB19779@aftab>
 <1266142343.5273.419.camel@laptop>
 <20100214112447.GA8353@liondog.tnic>
 <1266150215.5273.601.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266150215.5273.601.camel@laptop>
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

On Sun, Feb 14, 2010 at 01:23:35PM +0100, Peter Zijlstra wrote:
> On Sun, 2010-02-14 at 12:24 +0100, Borislav Petkov wrote:
> > 
> > So, if I understand you correctly, your suggestion might work, we
> > simply need to rename the lib/hweight.c versions to __sw_hweightN
> > and have <asm-generic/bitops/arch_hweight.h> have __arch_hweightN ->
> > __sw_hweightN wrappers in the default case, all arches which have an
> > optimized version will provide it in their respective bitops header...
> > 
> I'm not quite sure what the last 'it' refers to, does that refer to:
>  1) an __arch_hweightN() implementation, or
>  2) __arch_hweightN() -> __sw_hweightN() wrappers ?
> 
> If you meant 1, then yes.

Yes, I mean all architectures which have an optimized hweight will use
that optimized version in their __arch_hweightN while as a default
fallback for the remaining architectures we'll have __arch_hweightN() ->
__sw_hweightN() wrappers in <asm-generic/bitops/arch_hweight.h>.

-- 
Regards/Gruss,
Boris.

-
Advanced Micro Devices, Inc.
Operating Systems Research Center
