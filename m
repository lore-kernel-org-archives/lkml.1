Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab0BQReP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 12:34:15 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34301 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab0BQReN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 12:34:13 -0500
Date: Wed, 17 Feb 2010 18:34:11 +0100
From: Borislav Petkov <bp@amd64.org>
To: Michal Marek <mmarek@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
Message-ID: <20100217173411.GD13429@aftab>
References: <20100208095945.GA14740@a1.tnic>
 <20100211172424.GB19779@aftab>
 <4B743F7D.3090605@zytor.com>
 <20100212170649.GC3114@aftab>
 <4B758FC0.1020600@zytor.com>
 <20100212174751.GD3114@aftab>
 <4B75A66A.70005@zytor.com>
 <4B7BF5D6.3030701@suse.cz>
 <20100217172040.GC13429@aftab>
 <4B7C27D8.9050408@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7C27D8.9050408@suse.cz>
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

On Wed, Feb 17, 2010 at 06:31:04PM +0100, Michal Marek wrote:
> On 17.2.2010 18:20, Borislav Petkov wrote:
> > On Wed, Feb 17, 2010 at 02:57:42PM +0100, Michal Marek wrote:
> >> On 12.2.2010 20:05, H. Peter Anvin wrote:
> >>> On 02/12/2010 09:47 AM, Borislav Petkov wrote:
> >>>>
> >>>> However, this is generic code and for the above to work we have to
> >>>> enforce x86-specific CFLAGS for it. What is the preferred way to do
> >>>> that?
> >>>>
> >>>
> >>> That's a question for Michal and the kbuild list.  Michal?
> >>
> >> (I was offline last week).
> >>
> >> The _preferred_ way probably is not to do it :), but otherwise you can
> >> set CFLAGS_hweight.o depending on CONFIG_X86(_32|_64), just like you do
> >> in arch/x86/lib/Makefile already.
> > 
> > Wouldn't it be better if we had something like ARCH_CFLAGS_hweight.o
> > which gets set in the arch Makefile instead?
> 
> We could, but is it worth it if there is only one potential user so far?
> IMO just put the condition to lib/Makefile now and if there turn out to
> be more cases like this, we can add support for ARCH_CFLAGS_foo.o then.

Ok, I'm fine with that too, thanks.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
