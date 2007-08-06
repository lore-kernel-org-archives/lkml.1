Return-Path: <linux-kernel-owner+w=401wt.eu-S933657AbXHFTPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657AbXHFTPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760508AbXHFTP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:15:26 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:60466
	"EHLO moonbase.phunq.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758100AbXHFTPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:15:25 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
Date: Mon, 6 Aug 2007 12:15:16 -0700
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
References: <20070806102922.907530000@chello.nl> <200708061148.43870.phillips@phunq.net> <Pine.LNX.4.64.0708061150270.7603@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0708061150270.7603@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708061215.16427.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 August 2007 11:51, Christoph Lameter wrote:
> On Mon, 6 Aug 2007, Daniel Phillips wrote:
> > On Monday 06 August 2007 11:42, Christoph Lameter wrote:
> > > On Mon, 6 Aug 2007, Daniel Phillips wrote:
> > > > Currently your system likely would have died here, so ending up
> > > > with a reserve page temporarily on the wrong node is already an
> > > > improvement.
> > >
> > > The system would have died? Why?
> >
> > Because a block device may have deadlocked here, leaving the system
> > unable to clean dirty memory, or unable to load executables over
> > the network for example.
>
> So this is a locking problem that has not been taken care of?

A deadlock problem that we used to call memory recursion deadlock, aka: 
somebody in the vm writeout path needs to allocate memory, but there is 
no memory, so vm writeout stops forever.

Regards,

Daniel
