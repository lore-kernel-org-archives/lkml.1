Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbYCME1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbYCME1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 00:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbYCME1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 00:27:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764AbYCME1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 00:27:22 -0400
Date: Wed, 12 Mar 2008 21:27:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3-mm1 - BUG at system shutdown time
Message-Id: <20080312212708.b970077c.akpm@linux-foundation.org>
In-Reply-To: <9373.1205380632@turing-police.cc.vt.edu>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
	<10815.1204862325@turing-police.cc.vt.edu>
	<20080312003227.a94580e8.akpm@linux-foundation.org>
	<4351.1205374751@turing-police.cc.vt.edu>
	<20080312193230.da330ff7.akpm@linux-foundation.org>
	<9373.1205380632@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008 23:57:12 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Wed, 12 Mar 2008 19:32:30 PDT, Andrew Morton said:
> 
> > Yes, it's all a bit mysterious.  I just look in the changelog, which was
> > pull edout of the git diff via various means.
> > 
> > See how
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/broken-out
> > starts with 5813a19cba5735b629cdeb156863dab814759128 and ends with
> > 816543f9bf2fb77ff52083216a4537eb4e3058ec.  Use
> > 5813a19cba5735b629cdeb156863dab814759128 as good and
> > 816543f9bf2fb77ff52083216a4537eb4e3058ec as bad.
> 
> I *hope* I'm mis-reading Ingo's directions when I cut-n-pasted them -
> first I pulled down the two trees, tried to bisect, had it give me the
> "need a single revision" error, then I checked out a tree - and got a
> *different* funky opaque error message when I tried to bisect:

Try this:

echo "git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git#for-akpm" > .git/branches/git-foo
git-fetch git-foo
git-checkout git-foo
git-bisect start
git-bisect good 968f7910e8d10e5273977248f3d89193b32e8c20
git-bisect bad c28550f4f68a894a3c05141762f388b5a14f33e3
