Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbZKQNLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbZKQNLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 08:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbZKQNK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 08:10:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbZKQNK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 08:10:59 -0500
Date: Tue, 17 Nov 2009 14:08:52 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Spencer Candland <spencer@bluehost.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH] fix granularity of task_u/stime(), v2
Message-ID: <20091117130851.GA3842@dhcp-lab-161.englab.brq.redhat.com>
References: <20091111121150.GA2549@dhcp-lab-161.englab.brq.redhat.com> <4AFB5019.7030901@jp.fujitsu.com> <4AFB77C2.8080705@jp.fujitsu.com> <2375c9f90911111855w20491a1er8d3400cf4e027855@mail.gmail.com> <4AFB8C21.6080404@jp.fujitsu.com> <4AFB9029.9000208@jp.fujitsu.com> <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com> <1258038038.4039.467.camel@laptop> <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com> <4B01A8DB.6090002@bluehost.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B01A8DB.6090002@bluehost.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 12:32:43PM -0700, Spencer Candland wrote:
> > seems you have more test cases for utime decreasing issues,
> > could you send links to me ? Somehow I could not find them 
> > by my own. Particularly test case used in development this commit
> > is interested:
> > 
> >   commit 49048622eae698e5c4ae61f7e71200f265ccc529
> >   Author: Balbir Singh <balbir@linux.vnet.ibm.com>
> >   Date:   Fri Sep 5 18:12:23 2008 +0200
> >     sched: fix process time monotonicity
> 
> I had originally noticed that in a production web server, so my test
> case was designed to mirror what I was seeing there, which was just
> running apache with worker mpm, and running a simple apache bench while
> watching the utime/stime of the apache children.  Unfortunately that
> method was not terribly reliable at reproducing the issue, which is why
> I felt it necessary to try to come up with a better test case this time
> around.

No wonder I could not find anything on google and in mailing list
archives :)

Seems issue reported then was exactly the same as reported now by
you. Looks like commit 49048622eae698e5c4ae61f7e71200f265ccc529 just
make probability of bug smaller and you did not note it until now.  

Could you please test this patch, if it solve all utime decrease
problems for you:

http://patchwork.kernel.org/patch/59795/

If you confirm it work, I think we should apply it. Otherwise
we need to go to propagate task_{u,s}time everywhere, which is not
(my) preferred solution.

Stanislaw
