Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbZETKWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbZETKWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 06:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbZETKW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 06:22:28 -0400
Received: from web32603.mail.mud.yahoo.com ([68.142.207.230]:23187 "HELO
	web32603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753013AbZETKW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 06:22:27 -0400
Message-ID: <461911.6351.qm@web32603.mail.mud.yahoo.com>
X-YMail-OSG: eU1JgoUVM1mcW.kig17beuLD.i_3bSuwS_INsB.1QBEFIRBOG9jJEoypZ0Rh7wkErmCFIruYZMEzunnp53Mrm_VWRkpkhhJzo41Nhs1JZGY2rOewHMbiopJrdu48PMu.0X.eAEfUimztkKBE_ZqRX5ntmtG12jKU.s4C2qYMAARvFXFNhtuRQxQE6F9EUe4ahjwR_RH20Ab6WA75pwG2yuB9q.GDzI1TLeFdEnYT0xusPek.XBvdXY4ZYKXy8RXcFo2kN0PieP5XHfq.YeisNx3v.znmAiJxeavJ7GWFdblM8NdFHWGdzvKTFMBvZBSQmKX5kJtD1q1HwbtztWwZnePB
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.43 YahooMailWebService/0.7.289.10
References: <409142.83316.qm@web32605.mail.mud.yahoo.com>  <20090428182837.62c51f26.akpm@linux-foundation.org>  <1240977096.5478.3.camel@marge.simson.net>  <20090429011755.c141c599.akpm@linux-foundation.org>  <20090429120827.GI8633@ZenIV.linux.org.uk>  <1241014725.15095.19.camel@marge.simson.net>  <20090505154911.e0309a4f.akpm@linux-foundation.org>  <1241585140.5196.28.camel@marge.simson.net>  <957194.27869.qm@web32605.mail.mud.yahoo.com> <1241599065.18090.18.camel@marge.simson.net>
Date: Wed, 20 May 2009 03:22:28 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
To: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@ZenIV.linux.org.uk,
       rjw@sisk.pl, linux-kernel@vger.kernel.org, tigran@aivazian.fsnet.co.uks,
       Kay Sievers <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       shemminger@vyatta.com
In-Reply-To: <1241599065.18090.18.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Mike Galbraith <efault@gmx.de>
> To: Martin Knoblauch <knobi@knobisoft.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>; viro@ZenIV.linux.org.uk; rjw@sisk.pl; linux-kernel@vger.kernel.org; tigran@aivazian.fsnet.co.uk
> Sent: Wednesday, May 6, 2009 10:37:45 AM
> Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
> 
> On Wed, 2009-05-06 at 00:55 -0700, Martin Knoblauch wrote:
> 
> >  just to bring this back to my problem :-)
> 
> Good idea :-)
> 
> >  Last week I reported that the "new" sysfs entry in /proc/mounts already comes 
> out of initrd. Does this ring a bell?
> > 
> > http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/03048.html
> 
> Nope, no bells.
> 
> The only thing I can suggest is that you try a bisection.
> 
>     -Mike

 OK, so I finally managed to bisect the issue down to the following commit. Not much that I can say about it. Someone else suggested that it might all be a question of timing. Might very well be. I will try it out on a system with a different SCSI/RAID controller. The failing system has an "Smart Array 6i" (cciss). "cciss", "ext3" and "jbd" are all modules coming from initrd.

|commit 1120f8b8169fb2cb51219d326892d963e762edb6
|Author: Stephen Hemminger <shemminger@vyatta.com>
|Date:   Thu Dec 18 09:17:16 2008 -0800
|
|    PCI: handle long delays in VPD access
|
|    Accessing the VPD area can take a long time.  The existing
|    VPD access code fails consistently on my hardware. There are comments
|
|    Change the access routines to:
|      * use a mutex rather than spinning with IRQ's disabled and lock held
|      * have a much longer timeout
|      * call cond_resched while spinning
|
|    Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
|    Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
|    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Cheers
Martin
