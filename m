Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbYCOVAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbYCOVAa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 17:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYCOVAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 17:00:18 -0400
Received: from 1wt.eu ([62.212.114.60]:2470 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbYCOVAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 17:00:17 -0400
Date: Sat, 15 Mar 2008 21:59:50 +0100
From: Willy Tarreau <w@1wt.eu>
To: Daniel Phillips <phillips@phunq.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080315205950.GA13012@1wt.eu>
References: <200803092346.17556.phillips@phunq.net> <200803122314.18244.phillips@phunq.net> <20080313132211.6af855b3@the-village.bc.nu> <200803131214.40321.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803131214.40321.phillips@phunq.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 11:14:39AM -0800, Daniel Phillips wrote:
> On Thursday 13 March 2008 06:22, Alan Cox wrote:
> > ...Ext3 cannot recover well from massive loss of intermediate
> > writes. It isn't a normal failure mode and there isn't sufficient fs
> > metadata robustness for this. A log structured backing store would deal
> > with that but all you apparently want to do is scream FUD at anyone who
> > doesn't agree with you.
> 
> Scream is an exaggeration, and FUD only applies to somebody who
> consistently overlooks the primary proposition in this design: that the
> battery backed power supply, computer hardware and Linux are reliable
> enough to entrust your data to them.  I say this is practical, you say
> it is impossible, I say FUD.
> 
> All you are proposing is that nobody can entrust their data to any
> hardware.  Good point.  There is no absolute reliability, only degrees
> of it.
> 
> Many raid controllers now have battery backed writeback cache, which
> is exactly the same reliability proposition as ramback, on a smaller
> scale.  Do you refuse to entrust your corporate data to such
> controllers?

RAID controllers do not have half a terabyte of RAM. Also, you are always
invited to choose between speed (write back) and reliability (write through).

Also, please note that the problem here is not related to the number of
nines of availability. This number only counts the ratio between uptime
and downtime. We're more facing a problem of MTBF, where the consequences
of a failure are hard to predict.

What I'm thinking about is that considering the fact that storage
technologies are moving towards SSD (and I think 2008 will be the
year of SSD), you should implement ordered writes (I've not said
write through) since there's no seek time on those devices. Thus
you will have the speed of RAM with the reliability of a properly
synced FS. If your system crashes once a week, it will not be a
problem anymore.

Willy

