Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbZDXIrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbZDXIrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 04:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZDXIq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 04:46:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41716 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbZDXIqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:46:55 -0400
Date: Fri, 24 Apr 2009 10:50:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Huang Ying <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] [3/4] x86: MCE: Improve mce_get_rip
Message-ID: <20090424085036.GJ13896@one.firstfloor.org>
References: <20090407506.675031434@firstfloor.org> <20090407150656.43E161D046D@basil.firstfloor.org> <49DC5D11.4060505@jp.fujitsu.com> <1240479833.6842.554.camel@yhuang-dev.sh.intel.com> <49F15922.5090704@jp.fujitsu.com> <1240554911.6842.880.camel@yhuang-dev.sh.intel.com> <49F16A38.1030306@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F16A38.1030306@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 04:28:56PM +0900, Hidetoshi Seto wrote:
> Huang Ying wrote:
> > On Fri, 2009-04-24 at 14:16 +0800, Hidetoshi Seto wrote:
> >> One question is: if (RIPV,EIPV) = (0,0), then is the IP on the stack
> >> really invalid value, or is it still point IP when MCE is generated?
> >> I suppose it is not invalid.  If a processor encounters MCE and if it
> >> is not sure what happened, then it will store the IP on the stack,
> >> indicating neither of flags.
> >>
> >> If this supposition is correct, the best way is pick the value on
> >> the stack unconditionally, and record valid flags together.
> > 
> > According to spec, the IP on stack can be not related to MCE if
> > (RIPV,EIPV) = (0,0). So it is meaningless to report them. If you report
> > them unconditionally, you just push the logic to user space or
> > administrator.
> 
> Sorry, I could not find good page in the spec (Intel64 and IA-32 ASDM)...
> Could you point one?
> 
> I believe that the IP with (RIPV,EIPV) = (1,0) is "not associated with the
> error" too, so is it meaningless to report the IP?

Historical background:

We used to not report RIP on EIPV=1 traditionally (back in 2004 or so
when I wrote that code). But because most x86s don't
set EIPVs and don't guarantee it's related the RIP was never reported.  

But a few people asked for reporting it anyways even with EIPV=0 because e.g. 
when you get a MCE on MMIO in a driver due to broken hardware the RIP tends to 
be still nearby or at the MMIO access. So you can see roughly what went wrong.
It just warns about this by adding the !INEXACT! marker.

> If you think so then correct fix is replacing RIPV check by EIPV check.

Nope.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
