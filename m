Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbXJ0Fu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbXJ0Fu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 01:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbXJ0Fuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 01:50:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49149 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbXJ0Fuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 01:50:50 -0400
Date: Fri, 26 Oct 2007 22:46:57 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, spamtrap@knobisoft.de,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       wfg@mail.ustc.edu.cn, torvalds@linux-foundation.org, riel@redhat.com
Subject: Re: 2.6.24-rc1: First impressions
Message-ID: <20071026224657.11dcf950@laptopd505.fenrus.org>
In-Reply-To: <20071026122155.45ce72e7.akpm@linux-foundation.org>
References: <796505.25770.qm@web32612.mail.mud.yahoo.com>
	<20071026152221.GA26619@elte.hu>
	<20071026122155.45ce72e7.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 12:21:55 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 26 Oct 2007 17:22:21 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Martin Knoblauch <spamtrap@knobisoft.de> wrote:
> > 
> > > Hi ,
> > > 
> > >  just to give some feedback on 2.6.24-rc1. For some time I am
> > > tracking IO/writeback problems that hurt system responsiveness
> > > big-time. I tested Peters stuff together with Fenguangs additions
> > > and it looked promising. Therefore I was very happy to see Peters
> > > stuff going into 2.6.24 and waited eagerly for rc1. In short, I
> > > am impressed. This really looks good. IO throughput is great and
> > > I could not reproduce the responsiveness problems so far.
> > > 
> > >  Below are a some numbers of my brute-force I/O tests that I can
> > > use to bring responsiveness down. My platform is a HP/DL380g4,
> > > dual CPUs, HT-enabled, 8 GB Memory, SmartaArray6i controller with
> > > 4x72GB SCSI disks as RAID5 (battery protected writeback cahe
> > > enabled) and gigabit networking (tg3). User space is 64-bit
> > > RHEL4.3
> > > 
> > >  I am basically doing copies using "dd" with 1MB blocksize. Local 
> > >  Filesystem ist ext2 (noatime). IO-Scheduler is dealine, as it
> > > tends to give best results. NFS3 Server is a Sun/T2000/Solaris10.
> > > The tests are:
> > > 
> > > dd1 - copy 16 GB from /dev/zero to local FS
> > > dd1-dir - same, but using O_DIRECT for output
> > > dd2/dd2-dir - copy 2x7.6 GB in parallel from /dev/zero to local FS
> > > dd3/dd3-dir - copy 3x5.2 GB in parallel from /dev/zero lo local FS
> > > net1 - copy 5.2 GB from NFS3 share to local FS
> > > mix3 - copy 3x5.2 GB from /dev/zero to local disk and two NFS3
> > > shares
> > > 
> > >  I did the numbers for 2.6.19.2, 2.6.22.6 and 2.6.24-rc1. All
> > > units are MB/sec.
> > > 
> > > test           2.6.19.2     2.6.22.6    2.6.24.-rc1
> > > ----------------------------------------------------------------
> > > dd1                  28           50             96
> > > dd1-dir              88           88             86
> > > dd2              2x16.5         2x11         2x44.5
> > > dd2-dir            2x44         2x44           2x43
> > > dd3               3x9.8        3x8.7           3x30
> > > dd3-dir          3x29.5       3x29.5         3x28.5
> > > net1              30-33        50-55          37-52
> > > mix3              17/32        25/50          96/35
> > > (disk/combined-network)
> > 
> > wow, really nice results!
> 
> Those changes seem suspiciously large to me.  I wonder if there's less
> physical IO happening during the timed run, and correspondingly more
> afterwards.
> 

another option... this is ext2.. didn't the ext2 reservation stuff get
merged into -rc1? for ext3 that gave a 4x or so speed boost (much
better sequential allocation pattern)

(or maybe I'm just wrong)
