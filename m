Return-Path: <linux-kernel-owner+w=401wt.eu-S1758428AbZATPvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbZATPvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 10:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755772AbZATPvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 10:51:36 -0500
Received: from bowden.ucwb.org.au ([203.122.237.119]:49094 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbZATPvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 10:51:35 -0500
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
From: Kevin Shanahan <kmshanah@ucwb.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       bugme-daemon@bugzilla.kernel.org
In-Reply-To: <20090120142515.GC10224@elte.hu>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
	 <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera>
	 <1232410363.4768.21.camel@kulgan.wumi.org.au>
	 <20090120113546.GA26571@elte.hu>
	 <1232455343.4895.4.camel@kulgan.wumi.org.au>
	 <20090120125652.GA1457@elte.hu>
	 <1232461380.4895.33.camel@kulgan.wumi.org.au>
	 <20090120142515.GC10224@elte.hu>
Content-Type: text/plain
Organization: UnitingCare Wesley Bowden
Date: Wed, 21 Jan 2009 02:21:26 +1030
Message-Id: <1232466686.4895.45.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 15:25 +0100, Ingo Molnar wrote:
> > I could run top, vmstat and cat /proc/sched_debug in a loop until the
> > problem occurs and then trim it. Something like:
> > 
> > while true; do
> >   date                                >> $FILE
> >   echo "-- top: --"                   >> $FILE
> >   top -H -c -b -d 1 -n 0.5            >> $FILE 2>/dev/null
> >   echo "-- vmstat: --"                >> $FILE
> >   vmstat                              >> $FILE 2>/dev/null
> >   echo "-- sched_debug #$i: --"       >> $FILE
> >   cat /proc/sched_debug               >> $FILE 2>/dev/null
> > done
> > 
> > That should take a snapshot every half second or so.
> 
> Yeah, that would be lovely. You dont even have to trim it much - just give 
> us a timestamp to look at for the delay incident. You might also want to 
> start the kvm session while the script is already running - that way we'll 
> get fresh statistics and see the whole thing.

I've uploaded the debug info here:
  http://disenchant.net/tmp/bug-12465/

Some interesting sections should be around these times:

  01:36:04 -> 01:36:27
  01:37:30 -> 01:37:42
  01:37:52 -> 01:37:56
  01:39:37 -> 01:39:40
  01:40:01 -> 01:40:14

The output from ping is there too so you can see how the delays usually
show up (e.g. in clusters). The large debug file runs from before I
launched the VMs, right through the ping test. The trimmed file just
cuts out everything before I started ping.

Regards,
Kevin.


