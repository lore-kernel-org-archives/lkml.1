Return-Path: <linux-kernel-owner+w=401wt.eu-S1761230AbYB2RNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761230AbYB2RNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbYB2RNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:13:14 -0500
Received: from hs-out-0708.google.com ([64.233.178.241]:12320 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbYB2RNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:13:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=E+Hs2yITktYS58FHtormUMIgWAADBADg7QzCynS6PLyjkFIg4MrRgWi6fqqEy6ZMPBZggOnye5VVRrKn9PWS9UAjDtlMSpgQtPfkdhSe4bsrIcOw8V7Ehye78c0DNM3h2OzBxRDEm4Xm0Qu0ZDG6BQh2+kkKgKE8tneCbHlI6kY=
Date: Fri, 29 Feb 2008 14:14:42 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: ray-lk@madrabbit.org, linux-kernel@vger.kernel.org
Subject: Re: Interactivity issue in 2.6.25-rc3
Message-ID: <20080229171442.GA5173@localhost.ift.unesp.br>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>, ray-lk@madrabbit.org,
	linux-kernel@vger.kernel.org
References: <20080228184407.GA7117@localhost.ift.unesp.br> <20080228191824.GA20019@elte.hu> <2c0942db0802281154y3176e847g8b9a4091df5cc8af@mail.gmail.com> <20080228210627.GA4337@localhost.ift.unesp.br> <20080229160408.GG27248@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229160408.GG27248@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 29.Feb'08 at 17:04:08 +0100, Ingo Molnar wrote:
> 
> (on-list)
> 
> * Carlos R. Mafra <crmafra2@gmail.com> wrote:
> 
> > Is it an scheduler anomaly if 'se.wait_max' is bigger than 40 msecs 
> > for _any_ of the processes which appear in the debug script log? In 
> > other words, is the scheduler mathematically build to not allow 
> > latencies higher than 40 msecs?
> 
> it is definitely an anomaly if it's bigger than 40 msecs if you clear 
> all stats via cfs-debug-info-clear.sh and the large latencies appear 
> after that. You can force it to go above 40 msecs if you run more than 
> say 40 CPU hogs in parallel, so it's not "mathematical", but you should 
> never see large latencies under normal workloads - and that includes 
> almost everything but "insanely high" workloads.

Thank you for the explanation! 

> and obviously, even if you only 'feel' long delays that's too an anomaly 
> by definition, no matter what the scripts say about it. It might even be 
> a scheduler anomaly as well: for example if the scheduler clock has an 
> anomaly - on which the delay statistics are based too.

But if the scripts say all 'se.wait_max' are < 40 msecs than it is
not CFS' fault, right? Even if it takes 3 seconds for a typed letter
to appear in the terminal?

> generally, latencytop gives a pretty good idea about where app delays 
> come from. (As a second-level mechanism, in sched-devel.git you can try 
> the latency tracer.)

Yeah, I must try latencytop to check for more things before sending
an email reporting possible problems. 

Thanks again!
