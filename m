Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbYCEPC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbYCEPC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 10:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYCEPCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 10:02:10 -0500
Received: from rn-out-0910.google.com ([64.233.170.191]:9589 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbYCEPCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 10:02:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gERBSoE71545uQw9OHasylTN87et1CVrZnKbcWexTxNimZh8hX4KmvGZPVyWOnDxk3dxOs6x8lIw2/cM/ZxRFDkZN9ddxFihd2H9yqPLJFoUcDEvTmdL3XH+fXyCsPZ+H6lfw2SDACw5WqmhG+K0HfBAHIGwtMmx3jRVs4vj6i0=
Message-ID: <cfd18e0f0803050702w57d22f5h2646a59be3337d1d@mail.gmail.com>
Date: Wed, 5 Mar 2008 16:02:04 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: SCHED_IDLE documentation
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Christoph Hellwig" <hch@lst.de>,
       cbe-oss-dev@ozlabs.org, "Jeremy Kerr" <jk@ozlabs.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <cfd18e0f0803030642m62cec927p80f1250fbe98afc6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203376368.275756.252634247263.1.gpush@pokey>
	 <200803030612.28039.arnd@arndb.de> <20080303051719.GA26102@lst.de>
	 <200803030721.52869.arnd@arndb.de> <20080303073311.GB5934@elte.hu>
	 <cfd18e0f0803030040l667dd2b7v6298e78c5b21bfec@mail.gmail.com>
	 <20080303092422.GA18281@elte.hu>
	 <cfd18e0f0803030431n69df391dw53843d5079d906dd@mail.gmail.com>
	 <20080303125227.GA22160@elte.hu>
	 <cfd18e0f0803030642m62cec927p80f1250fbe98afc6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 3:42 PM, Michael Kerrisk
<mtk.manpages@googlemail.com> wrote:
> Ingo,
>
>  One more thought while we're in this thread.  In my recent tests I
>  notice that the magnitude of the effect of nice values has changed
>  quite a lot in recent times.  For example, back in 2.6.18, two CPU
>  intensive processes would get the following shares of the CPU over 100
>  seconds of run time (here, three different examples of nice value
>  settings):
>
>  A nice  B nice  %A      %B
>  -20     -10     58.3    41.7
>  -20       0     89.2    10.8
>  -20     +19     99.7     0.3
>
>  In 2.6.25-rc2, we have:
>
>  A nice  B nice  %A      %B
>  -20     -10      90.5   9.5
>  -20       0      99.0   1.0
>  -20     +19     100.0   0.0
>
>  While I realise that nice values are not intended to guarantee any
>  particular degree of access to the CPU, these wide variations in the
>  effect of the nice value are surprising.  (For the 2.6.25-rc2 -20/+19
>  case, my test shows the low priority process is getting 0.000% of the
>  CPU -- i.e., < one thousandth of a percent.  In other words it is in
>  effect being totally starved of the CPU.)  Any comments?

Off list, Ingo pointed me at
Documentation/scheduler/sched-nice-design.txt which explains the
changes that took effect for nice values in 2.6.32.  I've added a
reference to that doc to the getpriority.2 page, and also added the
following text to NOTES on that page:

       The degree to which their relative nice value affects the
       scheduling  of processes varies across Unix systems, and,
       on Linux, across kernel versions.  Starting  with  kernel
       2.6.23,  Linux  adopted an algorithm that causes relative
       differences in  nice  values  to  have  a  much  stronger
       effect.   This causes very low nice values (+19) to truly
       provide little CPU to a process  whenever  there  is  any
       other  higher priority load on the system, and makes high
       nice values (-20) deliver most of the CPU to applications
       that require it (e.g., some audio applications).

I also tweaked my test program to deliver slightly more accurate info.
 With two CPU bound SCHED_OTHER processes, one at nice -20, the other
at nice+19, I found that the latter process is not _completely_
starved of the CPU: it gets about 0.006% of the CPU during a 5-minute
period..

Cheers,

Michael

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html
