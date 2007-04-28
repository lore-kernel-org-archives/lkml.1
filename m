Return-Path: <linux-kernel-owner+w=401wt.eu-S932760AbXD1Fp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbXD1Fp4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 01:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932753AbXD1Fp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 01:45:56 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:40494 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561AbXD1Fpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 01:45:54 -0400
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Apr 2007 01:45:54 EDT
Date: Sat, 28 Apr 2007 07:45:52 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Bill Huey <billh@gnuppy.monkey.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Dilger <adilger@clusterfs.com>,
       Marat Buharov <marat.buharov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       Alex Tomas <alex@clusterfs.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
In-Reply-To: <Pine.LNX.4.64.0704280708500.9055@artax.karlin.mff.cuni.cz>
Message-ID: <Pine.LNX.4.64.0704280740010.16264@artax.karlin.mff.cuni.cz>
References: <1177660767.6567.41.camel@Homer.simpson.net>
 <20070427013350.d0d7ac38.akpm@linux-foundation.org>
 <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
 <alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>
 <20070427193130.GD5967@schatzie.adilger.int>
 <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org>
 <20070427201235.GA11170@gnuppy.monkey.org> <Pine.LNX.4.64.0704280708500.9055@artax.karlin.mff.cuni.cz>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Apr 2007, Mikulas Patocka wrote:

> On Fri, 27 Apr 2007, Bill Huey wrote:
> Hi
>
> SpadFS doesn't write to unallocated parts like log filesystems (LFS) or 
> phase tree filesystems (TUX2);

--- BTW, I don't think that writing to unallocated parts of disk is good 
idea. These filesystems have cool write benchmarks, but one subtle (and 
unbenchmarkable) problem:
They group files according to time when they were created and not 
according to directory hierarchy.
When the user has directory with project files and he edited different 
files at different times, normal filesystems will place the files near 
each other (so that "grep blabla *" is fast) and log-structured 
filesystems will scatter the files over the whole disk.

Mikulas
