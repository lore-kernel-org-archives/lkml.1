Return-Path: <linux-kernel-owner+w=401wt.eu-S1763211AbYEBJa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763211AbYEBJa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 05:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbYEBJaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 05:30:14 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3243 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbYEBJaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 05:30:13 -0400
X-Greylist: delayed 625 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 May 2008 05:30:12 EDT
Subject: Re: huge gcc 4.1.{0,1} __weak problem
From: Miquel van Smoorenburg <miquels@cistron.nl>
To: Chris Knadle <Chris.Knadle@coredump.us>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       venkatesh.pallipadi@intel.com, davem@davemloft.net,
       trini@kernel.crashing.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
In-Reply-To: <20080501235558.GA20637@orac.ofobscurity.com>
References: <20080501235558.GA20637@orac.ofobscurity.com>
Content-Type: text/plain
Date: Fri, 02 May 2008 11:19:19 +0200
Message-Id: <1209719959.11360.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 19:55 -0400, Chris Knadle wrote:
> On Thu, 1 May 2008, Linus Torvalds wrote:
> > On Thu, 1 May 2008, Andrew Morton wrote:
> > > > 
> > > > I see only the following choices:
> > > > - remove __weak and replace all current usages
> > > > - move all __weak functions into own files, and ensure that also happens
> > > >   for future usages
> > > > - #error for gcc 4.1.{0,1}
> > > 
> > > Can we detect the {0,1}?  __GNUC_EVEN_MORE_MINOR__?
> >
> > It's __GNUC_PATCHLEVEL__, I believe.
> >
> > So yes, we can distinguish 4.1.2 (good, and very common) from 4.1.{0,1} 
> > (bad, and rather uncommon).
> > And yes, considering that 4.1.1 (and even more so 4.1.0) should be rare to 
> > begin with, I think it's better to just not support it.

>    Unfortunately Debian Stable (i.e. Etch), which is relatively popular for server 
> use, is still using 4.1.1  :-(  (The current gcc package is gcc-4.1.1-21)

Well the package version string is 4.1.1, but the compiler thinks it's
4.1.2, at least on i386, amd64 and ia64:

$ cc -v
gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)

A small test program agrees:

        printf("%d\n", __GNUC_PATCHLEVEL__);
$ ./a.out 
2

Mike.

