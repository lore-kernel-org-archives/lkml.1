Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbZCYXs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbZCYXs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 19:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbZCYXsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 19:48:15 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:36530 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbZCYXsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 19:48:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vfqeyhgJ6d5C5cRXQHXgFBNXYQ8DV6061o+wKTNAcJssuSk268w7P9jAuZe2G7QUn8
         csp8dJSrOWZ7wYQD5KsVYysX00ScUaCbSIVgl5LqsaThzQqwEAIDFC2la6cnCHoU1ptD
         +BAu0ABNMFtuCeRTwZD5y8/QAfi+XMB6VRnrA=
Date: Thu, 26 Mar 2009 00:48:07 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Cc: Avi Kivity <avi@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
Message-ID: <20090325234806.GO5932@nowhere>
References: <49BE20B2.9070804@redhat.com> <1237207595.4964.31.camel@kulgan.wumi.org.au> <20090316200736.GD8393@nowhere> <1237244137.4964.54.camel@kulgan.wumi.org.au> <20090318001955.GB5143@nowhere> <1237338986.4801.11.camel@kulgan.wumi.org.au> <1237411441.5211.5.camel@kulgan.wumi.org.au> <1237611639.4933.4.camel@kulgan.wumi.org.au> <20090324114409.GB6058@nowhere> <1238024432.8669.6.camel@kulgan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238024432.8669.6.camel@kulgan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 10:10:32AM +1030, Kevin Shanahan wrote:
> On Tue, 2009-03-24 at 12:44 +0100, Frederic Weisbecker wrote:
> > Sorry, I've been late to answer.
> > As I explained in my previous mail, you trace is only
> > a snapshot that happened in 10 msec.
> > 
> > I experimented different sizes for the ring buffer but even
> > a 1 second trace require 20 Mo of memory. And a so huge trace
> > would be impractical.
> > 
> > I think we should keep the trace filters we had previously.
> > If you don't minde, could you please retest against latest -tip
> > the following updated patch? Iadded the filters, fixed the python
> > subshell and also flushed the buffer more nicely according to
> > a recent feature in -tip:
> > 
> > echo > trace 
> > 
> > instead of switching to nop.
> > You will need to pull latest -tip again.
> 
> Ok, thanks for that. I'll get a new -tip kernel ready to test tonight.
> I'm not sure about the change to the python subshell though:
> 
> > while [ "$found" != "True" ]
> > do
> >         # Flush the previous buffer
> >         echo trace > $prefix/trace
> > 
> >         echo 1 > $prefix/tracing_enabled
> >         lat=$(ping -c 1 $addr | grep rtt | grep -Eo " [0-9]+.[0-9]+")
> >         echo 0 > $prefix/tracing_enabled
> > 
> > 	echo $lat
> > 	found=$(python -c "print float(str($lat).strip())")
> >         sleep 0.01
> > done
> 
> kmshanah@kulgan:~$ python -c "print float(str(1.234).strip())"
> 1.234
> 
> That's not going to evaluate to "True" at all is it? What happened to
> the test against the latency threshold value? Did you mean something
> like this?
> 
> kmshanah@kulgan:~$ python -c "print float(str(1.234).strip()) > 5000"
> False
> kmshanah@kulgan:~$ python -c "print float(str(5001.234).strip()) > 5000"
> True


Sorry. I guess I was a bit asleep.
It's a mistake. So you can restore how it was.

Thanks.

 
> Cheers,
> Kevin.
> 
> 

