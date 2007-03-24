Return-Path: <linux-kernel-owner+w=401wt.eu-S932787AbXCXStb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbXCXStb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 14:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932833AbXCXSta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 14:49:30 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:45043 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932787AbXCXSt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 14:49:29 -0400
From: Nikita Danilov <nikita@clusterfs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17925.29368.942606.691598@gargle.gargle.HOWL>
Date: Sat, 24 Mar 2007 21:49:28 +0300
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: Re: [rfc][patch] queued spinlocks (i386)
In-Reply-To: <20070324172959.GB542@elte.hu>
References: <20070323085910.GA11577@wotan.suse.de>
	<20070323100418.GA30740@elte.hu>
	<20070323103243.GE11577@wotan.suse.de>
	<17925.18904.820106.145029@gargle.gargle.HOWL>
	<20070324172959.GB542@elte.hu>
X-Mailer: VM 7.17 under 21.5 (patch 17) "chayote" (+CVS-20040321) XEmacs Lucid
X-SystemSpamProbe: GOOD 0.0000545 e97e24faf1f643fc1b1008a7a0fa6782
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:
 > 
 > * Nikita Danilov <nikita@clusterfs.com> wrote:
 > 
 > > Indeed, this technique is very well known. E.g., 
 > > http://citeseer.ist.psu.edu/anderson01sharedmemory.html has a whole 
 > > section (3. Local-spin Algorithms) on them, citing papers from the 
 > > 1990 onward.
 > 
 > that is a cool reference! So i'd suggest to do (redo?) the patch based 
 > on those concepts and that terminology and not use 'queued spinlocks' 

There is some old version:

http://namesys.com/pub/misc-patches/unsupported/extra/2004.02.04/p06-locallock.patch
http://namesys.com/pub/misc-patches/unsupported/extra/2004.02.04/p07-locallock-bkl.patch
http://namesys.com/pub/misc-patches/unsupported/extra/2004.02.04/p08-locallock-zone.patch

http://namesys.com/pub/misc-patches/unsupported/extra/2004.02.04/p0b-atomic_dec_and_locallock.patch
http://namesys.com/pub/misc-patches/unsupported/extra/2004.02.04/p0c-locallock-dcache.patch

This version retains original spin-lock interface (i.e., no additional
"queue link" pointer is passed to the locking function). As a result,
lock data structure contains an array of NR_CPU counters, so it's only
suitable for global statically allocated locks.

 > that are commonly associated with MS's stuff. And as a result the 
 > contended case would be optimized some more via local-spin algorithms. 
 > (which is not a key thing for us, but which would be nice to have 
 > nevertheless)
 > 
 > 	Ingo

Nikita.

