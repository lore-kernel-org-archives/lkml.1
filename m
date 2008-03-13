Return-Path: <linux-kernel-owner+w=401wt.eu-S1752780AbYCMCdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbYCMCdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 22:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYCMCdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 22:33:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543AbYCMCdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 22:33:14 -0400
Date: Wed, 12 Mar 2008 19:32:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3-mm1 - BUG at system shutdown time
Message-Id: <20080312193230.da330ff7.akpm@linux-foundation.org>
In-Reply-To: <4351.1205374751@turing-police.cc.vt.edu>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
	<10815.1204862325@turing-police.cc.vt.edu>
	<20080312003227.a94580e8.akpm@linux-foundation.org>
	<4351.1205374751@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008 22:19:11 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Wed, 12 Mar 2008 00:32:27 PDT, Andrew Morton said:
> > On Thu, 06 Mar 2008 22:58:45 -0500 Valdis.Kletnieks@vt.edu wrote:
> > 
> > > On Tue, 04 Mar 2008 01:19:28 PST, Andrew Morton said:
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/
> 2.6.25-rc3-mm1/
> > > 
> > > Dell Latitude D820, x86_64, Core2 Duo T7200
> > > 
> > > 'shutdown -h' blows up at the very end. shutdown -r works OK.
> > 
> > Did rc5-mm1 fix this?
> 
> Nope, still blows up with exactly the same traceback.

ah.

> I may have to try again to figure out how to bisect the git-x86 tree - Ingo
> send me a pointer to his git-x86 cheat sheet, I looked at it but I couldn't
> figure out how to tell 'git bisect' that the starting good spot was "whatever
> corresponded to the git-x86 patch in 24-rc8-mm1" and bad was "25-rc3-mm1". I
> tried using the first commit ID listed in the patch, but that gave me this:
> 
> (looking at first few lines of the git-x86.patch in the 25-rc3-mm1 broken-out):
> 
> commit fa70e201463a7f3d86b995249e57a8e27b31b5f8
> Author: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
> Date:   Sun Feb 24 11:57:22 2008 +0100
> 
> but then:
> 
> % git bisect bad fa70e201463a7f3d86b995249e57a8e27b31b5f8
> fatal: Needed a single revision
> Bad rev input: fa70e201463a7f3d86b995249e57a8e27b31b5f8
> 
> And I didn't see any release tags in the x86 git tree that I could specify
> either.
> 
> (Once I get the good and bad markers set, it "should be easy" - I've managed
> to git-bisect through Linus's git tree before, but that was always easy
> because "bad" was HEAD and "good" had a nice v2.6.2mumble-rcN tag to specify...

Yes, it's all a bit mysterious.  I just look in the changelog, which was
pull edout of the git diff via various means.

See how
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/broken-out
starts with 5813a19cba5735b629cdeb156863dab814759128 and ends with
816543f9bf2fb77ff52083216a4537eb4e3058ec.  Use
5813a19cba5735b629cdeb156863dab814759128 as good and
816543f9bf2fb77ff52083216a4537eb4e3058ec as bad.

