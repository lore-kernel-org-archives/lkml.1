Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbYCKLO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbYCKLO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 07:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbYCKLOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 07:14:52 -0400
Received: from phunq.net ([64.81.85.152]:33393 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750959AbYCKLOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 07:14:51 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Tue, 11 Mar 2008 03:14:40 -0800
User-Agent: KMail/1.9.5
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Grzegorz Kulewski <kangur@polcom.net>,
       linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <20080310093737.3c1e938a@core> <20080310210352.GJ1581@marowsky-bree.de>
In-Reply-To: <20080310210352.GJ1581@marowsky-bree.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803110414.40954.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

On Monday 10 March 2008 14:03, Lars Marowsky-Bree wrote:
> On 2008-03-10T09:37:37, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > Why - your chunks simply become a linked list in write barrier order.
> > Solve your bitmap sweep cost as well. As you are already making a copy
> > before going to backing store you don't have the internal consistency
> > problems of further writes during the I/O.
> 
> You get duplicated blocks though. But yes, I agree - write-backs to the
> disk must be ordered, other it's going to be too unreliable in practice.

I disagree with your claim of "too unreliable".  If the UPS power does
not fail before flushing completes, it is perfectly reliable.  Perhaps
you need a belt to go with your suspenders?

As I wrote earlier, you cannot have optimal writeback speed and ordering
at the same time.  I can see eventually implementing some kind of ordered
writeback mode where completion is signalled to the application before
writeback completes.  You then get to choose between fastest flush and
most paranoid ordering.  I guess everybody will choose fastest flush,
but I will be happy to accept your patch to see which they actually
choose.

> > Yes you may need to throttle in the specific case of having too many
> > copies of pages sitting in the queue - but surely that would be the set of
> > pages that are written but not yet committed from a previous store
> > barrier ?
> 
> You could switch from a journal like the above to a bitmap when this
> overrun occurs. (Typical problem in replication.) SteelEye holds a
> patent on that though, as far as I know.

If you think this is like replication then you have the wrong idea
about what is going on.  This is a cache consistency algorithm, not
a replication algorithm.

Regards,

Daniel
