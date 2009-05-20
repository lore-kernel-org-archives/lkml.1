Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbZETLBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbZETLBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZETLBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:01:40 -0400
Received: from web32606.mail.mud.yahoo.com ([68.142.207.233]:35413 "HELO
	web32606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751126AbZETLBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:01:39 -0400
Message-ID: <678884.67843.qm@web32606.mail.mud.yahoo.com>
X-YMail-OSG: 1nYwXmUVM1kHLWqGKn2axA6m5wy7lYt9tS7xHjkT_XChdTDcngulgzqrNrf7G7zUoHO5.Pi0N8HGWF.1VGmoslPoAdfW3hDYacT3poq3qtHgr5tD5ydNCbs3oe56YUNypm4Nn3GlZxrydfA.UOgB_8s9rh0ZgnqrfOkgAP4PbsyXU5XHLfCwTxoPuIQ6wqJpY9Kf60AqGMX_9tP3cIhUb8rXuhN5O.iT
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.43 YahooMailWebService/0.7.289.10
Date: Wed, 20 May 2009 04:01:40 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
To: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@ZenIV.linux.org.uk,
       rjw@sisk.pl, linux-kernel@vger.kernel.org, tigran@aivazian.fsnet.co.uks,
       Kay Sievers <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       shemminger@vyatta.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Martin Knoblauch <knobi@knobisoft.de>
> To: Mike Galbraith <efault@gmx.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>; viro@ZenIV.linux.org.uk; rjw@sisk.pl; linux-kernel@vger.kernel.org; tigran@aivazian.fsnet.co.uks; Kay Sievers <kay.sievers@vrfy.org>; Rafael J. Wysocki <rjw@sisk.pl>; shemminger@vyatta.com
> Sent: Wednesday, May 20, 2009 12:22:28 PM
> Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
> 
> ----- Original Message ----
> 
> > From: Mike Galbraith 
> > To: Martin Knoblauch 
> > Cc: Andrew Morton ; viro@ZenIV.linux.org.uk; 
> rjw@sisk.pl; linux-kernel@vger.kernel.org; tigran@aivazian.fsnet.co.uk
> > Sent: Wednesday, May 6, 2009 10:37:45 AM
> > Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
> > 
> > On Wed, 2009-05-06 at 00:55 -0700, Martin Knoblauch wrote:
> > 
> > >  just to bring this back to my problem :-)
> > 
> > Good idea :-)
> > 
> > >  Last week I reported that the "new" sysfs entry in /proc/mounts already 
> comes 
> > out of initrd. Does this ring a bell?
> > > 
> > > http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/03048.html
> > 
> > Nope, no bells.
> > 
> > The only thing I can suggest is that you try a bisection.
> > 
> >     -Mike
> 
> OK, so I finally managed to bisect the issue down to the following commit. Not 
> much that I can say about it. Someone else suggested that it might all be a 
> question of timing. Might very well be. I will try it out on a system with a 
> different SCSI/RAID controller. The failing system has an "Smart Array 6i" 
> (cciss). "cciss", "ext3" and "jbd" are all modules coming from initrd.
> 
> |commit 1120f8b8169fb2cb51219d326892d963e762edb6
> |Author: Stephen Hemminger 
> |Date:   Thu Dec 18 09:17:16 2008 -0800
> |
> |    PCI: handle long delays in VPD access
> |
> |    Accessing the VPD area can take a long time.  The existing
> |    VPD access code fails consistently on my hardware. There are comments
> |
> |    Change the access routines to:
> |      * use a mutex rather than spinning with IRQ's disabled and lock held
> |      * have a much longer timeout
> |      * call cond_resched while spinning
> |
> |    Signed-off-by: Stephen Hemminger 
> |    Reviewed-by: Matthew Wilcox 
> |    Signed-off-by: Jesse Barnes 
> 


 yup. Different hardware (IBM x3650 with aacraid) does not show the problem. So it seems to be timing related. I more and more tend to view this as "so what" and go along.

Cheers
Martin

