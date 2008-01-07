Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbYAGGyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbYAGGyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 01:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYAGGyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 01:54:16 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:29194 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751808AbYAGGyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 01:54:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GAdgI+GQxcaErFz6aqz+9qN4/ow5NG9sJAE7ub5OltJbcIFTqsRe+HqWke9XHLQhrMq6Tf6rYtYpZW16jl1C7TJQK6l2C83RMilNFkYLye3Dl7qeAEoM2peJoD3DcsaXEv+e+VA8XndAKI28/vnzeJMDsnv/EV0i2QNc58HrFdM=  ;
X-YMail-OSG: dcJX5IsVM1kfO6t5zztjvpR_iEfgFO.0cVaRcJ0hP.lBeXG_
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linda Walsh <lkml@tlinx.org>
Subject: Re: general config preemption Q: preempt-model and Big-Lock Preemption
Date: Mon, 7 Jan 2008 17:53:54 +1100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <477EF8A4.7010507@tlinx.org>
In-Reply-To: <477EF8A4.7010507@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801071753.54656.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 January 2008 14:25, Linda Walsh wrote:
> A question that comes to mind every time I go through the settings
> for "Preemption Model" and "Preempt The Big Kernel Lock".
>
> Do each of the combinations "make sense", or are some "no-ops"?
> For model, we have 1) no forced (server), 2) Voluntary (Desktop)
> 3) preemptible (low-latency Desktop), and for Big Lock Preemption (BLP),
> we have "yes" or "no".
>
> Questions:
>
> 1) What is the difference between "no forced" and "voluntary"?  Doesn't
>   voluntary normally mean "not forced"?

voluntary adds a few more cond_resched() points.


> 2) If a process is not preemptible, then it seems this would be "doubly
>   so" in the kernel when the big-lock is held.  So does the big-lock
>   preemption question have any effect (when preempt-model="no forced").

With BLP, AFAIK code may not assume preemption is disabled. Debug checks
should have caught any offenders by now.

When there is no kernel preemption, I guess BLP still allows contenders
to sleep and switch rather than spin, so it might improve throughput (or
harm it!).


> 3) If a process is "fully preemptible" but "BLP=false", is that
>   much different than "voluntary preemption" & BLP=false?  I.e. --
>   should 'preemptible kernel' also imply "BLP=true"...i.e.

Yeah, they're all slightly different I think, but it probably is too much
config options at this point in time. I think Ingo plans to make BLP the
default and remove the config option.
