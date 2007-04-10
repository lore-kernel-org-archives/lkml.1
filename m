Return-Path: <linux-kernel-owner+w=401wt.eu-S1030428AbXDJGxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030428AbXDJGxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 02:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030389AbXDJGxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 02:53:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33189 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030428AbXDJGxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 02:53:51 -0400
Message-ID: <461B3472.5000705@garzik.org>
Date: Tue, 10 Apr 2007 02:53:38 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>	<4616CBF0.7090606@garzik.org>	<20070409172339.48d661d6.akpm@linux-foundation.org> <m1mz1hyryh.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1mz1hyryh.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> At 10 kernel threads per cpu there may be a little bloat but it isn't
> out of control.  It is mostly that we are observing the kernel as
> NR_CPUS approaches infinity.  4096 isn't infinity yet but it's easily
> a 1000 fold bigger then most people are used to :)


I disagree there is only a little bloat:  the current mechanism in place 
does not scale as NR_CPUS increases, as this thread demonstrates.

Beyond a certain point, on an 8-CPU box, it gets silly.  You certainly 
don't need eight kblockd threads or eight ata threads.

	Jeff


