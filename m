Return-Path: <linux-kernel-owner+w=401wt.eu-S1758371AbXHNLNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371AbXHNLNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 07:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756819AbXHNLN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 07:13:27 -0400
Received: from phunq.net ([64.81.85.152]:47871 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755094AbXHNLNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 07:13:24 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Block device throttling [Re: Distributed storage.]
Date: Tue, 14 Aug 2007 04:13:10 -0700
User-Agent: KMail/1.9.5
Cc: Jens Axboe <jens.axboe@oracle.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708130604.07154.phillips@phunq.net> <20070814084625.GA20265@2ka.mipt.ru>
In-Reply-To: <20070814084625.GA20265@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708140413.12530.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2007 01:46, Evgeniy Polyakov wrote:
> On Mon, Aug 13, 2007 at 06:04:06AM -0700, Daniel Phillips 
(phillips@phunq.net) wrote:
> > Perhaps you never worried about the resources that the device
> > mapper mapping function allocates to handle each bio and so did not
> > consider this hole significant.  These resources can be
> > significant, as is the case with ddsnap.  It is essential to close
> > that window through with the virtual device's queue limit may be
> > violated.  Not doing so will allow deadlock.
>
> This is not a bug, this is special kind of calculation - total limit
> is number of physical devices multiplied by theirs limits. It was
> done _on purpose_ to allow different device to have different limits
> (for example in distributed storage project it is possible to have
> both remote and local node in the same device, but local device
> should not have _any_ limit at all, but network one should).
>
> Virtual device essentially has _no_ limit. And that as done on
> purpose.

And it will not solve the deadlock problem in general.  (Maybe it works 
for your virtual device, but I wonder...)  If the virtual device 
allocates memory during generic_make_request then the memory needs to 
be throttled.

Regards,

Daniel
