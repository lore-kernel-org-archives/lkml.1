Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbYCKLX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbYCKLX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 07:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYCKLXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 07:23:49 -0400
Received: from gate.in-addr.de ([212.8.193.158]:36639 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751148AbYCKLXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 07:23:48 -0400
Date: Tue, 11 Mar 2008 12:23:29 +0100
From: Lars Marowsky-Bree <lmb@suse.de>
To: Daniel Phillips <phillips@phunq.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Grzegorz Kulewski <kangur@polcom.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080311112329.GR1581@marowsky-bree.de>
References: <200803092346.17556.phillips@phunq.net> <20080310093737.3c1e938a@core> <20080310210352.GJ1581@marowsky-bree.de> <200803110414.40954.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803110414.40954.phillips@phunq.net>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-03-11T03:14:40, Daniel Phillips <phillips@phunq.net> wrote:

> > You get duplicated blocks though. But yes, I agree - write-backs to the
> > disk must be ordered, other it's going to be too unreliable in practice.
> I disagree with your claim of "too unreliable".  If the UPS power does
> not fail before flushing completes, it is perfectly reliable.  Perhaps
> you need a belt to go with your suspenders?

Daniel, I'm not saying you don't have a good thing here. Just that for
backing large filesystems, the risk of having to run a full fsck and
finding inconsistent metadata is pretty serious.

If I always assume a reliable shutdown - UPS protected, no crashes, etc
- you're right, but at least my real world has other failure scenarios
as well. In fact, the most common reason for unorderly shutdowns are
kernel crashes, not power failures in my experience.

So "perfectly reliable if UPS power does not fail" seems a bit over the
top.

> As I wrote earlier, you cannot have optimal writeback speed and ordering
> at the same time. 

No disagreement here. The question would be how large the performance
difference is.

> I can see eventually implementing some kind of ordered
> writeback mode where completion is signalled to the application before
> writeback completes.  You then get to choose between fastest flush and
> most paranoid ordering.  I guess everybody will choose fastest flush,
> but I will be happy to accept your patch to see which they actually
> choose.

I was trying to prod you into writing the ordered flushing. Maybe
claiming it is too hard will do the trick? ;-)

Seriously, I guess it depends on the workload you want to host.

> > > Yes you may need to throttle in the specific case of having too many
> > > copies of pages sitting in the queue - but surely that would be the set of
> > > pages that are written but not yet committed from a previous store
> > > barrier ?
> > You could switch from a journal like the above to a bitmap when this
> > overrun occurs. (Typical problem in replication.) SteelEye holds a
> > patent on that though, as far as I know.
> If you think this is like replication then you have the wrong idea
> about what is going on.  This is a cache consistency algorithm, not
> a replication algorithm.

I see the differences, but I also see the similarities. What you're
doing can also be thought of as replicating from an instant IO store
(local memory) to a high latency, low bandwidth copy (the disk)
asynchronously.

Both obviously need to preserve consistency, the question is whether to
achieve transactional (ordered) consistency or not.



Regards,
    Lars

-- 
Teamlead Kernel, SuSE Labs, Research and Development
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

