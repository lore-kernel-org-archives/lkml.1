Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbZCPMq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbZCPMq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 08:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZCPMqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 08:46:48 -0400
Received: from bowden.ucwb.org.au ([203.122.237.119]:49044 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbZCPMqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 08:46:47 -0400
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
From: Kevin Shanahan <kmshanah@ucwb.org.au>
To: Avi Kivity <avi@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <49BE20B2.9070804@redhat.com>
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera>
	 <qm8_cedJGaP.A.-NH.CPCvJB@chimera>
	 <1237107837.27699.27.camel@kulgan.wumi.org.au>
	 <49BE20B2.9070804@redhat.com>
Content-Type: text/plain
Organization: UnitingCare Wesley Bowden
Date: Mon, 16 Mar 2009 23:16:35 +1030
Message-Id: <1237207595.4964.31.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-16 at 11:49 +0200, Avi Kivity wrote:
> Kevin Shanahan wrote:
> > On Sat, 2009-03-14 at 20:20 +0100, Rafael J. Wysocki wrote:
> >   
> >> This message has been generated automatically as a part of a report
> >> of regressions introduced between 2.6.27 and 2.6.28.
> >>
> >> The following bug entry is on the current list of known regressions
> >> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> >> be listed and let me know (either way).
> >>
> >> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12465
> >> Subject		: KVM guests stalling on 2.6.28 (bisected)
> >> Submitter	: Kevin Shanahan <kmshanah@ucwb.org.au>
> >> Date		: 2009-01-17 03:37 (57 days old)
> >> Handled-By	: Avi Kivity <avi@redhat.com>
> >>     
> >
> > No further updates since the last reminder.
> > The bug should still be listed.   
> 
> Does the bug reproduce if you use the acpi_pm clocksource in the guests?

In the guest being pinged? Yes, it still happens.

hermes-old:~# cat /sys/devices/system/clocksource/clocksource0/available_clocksource 
kvm-clock acpi_pm jiffies tsc 
hermes-old:~# cat /sys/devices/system/clocksource/clocksource0/current_clocksource 
acpi_pm

kmshanah@flexo:~$ ping -c 600 hermes-old

--- hermes-old.wumi.org.au ping statistics ---
600 packets transmitted, 600 received, 0% packet loss, time 599439ms
rtt min/avg/max/mdev = 0.131/723.197/9941.884/1569.918 ms, pipe 10

I had to reconfigure the guest kernel to make that clocksource
available. The way I had the guest kernel configured before, it only had
tsc and jiffies clocksources available. Unstable TSC was detected, so it
has been using jiffies until now.

Here's another test, using kvm-clock as the guest's clocksource:

hermes-old:~# cat /sys/devices/system/clocksource/clocksource0/current_clocksource 
kvm-clock

kmshanah@flexo:~$ ping -c 600 hermes-old

--- hermes-old.wumi.org.au ping statistics ---
600 packets transmitted, 600 received, 0% packet loss, time 599295ms
rtt min/avg/max/mdev = 0.131/1116.170/30840.411/4171.905 ms, pipe 31

Regards,
Kevin.


