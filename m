Return-Path: <linux-kernel-owner+w=401wt.eu-S1759957AbYHUO7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957AbYHUO7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbYHUO7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:59:41 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54903 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbYHUO7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:59:40 -0400
Subject: Re: [Cbe-oss-dev] powerpc/cell/oprofile: fix mutex locking for
	spu-oprofile
From: Carl Love <cel@us.ibm.com>
To: michael@ellerman.id.au
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, oprofile-list@lists.sourceforge.net,
       cel <cel@linux.vnet.ibm.com>, cbe-oss-dev@ozlabs.org
In-Reply-To: <1219314010.7827.4.camel@localhost>
References: <1217620879.15667.145.camel@carll-linux-desktop>
	 <200808201519.19453.arnd@arndb.de>
	 <18604.60738.523963.886786@drongo.ozlabs.ibm.com>
	 <200808211014.42683.arnd@arndb.de>  <1219314010.7827.4.camel@localhost>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 07:58:58 -0700
Message-Id: <1219330738.6637.269.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-08-21 at 20:20 +1000, Michael Ellerman wrote:
> On Thu, 2008-08-21 at 10:14 +0200, Arnd Bergmann wrote:
> > On Thursday 21 August 2008, Paul Mackerras wrote:
> > > Arnd Bergmann writes:
> > > 
> > > > Paul, any chance we can still get this into 2.6.27?
> > > 
> > > Possibly.  We'll need a really good explanation for Linus as to why
> > > this is needed (what regression or serious bug this fixes) and why it
> > > is late.  Can you send me something explaining that?
> > 
> > The patch does not fix a regression, the spu-oprofile code basically never
> > worked. With the current code in Linux, samples in the profile buffer
> > can get corrupted because reader and writer to that buffer use different
> > locks for accessing it.
> 
> Actually for me it worked[1] a reasonable amount of the time, enough to
> be useful. So the spu-oprofile code has always been broken in this way,
> but it's not always fatal. So the patch doesn't fix a regression, but it
> fixes a serious user-visible bug, which makes it legit rc4 material
> IMHO.
> 
> [1] that was late last year, so possibly a kernel or two ago.

The bug came in the original OProfile SPU support that was put out about
2 years ago.  The way the code was there was a window in which you may
get corruption.  It was not until Jan 08 when we got the first report of
the bug from Michael and identified it.  Since then there have been
three or four more people who have hit and reported the bug.  I am
seeing the bug show up more frequently with the latest couple of weekly
SDK 3.1 kernels.  It would seem that the kernel may have changed such
that the timing is more likely to hit the bug.  For the Beta SDK 3.1
release the IVT team was not able to complete their OProfile testing due
to the bug. 
> 
> cheers
> 
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________ oprofile-list mailing list oprofile-list@lists.sourceforge.net https://lists.sourceforge.net/lists/listinfo/oprofile-list

