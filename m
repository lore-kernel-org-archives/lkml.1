Return-Path: <linux-kernel-owner+w=401wt.eu-S934791AbXHGSPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934791AbXHGSPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 14:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758287AbXHGSO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 14:14:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40943 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756020AbXHGSO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 14:14:58 -0400
Date: Tue, 7 Aug 2007 11:14:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mel@skynet.ie (Mel Gorman)
Cc: Andi Kleen <ak@suse.de>, Lee.Schermerhorn@hp.com, clameter@sgi.com,
       kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Apply memory policies to top two highest zones when
 highest zone is ZONE_MOVABLE
Message-Id: <20070807111430.f35c03c0.akpm@linux-foundation.org>
In-Reply-To: <20070807165546.GA7603@skynet.ie>
References: <20070802172118.GD23133@skynet.ie>
	<200708040002.18167.ak@suse.de>
	<20070806121558.e1977ba5.akpm@linux-foundation.org>
	<200708062231.49247.ak@suse.de>
	<20070806215541.GC6142@skynet.ie>
	<20070806221252.aa1e9048.akpm@linux-foundation.org>
	<20070807165546.GA7603@skynet.ie>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2007 17:55:47 +0100 mel@skynet.ie (Mel Gorman) wrote:

> On (06/08/07 22:12), Andrew Morton didst pronounce:
> > On Mon, 6 Aug 2007 22:55:41 +0100 mel@skynet.ie (Mel Gorman) wrote:
> > 
> > > On (06/08/07 22:31), Andi Kleen didst pronounce:
> > > > 
> > > > > If correct, I would suggest merging the horrible hack for .23 then taking
> > > > > it out when we merge "grouping pages by mobility".  But what if we don't do
> > > > > that merge?
> > > > 
> > > > Or disable ZONE_MOVABLE until it is usable?
> > > 
> > > It's usable now. The issue with policies only occurs if the user specifies
> > > kernelcore= or movablecore= on the command-line. Your language suggests
> > > that you believe policies are not applied when ZONE_MOVABLE is configured
> > > at build-time.
> > 
> > So..  the problem which we're fixing here is only present when someone
> > use kernelcore=.  This is in fact an argument for _not_ merging the
> > horrible-hack.
> > 
> 
> It's even more constrained than that. It only applies to the MPOL_BIND
> policy when kernelcore= is specified. The other policies work the same
> as they ever did.

so.. should we forget about merging the horrible-hack?

