Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbXJ2LKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbXJ2LKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 07:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbXJ2LJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 07:09:57 -0400
Received: from web32614.mail.mud.yahoo.com ([68.142.207.241]:42440 "HELO
	web32614.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751821AbXJ2LJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 07:09:56 -0400
X-YMail-OSG: ibL5gj4VM1naZjPqpOZvjwGPznJEMGgup7U2.SOA0gYwnzeL
X-Mailer: YahooMailRC/814.06 YahooMailWebService/0.7.152
Date: Mon, 29 Oct 2007 04:09:56 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: 2.6.24-rc1: First impressions
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, wfg@mail.ustc.edu.cn,
       torvalds@linux-foundation.org, riel@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <213736.67377.qm@web32614.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----
> From: Ingo Molnar <mingo@elte.hu>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: spamtrap@knobisoft.de; linux-kernel@vger.kernel.org; a.p.zijlstra@chello.nl; wfg@mail.ustc.edu.cn; torvalds@linux-foundation.org; riel@redhat.com
> Sent: Friday, October 26, 2007 9:33:40 PM
> Subject: Re: 2.6.24-rc1: First impressions
> 
> 
> * Andrew Morton  wrote:
> 
> > > > dd1 - copy 16 GB from /dev/zero to local FS
> > > > dd1-dir - same, but using O_DIRECT for output
> > > > dd2/dd2-dir - copy 2x7.6 GB in parallel from /dev/zero to
> local
> 
 FS
> > > > dd3/dd3-dir - copy 3x5.2 GB in parallel from /dev/zero lo
> local
> 
 FS
> > > > net1 - copy 5.2 GB from NFS3 share to local FS
> > > > mix3 - copy 3x5.2 GB from /dev/zero to local disk and two
> NFS3
> 
 shares
> > > > 
> > > >  I did the numbers for 2.6.19.2, 2.6.22.6 and 2.6.24-rc1.
> All
> 
 units 
> > > >  are MB/sec.
> > > > 
> > > > test           2.6.19.2     2.6.22.6    2.6.24.-rc1
> > > > ----------------------------------------------------------------
> > > > dd1                  28           50             96
> > > > dd1-dir              88           88             86
> > > > dd2              2x16.5         2x11         2x44.5
> > > > dd2-dir            2x44         2x44           2x43
> > > > dd3               3x9.8        3x8.7           3x30
> > > > dd3-dir          3x29.5       3x29.5         3x28.5
> > > > net1              30-33        50-55          37-52
> > > > mix3              17/32        25/50         
> 96/35
> 
 (disk/combined-network)
> > > 
> > > wow, really nice results!
> > 
> > Those changes seem suspiciously large to me.  I wonder if
> there's
> 
 less 
> > physical IO happening during the timed run, and correspondingly more 
> > afterwards.
> 
> so a final 'sync' should be added to the test too, and the time
> it
> 
 takes 
> factored into the bandwidth numbers?
> 

 One of the reasons I do 15 GB transfers is to make sure that I am well above the possible page cache size. And of course I am doing a final sync to finish the runs :-) The sync is also running faster in 2.6.24-rc1.

 If I factor it in the results for dd1/dd3 are:

test                2.6.19.2        2.6.22.6    2.6.24-rc1
sync time       18sec            19sec      6sec
dd1                     27.5                 47.5        92
dd3                     3x9.1              3x8.5       3x29

So basically including the sync time make 2.6.24-rc1 even more promosing. Now, I know that my benchmarks numbers are crude and show only a very small aspect of system performance. But - it is an aspect I care about a lot. And those benchmarks match my use-case pretty good.

Cheers
Martin





