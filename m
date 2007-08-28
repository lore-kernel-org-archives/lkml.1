Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbXH1Oma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbXH1Oma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 10:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbXH1OmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 10:42:19 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24780 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbXH1OmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 10:42:17 -0400
Date: Tue, 28 Aug 2007 07:40:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       Olaf Hering <olh@suse.de>, netdev@vger.kernel.org
Subject: Re: [-mm patch] make types.h usable for non-gcc C parsers
Message-Id: <20070828074033.4171b923.randy.dunlap@oracle.com>
In-Reply-To: <20070828084315.GB27022@uranus.ravnborg.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<46CC3B27.10604@googlemail.com>
	<20070827212743.GN4121@stusta.de>
	<20070828003704.deed71ae.akpm@linux-foundation.org>
	<20070828084315.GB27022@uranus.ravnborg.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007 10:43:15 +0200 Sam Ravnborg wrote:

> On Tue, Aug 28, 2007 at 12:37:04AM -0700, Andrew Morton wrote:
> > On Mon, 27 Aug 2007 23:27:43 +0200 Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > On Wed, Aug 22, 2007 at 03:33:27PM +0200, Gabriel C wrote:
> > > >...
> > > > WARNING: "div64_64" [net/netfilter/xt_connbytes.ko] has no CRC!
> > > >...
> > > 
> > > Patch below.
> > > 
> > > > Regards,
> > > > 
> > > > Gabriel
> > > 
> > > cu
> > > Adrian
> > > 
> > > 
> > > <--  snip  -->
> > > 
> > > 
> > > This patch makes the 64bit integers on 32bit architectures usable for
> > > all C parsers that know about "long long".
> > > 
> > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > > 
> > 
> > Given that this patch (hopefully) fixes a problem in the current net-2.6.24
> > tree, I'm inclined to slip it into mainline immediately.
> > 
> > But I'd like a better description, please.  Which "non-gcc parser" are we
> > talking about here?  Something under ./scripts/.  Well, please identify it,
> > and describe what the problem is, and how the proposed patch will address
> > it.
> > 
> > Let's cc Sam too, as I guess he's the guy whose code just broke.
> 
> If my analysis is correct then genksyms fails to produce a CRC for div64_64 because
> genksyms does not know the __extension__ keyword.
> And this patch just paper over the real bug wich is in genksyms - right?
> 
> So we should fix the root cause here.
> 
> Googeling I did not find a good description of where __extension__ can be
> used so I fail to see where in the parse.y file I shal add the keyword.
> I think __extension__ may be used both as a part of an expression AND
> as part of a typedef (as in this case) but I wonder if this is where it is limited
> to be used.
> I would like to have this sorted out so we do not do a half-backed solution,
> and the proposed patch as it just paper over the real bug is no good.

I found only one gcc manual page on __extension__:

http://gcc.gnu.org/onlinedocs/gcc-4.1.2/gcc/Alternate-Keywords.html#Alternate-Keywords

(also found for other gcc versions)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
