Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbXB1Nfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbXB1Nfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 08:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932336AbXB1Nfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 08:35:30 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:39041 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344AbXB1Nf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 08:35:29 -0500
Date: Wed, 28 Feb 2007 14:34:58 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Benoit Boissinot <bboissin@gmail.com>
Cc: Xiaoning Ding <dingxn@cse.ohio-state.edu>, linux-kernel@vger.kernel.org
Subject: Re: a bug in AS scheduler?
Message-ID: <20070228133458.GC3733@kernel.dk>
References: <45E5038F.1090200@cse.ohio-state.edu> <20070228121040.GW3733@kernel.dk> <40f323d00702280525g3d898a9bm1297dc32b8f7fda2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40f323d00702280525g3d898a9bm1297dc32b8f7fda2@mail.gmail.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28 2007, Benoit Boissinot wrote:
> On 2/28/07, Jens Axboe <jens.axboe@oracle.com> wrote:
> >On Tue, Feb 27 2007, Xiaoning Ding wrote:
> >> Hi,
> >>
> >> I am reading the source code AS scheduler in 2.6.18(as-ioscheduler.c).
> >> In function as_close_req, variable delay is in millisecond, while
> >> ad->antic_expire is in jiffies. Doesn't the comparison of delay and
> >> ad->antic_expire make any problem?
> >> The related source code is quoted blow:
> >>
> >>       if (ad->antic_status == ANTIC_OFF || !ad->ioc_finished)
> >>               delay = 0;
> >>       else
> >>               delay = ((jiffies - ad->antic_start) * 1000) / HZ;
> >
> >antic_start is in jiffies, the difference is here multiplied by 1000 and
> >divided by HZ to turn it into msecs. so delay is in msecs.
> >
> I am pretty sure Xiaoning was talking about antic_expire, particularly
> this comparison:
> 
>     else if (delay <= 20 && delay <= ad->antic_expire)

Ah, I misread the name. That does look like a bug, antic_expire is in
jiffies.

-- 
Jens Axboe

