Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbZLaKga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbZLaKga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 05:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbZLaKga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 05:36:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:47563 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbZLaKg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 05:36:29 -0500
Date: Thu, 31 Dec 2009 08:36:09 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: record relocation offset
Message-ID: <20091231103609.GE2384@ghostprotocols.net>
References: <vxv6sfpjggfx6v68yv1eecrx.1262215615671@email.android.com>
 <1262216506.2749.254.camel@mulgrave.site>
 <4B3BE63B.70907@zytor.com>
 <20091231003046.GC2384@ghostprotocols.net>
 <4B3C13B0.6080600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3C13B0.6080600@cn.fujitsu.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 31, 2009 at 11:00:00AM +0800, Xiao Guangrong escreveu:
> Arnaldo Carvalho de Melo wrote:

> > Conclusion: at 'perf record' time store the address of a well know
> > symbol (_text) into the perf.data header. Later, at perf report time, if
> > using a vmlinux file, calculate the relocation by subtracting the same
> > well known symbol from the one stored in the header.

> > So no need for ioctl or boot stuff.

> I'm little confused, how to get the load symbol address?
> It's not a good way, if you get it from '/proc/kallsyms', we can't assume kernel
> has this file.

Well, then its just a matter of exposing _text as
/sys/kernel/sections/.text, as we already have for modules:

[acme@ana linux-2.6-tip]$ cat /sys/module/ipv6/sections/.text 
0xfa0c2000

Which matches

nf_conntrack_ipv6 17548 2 - Live 0xfa147000
ipv6 239420 32 ip6t_REJECT,nf_conntrack_ipv6, Live 0xfa0c2000
[acme@ana linux-2.6-tip]$

But even as a quick transational assist, we can look at kallsyms at
'perf record' time.

> > I'll do that tomorrow, if Xiao doesn't beats me to it :-)

> Of course, please do if you have a better way :-)

I meant, if you didn't write the patch first, while I was sleeping :-)

I'll work on it today after some coffee and errands.

Best Regards,

- Arnaldo
