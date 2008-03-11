Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbYCKV4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbYCKV4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYCKV4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:56:14 -0400
Received: from gate.in-addr.de ([212.8.193.158]:40681 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753431AbYCKV4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:56:14 -0400
Date: Tue, 11 Mar 2008 22:56:01 +0100
From: Lars Marowsky-Bree <lmb@suse.de>
To: Daniel Phillips <phillips@phunq.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Grzegorz Kulewski <kangur@polcom.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080311215601.GM23784@marowsky-bree.de>
References: <200803092346.17556.phillips@phunq.net> <200803110414.40954.phillips@phunq.net> <20080311112329.GR1581@marowsky-bree.de> <200803110450.19390.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803110450.19390.phillips@phunq.net>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-03-11T03:50:18, Daniel Phillips <phillips@phunq.net> wrote:

> > as well. In fact, the most common reason for unorderly shutdowns are
> > kernel crashes, not power failures in my experience.
> What are you doing to your kernel?

I guess I'm being really vicious to them: I expose it to customers and
the real world.

My own servers also have uptimes of >400 days sometimes, and I wonder
what customers do to the poor things.

And yes, I'm not saying I don't see your point for specialised
deployments (filesystems which are easy to rebuild from scratch), but
transactional integrity is a requirement I'd rank really high on the
desirable list of features if I was you.

> > So "perfectly reliable if UPS power does not fail" seems a bit over the
> > top.
> It works for EMC :-)

Where they control the hardware and run a rather specialized OS as well,
not a general purpose system like Linux on "commodity" hardware ;-)

> In fact, replicating was one of the strategies I considered for this.
> But since it is a lot more work and will not perform as well as a
> simple sweep, I opted for the simple thing.  Which turned out to
> be pretty complex anyway.  You have to close all the same nasty
> races but with a considerably more complex base algorithm.  I think
> that better wait for version 2.0.

Ok, I see.

> By the way, I could use a hand debugging this thing.

I'm afraid with those properties it doesn't really meet my needs :-(

And, wouldn't a simpler way to achieve something similar not be to use
the plain Linux fs caching/buffers, just disabling forced write out
maybe via a mount option? This strikes me as similar to the effect I get
from remounting NFS (a)sync. Make the fs ignore fsync et al.

It would have the advantage of using all memory available for caching
and not otherwise requested, too. (And, of course, the downside of
making it hard to reserve cache space for a given fs explicitly, at
least now. But I'm sure the control group / container folks would love
that feature. ;-)



Regards,
    Lars

-- 
Teamlead Kernel, SuSE Labs, Research and Development
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

