Return-Path: <linux-kernel-owner+w=401wt.eu-S1032854AbXHMSjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032854AbXHMSjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1033084AbXHMSUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:20:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51156 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033030AbXHMSUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:20:11 -0400
Date: Tue, 14 Aug 2007 00:02:49 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Arjan van de Ven <arjan@infradead.org>
cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, Joe Perches <joe@perches.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -
 scripts/get_maintainer.pl
In-Reply-To: <1187026955.2688.4.camel@laptopd505.fenrus.org>
Message-ID: <alpine.LFD.0.999.0708132351320.29609@enigma.security.iitk.ac.in>
References: <1186984174.10249.7.camel@localhost>  <200708131933.10125.m.kozlowski@tuxland.pl>
 <1187026955.2688.4.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 13 Aug 2007, Arjan van de Ven wrote:

> 
> On Mon, 2007-08-13 at 19:33 +0200, Mariusz Kozlowski wrote:
> > Hello,
> > 
> > 	I don't recall discusion about this so here are my 3 cents:
> > 
> > 	I like the idea. 
> 
> I don't actually. It shows a central MAINTAINERS file is the wrong
> approach; just that 500+ patches to the same file were needed shows
> that. 
> 
> The maintainer info should be in the source file itself! That's the only
> reasonable way to keep it updated; now I'm all for having it machine
> parsable so that tools can use it, but it still really should be in the
> code itself, not in some central file that will always just go out of
> data, and will be a huge source of needless patch conflicts.

I second this thought (keeping MAINTAINERS info closer to code than in
a central kernel-global location), but have a differing opinion about the
implementation. Having MAINTAINERS-style annotations in all source files
sounds needlessly redundant. Worse still, I expect people will avoid adding
these annotations to all source files precisely for this reason, thus
someone editing drivers/xxx/foo.c would have no idea that the maintainer
info for this file is actually in drivers/xxx/bar.c.

Better solution is to have multiple MAINTAINERS files distributed in the
kernel tree, IMHO -- say a drivers/net/MAINTAINERS for maintainer info on
all various net drivers, drivers/kvm/MAINTAINERS for KVM maintainer info,
fs/ext3/MAINTAINERS for ext3 maintainers, fs/MAINTAINERS for generic VFS
maintainers info, so on and so forth. Of course, these individual
MAINTAINERS files could still have the newly-introduced "F:" fields as
well (drivers/net/MAINTAINERS would clearly require it, f.e.) ...


Satyam
