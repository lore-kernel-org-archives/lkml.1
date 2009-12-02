Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbZLBI2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbZLBI2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:28:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZLBI2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:28:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54876 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbZLBI2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:28:08 -0500
Date: Wed, 2 Dec 2009 09:28:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] perf_event: fix compile error
Message-ID: <20091202082808.GA29866@elte.hu>
References: <4B162089.8000907@cn.fujitsu.com>
 <20091202081745.GD16218@elte.hu>
 <4B16239B.90205@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B16239B.90205@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> Ingo Molnar wrote:
> > * Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:
> > 
> >> cc1: warnings being treated as errors
> >> builtin-probe.c: In function ???cmd_probe???:
> >> builtin-probe.c:163: error: unused variable ???fd???
> >>
> >> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> >> ---
> >>  tools/perf/builtin-probe.c |    3 ++-
> >>  1 files changed, 2 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> >> index b5d15cf..64ea038 100644
> >> --- a/tools/perf/builtin-probe.c
> >> +++ b/tools/perf/builtin-probe.c
> >> @@ -160,7 +160,8 @@ static const struct option options[] = {
> >>  
> >>  int cmd_probe(int argc, const char **argv, const char *prefix __used)
> >>  {
> >> -	int i, j, fd, ret;
> >> +	int i, j, ret;
> >> +	int fd __used;
> >>  	struct probe_point *pp;
> > 
> > i think it's better to initialize it to -1 instead of turning off the 
> > warning.
> > 
> 
> Hi Ingo,
> 
> I have try this way but the error still exists :-(

ah - unused, not uninitialized.

Then the right fix is to use NO_LIBDWARF, not __used annotation. I've 
changed it to that and committed your fix - thanks!

	Ingo
