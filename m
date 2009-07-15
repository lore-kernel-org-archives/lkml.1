Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbZGOJVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbZGOJVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 05:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbZGOJVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 05:21:44 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57472 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbZGOJVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 05:21:43 -0400
Date: Wed, 15 Jul 2009 18:21:13 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: monstr@monstr.eu, Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>
Subject: Re: access_ok macor
Message-ID: <20090715092113.GA1863@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Arnd Bergmann <arnd@arndb.de>, monstr@monstr.eu,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	LTP <ltp-list@lists.sourceforge.net>
References: <4A5C8068.6020203@monstr.eu> <200907141843.05629.arnd@arndb.de> <4A5CB8B4.7050108@monstr.eu> <200907141913.21240.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907141913.21240.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 07:13:20PM +0200, Arnd Bergmann wrote:
> On Tuesday 14 July 2009, Michal Simek wrote:
> > when the code tried to read/write from unaligned address (and in cpu
> > is turn on unaligned exception) then is caused unaligned exception
> > and asm code assemble/return value which is on that unaligned
> > address. (Assemble it that read/write every byte separately). That
> > will be harder to prevent all this cases because unaligned exception
> > is in generic code.  What do you mean add __range_ok? Range checking
> > is ok. The problem is when in case get_user kernel try to load
> > unaligned addr - unaligned exception is perform and try to load that
> > value separately.  If that page is not there, page fault handler is
> > called and not find it, it is performed search from exception table
> > and that address is not there of course - because address in pc is
> > generic unaligned code. I think that handling this needs more code.
> > Maybe if the address with from unaligned exception handler (there are
> > some address which can caused it) and find out which aligned address
> > is there and find out proper fixup for it.  I think that this could
> > work.
> > 
> > What do you think?
> 
> I think the key point is that the kernel should never try an unaligned
> access. Other architectures already rely on this, so you can too.

No, other architectures used to rely on this, until it was no longer
possible to do so. See for example, nfs. Unaligned accesses by the kernel
must be handled by the architecture, unaligned accesses by userspace can
be optionally fixed up.
