Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbXIYW3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbXIYW3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 18:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbXIYW3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 18:29:04 -0400
Received: from hpsmtp-eml11.kpnxchange.com ([213.75.38.111]:14575 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751893AbXIYW3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 18:29:03 -0400
From: Frans Pop <elendil@planet.nl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: ACPI suspend/hibernate tests (was: ACPI power off regression in 2.6.23-rc8)
Date: Wed, 26 Sep 2007 00:28:52 +0200
User-Agent: KMail/1.9.7
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Damien Wyart <damien.wyart@free.fr>, Len Brown <len.brown@intel.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>, linux-acpi@vger.kernel.org
References: <20070925065109.GA3080@localhost.localdomain> <200709252344.02894.elendil@planet.nl> <200709260018.01441.rjw@sisk.pl>
In-Reply-To: <200709260018.01441.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709260028.53535.elendil@planet.nl>
X-OriginalArrivalTime: 25 Sep 2007 22:28:53.0868 (UTC) FILETIME=[745372C0:01C7FFC3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 September 2007, Rafael J. Wysocki wrote:
> > I compiled kernels (i386) for my laptop (Toshiba Satellite A40) with:
> > A) PM + SUSPEND + HIBERNATION + ACPI
> > B) PM + SUSPEND + ACPI
> > C) PM + HIBERNATION + ACPI
> > D) PM + ACPI
> > E) PM + SUSPEND + HIBERNATION but _without_ ACPI
> > F) without PM
>
> Thanks a lot for testing this!

You're welcome. Until 2.6.20 or .21 s2ram never worked for me and even then 
sound did not work after resume. Now it seems to be supported perfectly, so 
my thanks to all of you!
Pity this laptop is slowly nearing end of life (3.5 years old, though still 
performing fine).

> > RESULTS
> > 	boot	s2ram	s2disk	off
> > A)	OK	OK	OK	OK
> > B)	OK	OK	N/A	OK
> > C)	OK	OK 1)	OK	OK
> > D)	OK 2)	OK 1)	N/A	OK
> > E)	OK 3)	N/A 4)	??? 5)	Only halted 6)
> > F)	OK	N/A	N/A	Only halted 6)
> >
> > Comments:
> > 1) sleep script ran, but laptop stayed on
> > 2) dmesg lists S0,S5 supported
> >    /proc/acpi/{sleep,wakeup} do not exist (is that correct?)
> > 3) /proc/acpi/{sleep,wakeup} do not exist; /sys/power/state only has
> > 'mem'
>
> Hm, this should be 'disk' ...
>
> >    so SUSPEND seems missing even though compiled in
>
> ... but it so follows from this comment.  Can you clarify, please?

Yes, my mistake. For E) /sys/power/state only has "disk", not "mem".

> I think that your results reflect the code pretty well, ie. no big
> surprises.

Great. That was what I was thinking. Thanks for confirming.
