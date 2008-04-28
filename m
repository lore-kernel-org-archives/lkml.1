Return-Path: <linux-kernel-owner+w=401wt.eu-S1765288AbYD1Chx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765288AbYD1Chx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 22:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbYD1Chp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 22:37:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:15084 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761305AbYD1Chp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 22:37:45 -0400
Date: Sun, 27 Apr 2008 19:31:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: werner <werner@copaya.yi.org>, linux-kernel@vger.kernel.org
Subject: Re: EDD problem -- regression -- crash on booting by probing EDD
Message-Id: <20080427193155.fb703973.randy.dunlap@oracle.com>
In-Reply-To: <20080426231704.GD22588@auslistsprd01.us.dell.com>
References: <20080422142103.GA5652@auslistsprd01.us.dell.com>
	<1208910044.20701@copaya.yi.org>
	<20080423083547.a048aaee.randy.dunlap@oracle.com>
	<20080426231704.GD22588@auslistsprd01.us.dell.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Apr 2008 18:17:04 -0500 Matt Domsch wrote:

> On Wed, Apr 23, 2008 at 08:35:47AM -0700, Randy Dunlap wrote:
> > On Tue, 22 Apr 2008 21:20:44 -0300 (GFT) werner wrote:
> > 
> > > As I tested yesterday extensively, the problem wasn't present at 2.6.24-rc5-git6 (SYS Linux 0.17 install DVD) nor at 2.6.24-rc6-git2 (SYS 0.19) ,  but at 2.6.24-rc6-git8 (SYS 0.20-rc1 and 0.20-rc2) and 2.6.25 (0.21-r3).
> > > 
> > > The whole compiled packages of these kernels still are at copaya.yi.org/tgz , but I extracted  the important parts, see enclosed here.    The .tar.bz2 file contains  the config  and the protocoll of the compilation (inclusive warning / error messages). 
> > > 
> > > As you can see, the diff between the config of 2.6.24-rc6-git2 and -git8 is nothing.  That means: THE ERROR ENTERED INTO THE KERNEL BETWEEN THESE TWO GITs !!      
> > 
> > Hi,
> > I'm a little confused.
> > 
> > Is this supposed to be "between 2.6.25-rc6-git2 and 2.6.25-rc6-git8"?
> > You say 2.6.24-rc6-git*.  I just want to make sure of which patch
> > interval we are looking at.
> 
> It's definitely .24 given the dates for the SYS releases he notes. The
> diffstat between the two is relatively short [1], but I can't see
> anything that can be related.  This code runs so early, during real
> mode startup, that my only suspects are:
> 
>  arch/x86/kernel/head_32.S                      |    2 +-
>  arch/x86/kernel/smpboot_64.c                   |    2 +-
>  include/asm-generic/tlb.h                      |    3 -
>  include/asm-x86/byteorder.h                    |    4 +-
>  include/asm-x86/msr.h                          |   74 +++++++++--------
> 
> 
> 
> [1] http://domsch.com/linux/edd-bug-2008-04-26.patch
> 
> but none of those are obviously the culprit to me...

Yeah, there are also some IDE changes in that -rc2..-rc8 range.
I'm wondering if any of them could interfere.

> Werner, the initcall_debug trace would be most helpful; without that
> I'm not sure how much progress we can make on this.

That should be helpful.

---
~Randy
