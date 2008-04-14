Return-Path: <linux-kernel-owner+w=401wt.eu-S1759701AbYDNNlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701AbYDNNlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYDNNlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:41:00 -0400
Received: from web52505.mail.re2.yahoo.com ([206.190.48.188]:33636 "HELO
	web52505.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759357AbYDNNk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:40:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=F4zdRq2NN0zwC5upXHDSQdlqVtS+i6f0poR8saSYRKuDDFAjhw9aIThPHmQZk8mAPJqtceP2KNOL4unqK4bUmsWSGFi8BKQPUEFg5tsMT76FnHIBCMgQEIkTrcCpOCyi0r51HfgkgRRbIAL2U3TZM+lWilOhZAWlirX/vyq94L8=;
X-YMail-OSG: 32nL9gwVM1lFPZ1vFOWptsn_5Hi8dvFtukP2ZgPFYV2lJhmygwfgo.Rp9GnCYV7W0ojRqhCfIBBRygqMzRoDSAFR.eoAe11LOBfCSdxo4vGl7u6S3kVPV.n7u0cpE9W_kKwDWaJN7ucn0Hxl4oke7K3gMQ--
Date: Mon, 14 Apr 2008 06:40:57 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: AMD Quad Core clock problem?
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47FFD3F3.50107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <533265.33722.qm@web52505.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Chris Snook <csnook@redhat.com> wrote:

> Marc Perkel wrote:
> > --- Chris Snook <csnook@redhat.com> wrote:
> > 
> >> Marc Perkel wrote:
> >>> I was just wondering if there were any known
> >> issues
> >>> with AMD quad core phenom clock drift problems?
> >> I';m
> >>> running a 2.6.24 kernel and it's losing time. I
> >>> remember the first dual core AMD chips had a lot
> >> of
> >>> clock issues.
> >>>
> >>> If this is something new let me know what
> >> information
> >>> to check and post to this list.
> >> When reporting clock problems, please post dmesg.
> 
> >> This has all the 
> >> interesting timekeeping-related log messages from
> >> the kernel.  Please 
> >> also describe the drift quantitatively.
> >>
> >> -- Chris
> >>
> > 
> > OK - thanks Chris.
> > 
> > The drift is small. It loses a few seconds every
> hour.
> > And it might not be kernel related. I just
> remembered
> > the early dual core days when this took months to
> get
> > right. I'm running several dual core computers and
> the
> > only one drifting is the quad. All are running the
> > same OS and kernel.
> 
> With the older chips, each core had its own TSC,
> which caused 
> synchronization problems.  The Barcelona generation
> chips (including 
> your Phenom) have a constant frequency TSC on the
> northbridge, so they 
> should be immune to these problems.
> 
> If it's steadily losing a few seconds every hour,
> it's probably just 
> slightly mis-calibrated hardware.  ntp should fix
> this right up.  If the 
> drift is more extreme than ntp can correct for, or
> the drift keeps 
> changing, or time is jumping around, that is
> definitely something that 
> could be a bug.
> 
> > hpet clockevent registered
> > TSC calibrated against HPET
> > Marking TSC unstable due to TSCs unsynchronized
> 
> It's possible that in future kernels we'll be a few
> clock cycles more 
> accurate in calibrating this on Barcelona chips, but
> calibration is only 
> as good as the standard of comparison.  There will
> always be hardware 
> that's slightly off, so run ntp, or use a nightly
> ntpdate cronjob.  If 
> your time starts drifting drastically or jumping
> around, please yell 
> really loud.
> 
> -- Chris
> 

The chip I'm talking about is the Phenom chip. It's
the AMD 9600 and the MB is an ASUS M3A78-EMH.

Been toying with NTPD all weekend and the drift is
such that it's just barely out of the range of NTP to
correct it. Sometime if I sync the clock on startup it
will work for a while but always falls back to the
internal clock. I'm estimating it's losing 3-4 minutes
a day. I also verified that I have the latest bios.

It is possible that I have bad hardware but I doubt
it. I think I might go ahead and start a bug report on
this and see if this is just me or if anyone else is
having these kind of problems as well. Just wanted to
get a little feedback first to make sure I'm not doing
something stupid.


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
