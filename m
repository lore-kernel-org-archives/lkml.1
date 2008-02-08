Return-Path: <linux-kernel-owner+w=401wt.eu-S934812AbYBHSlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934812AbYBHSlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760152AbYBHSl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:41:29 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:48775 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760119AbYBHSl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:41:28 -0500
Message-ID: <47ACA250.1010404@steeleye.com>
Date: Fri, 08 Feb 2008 13:41:20 -0500
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Swiftdove 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       nbd-general@lists.sourceforge.net, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/1] NBD: make nbd default to deadline I/O scheduler
References: <47AC87AE.9040408@steeleye.com>	<20080208093341.b4d02e22.randy.dunlap@oracle.com> <20080208101151.935b575c.akpm@linux-foundation.org>
In-Reply-To: <20080208101151.935b575c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 8 Feb 2008 09:33:41 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> On Fri, 08 Feb 2008 11:47:42 -0500 Paul Clements wrote:
>>
>>> There have been numerous reports of problems with nbd and cfq. Deadline 
>>> gives better performance for nbd, anyway, so let's use it by default.
> 
> Please define "problems".  If it's just "slowness" then we can live with
> that, but I'd hope that Jens is aware and that it's understood.
> 
> It it's "hangs" or "oopses" then we panic.

The two problems I have experienced (which may already be fixed):

1) nbd hangs with cfq on RHEL 5 (2.6.18) -- this may well have been fixed

There's a similar debian bug that has been filed as well:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=447638

2) nbd performs about 10% better (the last time I tested) with deadline 
vs. cfq (the overhead of cfq doesn't provide much advantage to nbd [not 
being a real disk], and you end up going through the I/O scheduler on 
the nbd server anyway, so it makes sense that deadline is better with nbd)

There have been posts to nbd-general mailing list about problems with 
cfq and nbd also.

--
Paul

