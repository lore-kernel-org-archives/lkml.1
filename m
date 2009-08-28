Return-Path: <linux-kernel-owner+w=401wt.eu-S1752240AbZH1LXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbZH1LXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 07:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZH1LXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 07:23:10 -0400
Received: from lucidpixels.com ([75.144.35.66]:37985 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbZH1LXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 07:23:09 -0400
Date: Fri, 28 Aug 2009 07:23:11 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Christoph Hellwig <hch@infradead.org>
cc: Nikanth Karthikesan <knikanth@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Kernel 2.6.30.4 loop(..?) regression (& with/2.6.31-rc6)
In-Reply-To: <alpine.DEB.2.00.0908261728580.1594@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0908280720220.30806@p34.internal.lan>
References: <alpine.DEB.2.00.0908221044420.30321@p34.internal.lan> <20090822201558.GA17955@infradead.org> <alpine.DEB.2.00.0908221645440.20848@p34.internal.lan> <20090822205502.GA18904@infradead.org> <alpine.DEB.2.00.0908221659030.23463@p34.internal.lan>
 <20090823224504.GA19942@infradead.org> <alpine.DEB.2.00.0908240704130.9427@p34.internal.lan> <alpine.DEB.2.00.0908260949550.9396@p34.internal.lan> <20090826180234.GC14019@infradead.org> <alpine.DEB.2.00.0908261717001.1594@p34.internal.lan>
 <20090826212732.GA18124@infradead.org> <alpine.DEB.2.00.0908261728580.1594@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 26 Aug 2009, Justin Piszcz wrote:

>
>
> On Wed, 26 Aug 2009, Christoph Hellwig wrote:
>
>> On Wed, Aug 26, 2009 at 05:19:11PM -0400, Justin Piszcz wrote:
>>> For the root filesystem, on / type xfs (rw,noatime)
>>> For larger partitions (per the cryptoloop doc) the partition itself is
>>> setup via cryptoloop and then XFS ontop of that.  Nothing special.
>> 
>> Just to make sure we have all data here - you see the problem only
>> with loop devices backed by XFS, only with loop devices backed by
>> raw partitions or with both?
> Both.
>
>> 
>>>> Any way to trgiger it with just loop but not crypto, etc.
>>> Unfortunately not that I am aware of..  Would trying the kernel with the
>>> patch removed and mounted with -o nobarrier help to show us anything, or?
>> 
>> Actually, yes - seeing what happens if you run plain 2.6.30 or 2.6.31-rc
>> without the backout patch, but with -o nobarrier would be very
>> interesting.
>> 
> Will give it a try with 2.6.31-rc6 and mount all loop devices (both those 
> backed by XFS and raw partitions) with -o nobarrier to see if the problem 
> recurs.  So far though with that patch up until this next test, there were no 
> problems.
>
> Justin.
>
>

Hi,

So far:

$ uptime
  07:20:04 up 1 day, 13:49,  1 user,  load average: 0.07, 0.02, 0.06

Let's give it another 48-72 hours with -o nobarrier, so far, it has not 
recurred.

It still may happen; however, moving forward I was wondering..

If both '-o nobarrier' and the patch solves the issue, what is the next 
action that should be taken?  Update the documentation to always use
-o nobarrier for cryptoloop? Or get the patch reverted in mainline?

Justin.
