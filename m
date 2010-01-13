Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147Ab0AMIrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab0AMIrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 03:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785Ab0AMIrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 03:47:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60276 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707Ab0AMIrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 03:47:16 -0500
Date: Wed, 13 Jan 2010 09:45:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Wenji Huang <wenji.huang@oracle.com>, John Kacur <jkacur@redhat.com>,
       linux-kernel@vger.kernel.org, acme@redhat.com
Subject: Re: [PATCH] perf: fix incorrect return value for else case
Message-ID: <20100113084540.GB24475@elte.hu>
References: <1261387359-1933-1-git-send-email-wenji.huang@oracle.com>
 <520f0cf10912210723j1ac91183n3d7970b96b95ef23@mail.gmail.com>
 <4B302070.5000905@oracle.com>
 <20091230221213.GH6322@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091230221213.GH6322@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, Dec 22, 2009 at 09:27:12AM +0800, Wenji Huang wrote:
> > John Kacur wrote:
> >> On Mon, Dec 21, 2009 at 10:22 AM, Wenji Huang <wenji.huang@oracle.com> wrote:
> >>> Return original cmd instead of adding prefix.
> >>>
> >>> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> >>> ---
> >>>  tools/perf/builtin-help.c |    2 +-
> >>>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>>
> >>> diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
> >>> index 9f810b1..ca77df5 100644
> >>> --- a/tools/perf/builtin-help.c
> >>> +++ b/tools/perf/builtin-help.c
> >>> @@ -317,7 +317,7 @@ static const char *cmd_to_page(const char *perf_cmd)
> >>>        else if (is_perf_command(perf_cmd))
> >>>                return prepend("perf-", perf_cmd);
> >>>        else
> >>> -               return prepend("perf-", perf_cmd);
> >>> +               return perf_cmd;
> >>>  }
> >>>
> >>>  static void setup_man_path(void)
> >>> --
> >>> 1.5.6
> >>
> >> Sorry - I believe we should NAK this patch.
> >> It would turn the following
> >>
> >> ./perf nonsuchcmd --help
> >> No manual entry for perf-nonsuchcmd
> >>
> >> into
> >>
> >> ./perf nonsuchcmd --help
> >> No manual entry for nonsuchcmd
> >>
> >> The former is correct, the name of the man page includes the prefix "perf-"
> >>
> >> NAK
> >>
> >> (cc-ing Frederic in case he sees it differently)
> 
> 
> I personally don't mind.
> Having either
> 
> 	./perf nonsuchcmd --help
> 	No manual entry for perf-nonsuchcmd
> or
> 
> 	./perf nonsuchcmd --help
> 	No manual entry for nonsuchcmd
> 
> both make sense for the user.
> 
> 
> >>
> > Thanks. Since we think the former is better, why not make
> > the code compact? Like,
> >
> > diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
> > index 9f810b1..65e2691 100644
> > --- a/tools/perf/builtin-help.c
> > +++ b/tools/perf/builtin-help.c
> > @@ -314,8 +314,6 @@ static const char *cmd_to_page(const char *perf_cmd)
> >                 return "perf";
> >         else if (!prefixcmp(perf_cmd, "perf"))
> >                 return perf_cmd;
> > -       else if (is_perf_command(perf_cmd))
> > -               return prepend("perf-", perf_cmd);
> >         else
> >                 return prepend("perf-", perf_cmd);
> >  }
> 
> 
> Agreed!
> Thanks.

if this looks good to everyone please re-send the patch with a changelog and 
with acks added.

Thanks,

	Ingo
