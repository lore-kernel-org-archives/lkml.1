Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbXHNIrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbXHNIrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 04:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbXHNIrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 04:47:18 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:46775 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbXHNIrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 04:47:12 -0400
Date: Tue, 14 Aug 2007 12:46:25 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Daniel Phillips <phillips@phunq.net>
Cc: Jens Axboe <jens.axboe@oracle.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Block device throttling [Re: Distributed storage.]
Message-ID: <20070814084625.GA20265@2ka.mipt.ru>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708130418.03667.phillips@phunq.net> <20070813121802.GB5992@2ka.mipt.ru> <200708130604.07154.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708130604.07154.phillips@phunq.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 06:04:06AM -0700, Daniel Phillips (phillips@phunq.net) wrote:
> Perhaps you never worried about the resources that the device mapper 
> mapping function allocates to handle each bio and so did not consider 
> this hole significant.  These resources can be significant, as is the 
> case with ddsnap.  It is essential to close that window through with 
> the virtual device's queue limit may be violated.  Not doing so will 
> allow deadlock.

This is not a bug, this is special kind of calculation - total limit is
number of physical devices multiplied by theirs limits. It was done 
_on purpose_ to allow different device to have different limits (for 
example in distributed storage project it is possible to have both remote 
and local node in the same device, but local device should not have _any_
limit at all, but network one should).

Virtual device essentially has _no_ limit. And that as done on purpose.

-- 
	Evgeniy Polyakov
