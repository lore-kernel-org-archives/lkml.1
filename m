Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbZDFHhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbZDFHhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 03:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbZDFHho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 03:37:44 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:56719 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbZDFHhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 03:37:43 -0400
Date: Mon, 6 Apr 2009 08:22:07 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Jiri Pirko <jpirko@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, oleg@redhat.com,
       linux-mm@kvack.org, mingo@elte.hu
Subject: Re: [PATCH for -mm] getrusage: fill ru_maxrss value
In-Reply-To: <20090406091825.44F0.A69D9226@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0904060811300.22841@blonde.anvils>
References: <20090405084902.GA4411@psychotron.englab.brq.redhat.com>
 <Pine.LNX.4.64.0904051736210.23536@blonde.anvils> <20090406091825.44F0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009, KOSAKI Motohiro wrote:
> 
> > I'm worrying particularly about the fork/exec issue you highlight.
> > You're exemplary in providing your test programs, but there's a big
> > omission: you don't mention that the first test, "./getrusage -lc",
> > gives a very different result on Linux than you say it does on BSD -
> > you say the BSD fork line is "fork: self 0 children 0", whereas
> > I find my Linux fork line is "fork: self 102636 children 0".
> 
> FreeBSD update rusage at tick updating point. (I think all bsd do that)
> Then, bsd displaing 0 is bsd's problem :)

Ah, thank you.

> 
> Do I must change test program?

Apparently somebody needs to, please; though it appears to be already
well supplied with usleep(1)s - maybe they needed to be usleep(2)s?

And then change results shown in the changelog, and check conclusions
drawn from them (if BSD is behaving as we do, it should still show
maxrss not inherited over fork, but less obviously - the number goes
down slightly, because the history is lost, but nowhere near to zero).

Hugh
