Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbXJ2IaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbXJ2IaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 04:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbXJ2I34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 04:29:56 -0400
Received: from web32611.mail.mud.yahoo.com ([68.142.207.238]:43209 "HELO
	web32611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751581AbXJ2I3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 04:29:55 -0400
X-YMail-OSG: Pbr4zfUVM1nHeJbM3glvxegEASGcsmP5b5ShRGzHlhRVSPVN
X-Mailer: YahooMailRC/814.06 YahooMailWebService/0.7.152
Date: Mon, 29 Oct 2007 01:29:49 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: 2.6.24-rc1: First impressions
To: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, wfg@mail.ustc.edu.cn,
       torvalds@linux-foundation.org, riel@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <193426.68317.qm@web32611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----
> From: Andrew Morton <akpm@linux-foundation.org>
> To: Arjan van de Ven <arjan@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>; spamtrap@knobisoft.de; linux-kernel@vger.kernel.org; a.p.zijlstra@chello.nl; wfg@mail.ustc.edu.cn; torvalds@linux-foundation.org; riel@redhat.com
> Sent: Saturday, October 27, 2007 7:59:51 AM
> Subject: Re: 2.6.24-rc1: First impressions
> 
> On Fri, 26 Oct 2007 22:46:57 -0700 Arjan van de
> Ven
> 
  wrote:
> 
> > > > > dd1 - copy 16 GB from /dev/zero to local FS
> > > > > dd1-dir - same, but using O_DIRECT for output
> > > > > dd2/dd2-dir - copy 2x7.6 GB in parallel from /dev/zero to
> local
> 
 FS
> > > > > dd3/dd3-dir - copy 3x5.2 GB in parallel from /dev/zero lo
> local
> 
 FS
> > > > > net1 - copy 5.2 GB from NFS3 share to local FS
> > > > > mix3 - copy 3x5.2 GB from /dev/zero to local disk and two NFS3
> > > > > shares
> > > > > 
> > > > >  I did the numbers for 2.6.19.2, 2.6.22.6 and 2.6.24-rc1. All
> > > > > units are MB/sec.
> > > > > 
> > > > > test           2.6.19.2     2.6.22.6    2.6.24.-rc1
> > > >
> >
> 
 ----------------------------------------------------------------
> > > > > dd1                  28           50             96
> > > > > dd1-dir              88           88             86
> > > > > dd2              2x16.5         2x11         2x44.5
> > > > > dd2-dir            2x44         2x44           2x43
> > > > > dd3               3x9.8        3x8.7           3x30
> > > > > dd3-dir          3x29.5       3x29.5         3x28.5
> > > > > net1              30-33        50-55          37-52
> > > > > mix3              17/32        25/50          96/35
> > > > > (disk/combined-network)
> > > > 
> > > > wow, really nice results!
> > > 
> > > Those changes seem suspiciously large to me.  I wonder if
> there's
> 
 less
> > > physical IO happening during the timed run, and
> correspondingly
> 
 more
> > > afterwards.
> > > 
> > 
> > another option... this is ext2.. didn't the ext2 reservation
> stuff
> 
 get
> > merged into -rc1? for ext3 that gave a 4x or so speed boost (much
> > better sequential allocation pattern)
> > 
> 
> Yes, one would expect that to make a large difference in
> dd2/dd2-dir
> 
 and
> dd3/dd3-dir - but only on SMP.  On UP there's not enough concurrency
> in the fs block allocator for any damage to occur.
>

 Just for the record the test are done on  SMP.
 
> Reservations won't affect dd1 though, and that went faster too.
>

 This is the one result that surprised me most, as I did not really expect any big moves here. I am not complaining :-), but definitely it would be nice to understand the why.

Cheers
Martin
> 


