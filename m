Return-Path: <linux-kernel-owner+w=401wt.eu-S1751516Ab0AAJ2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab0AAJ2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 04:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813Ab0AAJ2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 04:28:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58630 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab0AAJ16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 04:27:58 -0500
Date: Fri, 1 Jan 2010 10:27:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: record relocation offset
Message-ID: <20100101092733.GA12203@elte.hu>
References: <vxv6sfpjggfx6v68yv1eecrx.1262215615671@email.android.com>
 <1262216506.2749.254.camel@mulgrave.site>
 <4B3BE63B.70907@zytor.com>
 <20091231003046.GC2384@ghostprotocols.net>
 <4B3C13B0.6080600@cn.fujitsu.com>
 <20091231103609.GE2384@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091231103609.GE2384@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 3.4
X-ELTE-SpamLevel: sss
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=3.4 required=5.9 tests=FH_DATE_PAST_20XX autolearn=no SpamAssassin version=3.2.5
	3.4 FH_DATE_PAST_20XX      The date is grossly in the future.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Em Thu, Dec 31, 2009 at 11:00:00AM +0800, Xiao Guangrong escreveu:
> > Arnaldo Carvalho de Melo wrote:
> 
> > > Conclusion: at 'perf record' time store the address of a well know
> > > symbol (_text) into the perf.data header. Later, at perf report time, if
> > > using a vmlinux file, calculate the relocation by subtracting the same
> > > well known symbol from the one stored in the header.
> 
> > > So no need for ioctl or boot stuff.
> 
> > I'm little confused, how to get the load symbol address?
> > It's not a good way, if you get it from '/proc/kallsyms', we can't assume kernel
> > has this file.
> 
> Well, then its just a matter of exposing _text as 
> /sys/kernel/sections/.text, as we already have for modules:
> 
> [acme@ana linux-2.6-tip]$ cat /sys/module/ipv6/sections/.text 
> 0xfa0c2000
> 
> Which matches
> 
> nf_conntrack_ipv6 17548 2 - Live 0xfa147000
> ipv6 239420 32 ip6t_REJECT,nf_conntrack_ipv6, Live 0xfa0c2000
> [acme@ana linux-2.6-tip]$

Yeah, that's a good idea and pretty complementary to the existing scheme for 
modules.

> But even as a quick transational assist, we can look at kallsyms at 'perf 
> record' time.

Yes, we should do that as a fallback mechanism.

(Initially this 'fallback' will be the primary method, until the 
sections/.text extension gets merged upstream.)

Thanks,

	Ingo
