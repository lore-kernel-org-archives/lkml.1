Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323Ab0AUO4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab0AUO4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 09:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000Ab0AUO4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 09:56:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:39894 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751043Ab0AUO4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 09:56:16 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19+/B5lEGR+oI2z/BXt3jNv4v5lt3MNR7ju73QwO9
	RvPqcV501+uW4f
Subject: Re: perf top: losing events?
From: Mike Galbraith <efault@gmx.de>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100121144902.GA1244@ghostprotocols.net>
References: <1264052528.26323.13.camel@marge.simson.net>
	 <20100121122224.GA21083@ghostprotocols.net>
	 <1264084112.5933.6.camel@marge.simson.net>
	 <20100121144902.GA1244@ghostprotocols.net>
Content-Type: text/plain
Date: Thu, 21 Jan 2010 15:56:12 +0100
Message-Id: <1264085772.5979.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 12:49 -0200, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jan 21, 2010 at 03:28:32PM +0100, Mike Galbraith escreveu:
> > On Thu, 2010-01-21 at 10:22 -0200, Arnaldo Carvalho de Melo wrote:
> > 
> > > Can you check if this one helps? 
> > 
> > Made interrupt count correct, but symbols aren't mapped after the task
> > forks it seems.  At least, in event__preprocess_sample(), after
> > thread__find_addr_location(), al->map is NULL a LOT.
> 
> Try this one on top of the previous one:
> 
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 8b04988..2227b84 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -975,6 +975,10 @@ static int event__process(event_t *event, struct perf_session *session)
>  	case PERF_RECORD_MMAP:
>  		event__process_mmap(event, session);
>  		break;
> +	case PERF_RECORD_FORK:
> +	case PERF_RECORD_EXIT:
> +		event__process_task(event, session);
> +		break;
>  	default:
>  		break;
>  	}

Yup.  All better.

I figured that had to to be tied in from rummaging around earlier.

	-Mike

