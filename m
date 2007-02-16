Return-Path: <linux-kernel-owner+w=401wt.eu-S932434AbXBPBao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbXBPBao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 20:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932438AbXBPBao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 20:30:44 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42318 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932434AbXBPBak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 20:30:40 -0500
Date: Thu, 15 Feb 2007 17:27:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Optimize generic get_unaligned / put_unaligned
 implementations.
Message-Id: <20070215172720.3e9ce464.akpm@linux-foundation.org>
In-Reply-To: <20070216004317.GA18987@linux-mips.org>
References: <20050830104056.GA4710@linux-mips.org>
	<20060306.203218.69025300.nemoto@toshiba-tops.co.jp>
	<20060306170552.0aab29c5.akpm@osdl.org>
	<20070214214226.GA17899@linux-mips.org>
	<20070214203903.8d013170.akpm@linux-foundation.org>
	<20070215143441.GA18155@linux-mips.org>
	<20070215135358.020781dd.akpm@linux-foundation.org>
	<20070215221839.GA14103@linux-mips.org>
	<20070215153823.239fd616.akpm@linux-foundation.org>
	<20070216004317.GA18987@linux-mips.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 00:43:17 +0000
Ralf Baechle <ralf@linux-mips.org> wrote:

> On Thu, Feb 15, 2007 at 03:38:23PM -0800, Andrew Morton wrote:
> 
> > hm.  So if I have
> > 
> > 	struct bar {
> > 		unsigned long b;
> > 	} __attribute__((packed));
> > 
> > 	struct foo {
> > 		unsigned long u;
> > 		struct bar b;
> > 	};
> > 
> > then the compiler can see that foo.b.b is well-aligned, regardless of the
> > packedness.
> > 
> > Plus some crazy people compile the kernel with icc (or at least they used
> > to).  What happens there?
> 
> A quick grep for __attribute__((packed)) and __packed find around 900 hits,
> I'd probably find more if I'd look for syntactical variations.  Some hits
> are in arch/{i386,x86_64,ia64}.  At a glance it seems hard to configure a
> useful x86 kernel that doesn't involve any packed attribute.  I take that
> as statistical proof that icc either has doesn't really work for building
> the kernel or groks packing.  Any compiler not implementing gcc extensions
> is lost at building the kernel but that's old news.
> 

No, icc surely supports attribute(packed).  My point is that we shouldn't
rely upon the gcc info file for this, because other compilers can (or
could) be used to build the kernel.

So it would be safer if the C spec said (or could be interpreted to say)
"members of packed structures are always copied bytewise".  So then we
can be reasonably confident that this change won't break the use of
those compilers.

But then, I don't even know if any C standard says anything about packing.

Ho hum.  Why are we talking about this, anyway?  Does the patch make the
code faster?  Or just nicer?
