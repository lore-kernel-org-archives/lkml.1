Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab0CCMRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 07:17:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:34058 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab0CCMRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 07:17:22 -0500
Subject: Re: [PATCH 1/5] Add ID and STREAM_ID to recorded event data
From: Peter Zijlstra <peterz@infradead.org>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: paulus@samba.org, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20100303120920.GA3502@us.ibm.com>
References: <cover.1267537676.git.ebmunson@us.ibm.com>
	 <71583fc64cb167adcdb0039b53b8bc76fed21f80.1267537676.git.ebmunson@us.ibm.com>
	 <1267541905.25158.64.camel@laptop>  <20100303120920.GA3502@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 13:17:19 +0100
Message-ID: <1267618639.25158.87.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 12:09 +0000, Eric B Munson wrote:
> On Tue, 02 Mar 2010, Peter Zijlstra wrote:
> 
> > On Tue, 2010-03-02 at 14:42 +0000, Eric B Munson wrote:
> > > Currently perf record does not write the ID or the STREAM_ID to disk
> > > for events.  This doesn't allow report to tell if an event stream contains
> > > one or more types of events.  This patch adds these two entries to the list
> > > of data that record will write to disk.
> > > 
> > > Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
> > > ---
> > >  tools/perf/builtin-record.c |    3 ++-
> > >  1 files changed, 2 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> > > index 771533c..35e4605 100644
> > > --- a/tools/perf/builtin-record.c
> > > +++ b/tools/perf/builtin-record.c
> > > @@ -242,7 +242,8 @@ static void create_counter(int counter, int cpu, pid_t pid)
> > >  				  PERF_FORMAT_TOTAL_TIME_RUNNING |
> > >  				  PERF_FORMAT_ID;
> > >  
> > > -	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
> > > +	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID |
> > > +				   PERF_SAMPLE_ID | PERF_SAMPLE_STREAM_ID;
> > >  
> > >  	if (freq) {
> > >  		attr->sample_type	|= PERF_SAMPLE_PERIOD;
> > 
> > can we make this conditional on there being more than one event, that
> > saves a little space/time when recording
> > 
> 
> The downside to this is report cannot print the name of the event being monitored
> if we do not record the sample and stream id.  This is as report behaves currently
> and if that is okay then I will put out V2 with that included today.

Well, if there's only one event, its clear what name to use, and if
there's more than one event, we will include the ID.

BTW, I think you can do without the STREAM_ID, since that is only used
to account throttled state iirc, and we don't actually do that.

