Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbZLaAbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbZLaAbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 19:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbZLaAbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 19:31:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46272 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZLaAbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 19:31:10 -0500
Date: Wed, 30 Dec 2009 22:30:46 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: record relocation offset
Message-ID: <20091231003046.GC2384@ghostprotocols.net>
References: <vxv6sfpjggfx6v68yv1eecrx.1262215615671@email.android.com>
 <1262216506.2749.254.camel@mulgrave.site>
 <4B3BE63B.70907@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3BE63B.70907@zytor.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 30, 2009 at 03:46:03PM -0800, H. Peter Anvin escreveu:
> On 12/30/2009 03:41 PM, James Bottomley wrote:
> > On Wed, 2009-12-30 at 15:26 -0800, H. Peter Anvin wrote:
> >> The statement that a _text-based relocation is insufficient is false.
> >> The entire x86-32 monolithic kernel is relocated as a unit.  The
> >> x86-64 kernel, too, is relocated as a unit, but using the page tables,
> >> which means it always runs at the compile-time-selected virtual
> >> address.
> > 
> > Confused now ... you just repeated what I said in the second paragraph,
> > but made it sound like you are disagreeing?
> 
> We might have a bit of a context mismatch.
> 
> The first I saw of this thread was a proposed patch that would give the
> relocation offset of the monolithic kernel, both on 32 and 64 bits,
> without any explanation of the usage model.  As such, from my point of
> view this has always been about the monolithic kernel, until your post
> mentioned modules (which the proposed patch would have done nothing about.)
> 
> The monolithic kernel offset is a single scalar constant; each module,
> of course, is completely different.

Conclusion: at 'perf record' time store the address of a well know
symbol (_text) into the perf.data header. Later, at perf report time, if
using a vmlinux file, calculate the relocation by subtracting the same
well known symbol from the one stored in the header.

So no need for ioctl or boot stuff.

I'll do that tomorrow, if Xiao doesn't beats me to it :-)

- Arnaldo
