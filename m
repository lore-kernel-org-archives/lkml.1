Return-Path: <linux-kernel-owner+w=401wt.eu-S1758400AbZJLV3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400AbZJLV3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758387AbZJLV3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:29:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34509 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758151AbZJLV27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:28:59 -0400
Date: Mon, 12 Oct 2009 23:28:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       David Rientjes <rientjes@google.com>,
       Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] oprofile: fix race condition in event_buffer free
Message-ID: <20091012212811.GD4589@elte.hu>
References: <20091009160532.GD638@erda.amd.com> <1255116810-26514-1-git-send-email-robert.richter@amd.com> <20091009195016.GH638@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009195016.GH638@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> On 09.10.09 21:33:29, Robert Richter wrote:
> > From: David Rientjes <rientjes@google.com>
> > 
> > Looking at the 2.6.31-rc9 code, it appears there is a race condition
> > in the event_buffer cleanup code path (shutdown). This could lead to
> > kernel panic as some CPUs may be operating on the event buffer AFTER
> > it has been freed. The attached patch solves the problem and makes
> > sure CPUs check if the buffer is not NULL before they access it as
> > some may have been spinning on the mutex while the buffer was being
> > freed.
> > 
> > The race may happen if the buffer is freed during pending reads. But
> > it is not clear why there are races in add_event_entry() since all
> > workqueues or handlers are canceled or flushed before the event buffer
> > is freed.
> > 
> > Signed-off-by: David Rientjes <rientjes@google.com>
> > Signed-off-by: Stephane Eranian <eranian@google.com>
> > Signed-off-by: Robert Richter <robert.richter@amd.com>
> 
> Ingo,
> 
> you can also pull the patches from here:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> 
> Thanks.

Pulled, thanks Robert!

	Ingo
