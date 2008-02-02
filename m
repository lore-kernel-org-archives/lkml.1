Return-Path: <linux-kernel-owner+w=401wt.eu-S932659AbYBBAjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbYBBAjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763516AbYBBAiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:38:55 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58451 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763637AbYBBAiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:38:54 -0500
Date: Fri, 1 Feb 2008 18:38:52 -0600
From: Robin Holt <holt@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Andrea Arcangeli <andrea@qumranet.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/4] mmu_notifier: Callbacks to invalidate address
	ranges
Message-ID: <20080202003852.GB17211@sgi.com>
References: <20080201050439.009441434@sgi.com> <20080201050623.344041545@sgi.com> <20080201220952.GA3875@sgi.com> <Pine.LNX.4.64.0802011517430.20608@schroedinger.engr.sgi.com> <20080201233528.GE12099@sgi.com> <Pine.LNX.4.64.0802011602360.21158@schroedinger.engr.sgi.com> <20080202002145.GA17211@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202002145.GA17211@sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 06:21:45PM -0600, Robin Holt wrote:
> On Fri, Feb 01, 2008 at 04:05:08PM -0800, Christoph Lameter wrote:
> > Are you saying that you get the callback when transitioning from a read 
> > only to a read write pte on the *same* page?
> 
> I believe that is what we saw.  We have not put in any more debug
> information yet.  I will try to squeze it in this weekend.  Otherwise,
> I will probably have to wait until early Monday.

I hate it when I am confused.  I misunderstood what Dean had been saying.
After I looked at his test case and remembering his screen at the time
we were discussing, I am nearly positive that both the parent and child
were still running (no exec, no exit).  We would therefore have two refs
on the page and, yes, be changing the pte which would warrant the callout.
Now I really need to think this through more.  Sounds like a good thing
for Monday.

Thanks,
Robin
