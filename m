Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbYA1EwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbYA1EwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 23:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbYA1Evz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 23:51:55 -0500
Received: from mx2.netapp.com ([216.240.18.37]:2730 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbYA1Evy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 23:51:54 -0500
X-IronPort-AV: E=Sophos;i="4.25,257,1199692800"; 
   d="scan'208";a="146719930"
Subject: Re: [PATCH] [8/18] BKL-removal: Remove BKL from remote_llseek
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Andi Kleen <ak@suse.de>
Cc: Steve French <smfrench@gmail.com>, swhiteho@redhat.com, sfrench@samba.org,
       vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <200801280538.25345.ak@suse.de>
References: <20080127317.043953000@suse.de> <200801280358.14024.ak@suse.de>
	 <1201493589.8132.7.camel@heimdal.trondhjem.org>
	 <200801280538.25345.ak@suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Sun, 27 Jan 2008 23:51:51 -0500
Message-Id: <1201495911.8132.18.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 28 Jan 2008 04:51:52.0706 (UTC) FILETIME=[8000DE20:01C86169]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-28 at 05:38 +0100, Andi Kleen wrote:
> On Monday 28 January 2008 05:13:09 Trond Myklebust wrote:
> > 
> > On Mon, 2008-01-28 at 03:58 +0100, Andi Kleen wrote:
> > > The problem is that it's not a race in who gets to do its thing first, but a 
> > > parallel reader can actually see a corrupted value from the two independent 
> > > words on 32bit (e.g. during a 4GB). And this could actually completely corrupt 
> > > f_pos when it happens with two racing relative seeks or read/write()s
> > > 
> > > I would consider that a bug.
> > 
> > I disagree. The corruption occurs because this isn't a situation that is
> > allowed by either POSIX or SUSv2/v3. Exactly what spec are you referring
> > to here?
> 
> No specific spec, just general quality of implementation. We normally don't have
> non thread safe system calls even if it was in theory allowed by some specification.

We've had the existing implementation for quite some time. The arguments
against changing it have been the same all along: if your application
wants to share files between threads, the portability argument implies
that you should either use pread/pwrite or use a mutex or some other
form of synchronisation primitive in order to ensure that
lseek()/read()/write() do not overlap.

Cheers
  Trond
