Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbXIRIXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbXIRIXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 04:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbXIRIXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 04:23:05 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:35539 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbXIRIXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 04:23:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U4Xr6Tz5BXiNneDri/dJfch4ovHcL7UOL1P4v4+A9+og7O72jlfXU9ukt6AHi0/7vm5bGH0JElQl04DREaa9n9LLiAMyKJUK8AfWJ8SN7k4KxPXwra35igdp6PSnhdDjBWd/+B/PQPMDPztliJh8iy60h6McpRg6qJj02qwBJ+Y=
Message-ID: <6b8cef970709180123m1d3db874qc4b9bed1741479e2@mail.gmail.com>
Date: Tue, 18 Sep 2007 04:23:00 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Scheduler benchmarks - a follow-up
Cc: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
In-Reply-To: <20070918064046.GD5138@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6b8cef970709170221s4301e896x2ee123a149c05c3a@mail.gmail.com>
	 <20070917130524.GA10707@elte.hu> <20070917203607.GA20564@elte.hu>
	 <6b8cef970709172130v317a6c48h814ef5a1488f798e@mail.gmail.com>
	 <20070918064046.GD5138@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/18/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Rob Hussey <robjhussey@gmail.com> wrote:
>
> > A cursory glance suggests that performance wrt lat_ctx and hackbench
> > has increased (lower numbers), but degraded quite a lot for pipe-test.
> > The numbers for pipe-test are extremely stable though, while the
> > numbers for hackbench are more erratic (which isn't saying much since
> > the original numbers gave nearly a straight line). I'm still willing
> > to try out any more ideas.
>
> pipe-test is a very stable workload, and is thus quite sensitive to the
> associativity of the CPU cache. Even killing the task and repeating the
> same test isnt enough to get rid of the systematic skew that this can
> cause. I've seen divergence of up to 10% in pipe-test. One way to test
> it is to run pipe-test, then to stop it, then to "ssh localhost" (this
> in itself uses up a couple of pipe objects and file objects and changes
> the cache layout picture), then run pipe-test again, then again "ssh
> localhost", etc. Via this trick one can often see cache-layout
> artifacts. How much 'skew' does pipe-test have on your system if you try
> this manually?
>

I did 7 data sets of 5 runs each using this method. With pipe-test
bound to one sibling, there were 10 unique values in these 7 sets. The
lowest value was 9.22, the highest value was 9.62, and the median of
the unique values was 9.47. So the deviation from mean for the lowest
and highest values was {-0.25, 0.15} The numbers were even tighter for
pipe-test not bound to a single sibling: {-0.07, 0.12}
