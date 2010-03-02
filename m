Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0CBO63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 09:58:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49357 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab0CBO62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 09:58:28 -0500
Subject: Re: [PATCH 1/5] Add ID and STREAM_ID to recorded event data
From: Peter Zijlstra <peterz@infradead.org>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: paulus@samba.org, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <71583fc64cb167adcdb0039b53b8bc76fed21f80.1267537676.git.ebmunson@us.ibm.com>
References: <cover.1267537676.git.ebmunson@us.ibm.com>
	 <71583fc64cb167adcdb0039b53b8bc76fed21f80.1267537676.git.ebmunson@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Mar 2010 15:58:25 +0100
Message-ID: <1267541905.25158.64.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 14:42 +0000, Eric B Munson wrote:
> Currently perf record does not write the ID or the STREAM_ID to disk
> for events.  This doesn't allow report to tell if an event stream contains
> one or more types of events.  This patch adds these two entries to the list
> of data that record will write to disk.
> 
> Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
> ---
>  tools/perf/builtin-record.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 771533c..35e4605 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -242,7 +242,8 @@ static void create_counter(int counter, int cpu, pid_t pid)
>  				  PERF_FORMAT_TOTAL_TIME_RUNNING |
>  				  PERF_FORMAT_ID;
>  
> -	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
> +	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID |
> +				   PERF_SAMPLE_ID | PERF_SAMPLE_STREAM_ID;
>  
>  	if (freq) {
>  		attr->sample_type	|= PERF_SAMPLE_PERIOD;

can we make this conditional on there being more than one event, that
saves a little space/time when recording

