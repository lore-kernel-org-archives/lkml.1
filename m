Return-Path: <linux-kernel-owner+w=401wt.eu-S1760390AbYBTDOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390AbYBTDOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 22:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbYBTDOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 22:14:15 -0500
Received: from n27.bullet.mail.mud.yahoo.com ([68.142.200.142]:38150 "HELO
	n27.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750699AbYBTDOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 22:14:14 -0500
X-Yahoo-Newman-Id: 412457.16803.bm@omp408.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Im7aq08kVywbHg3NJCeGFetmkEBGOPGFmsSOA47GKdn6Q6slS+GbDdqop9nLHoz/J5XhcGiTB4UF4oyy2HI2fyue7NGTVr4bt0p0W1VzwP58BuQ/3iLv89rprivIXDa0mJaiDRKuZh0WuZ7ecEgDNaXywj7Gqd6XvUBUcqZ3LVI=  ;
X-YMail-OSG: ZojRGwMVM1lk3cr9YpOpbOzT_sJBFOxeHJL8gyGq2fIB58x94uL0ISHy97TIdrU0ojdhESfbiQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Robin Holt <holt@sgi.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address ranges
Date: Wed, 20 Feb 2008 14:11:41 +1100
User-Agent: KMail/1.9.5
Cc: Andrea Arcangeli <andrea@qumranet.com>,
       Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
References: <20080215064859.384203497@sgi.com> <20080220010038.GQ7128@v2.random> <20080220030031.GC11364@sgi.com>
In-Reply-To: <20080220030031.GC11364@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802201411.42360.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2008 14:00, Robin Holt wrote:
> On Wed, Feb 20, 2008 at 02:00:38AM +0100, Andrea Arcangeli wrote:
> > On Wed, Feb 20, 2008 at 10:08:49AM +1100, Nick Piggin wrote:

> > > Also, how to you resolve the case where you are not allowed to sleep?
> > > I would have thought either you have to handle it, in which case nobody
> > > needs to sleep; or you can't handle it, in which case the code is
> > > broken.
> >
> > I also asked exactly this, glad you reasked this too.
>
> Currently, we BUG_ON having a PFN in our tables and not being able
> to sleep.  These are mappings which MPT has never supported in the past
> and XPMEM was already not allowing page faults for VMAs which are not
> anonymous so it should never happen.  If the file-backed operations can
> ever get changed to allow for sleeping and a customer has a need for it,
> we would need to change XPMEM to allow those types of faults to succeed.

Do you really want to be able to swap, or are you just interested
in keeping track of unmaps / prot changes?

