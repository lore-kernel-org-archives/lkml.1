Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbZKPWUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbZKPWUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbZKPWUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:20:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbZKPWUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:20:21 -0500
Date: Mon, 16 Nov 2009 17:18:27 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [RFC] Block IO Controller V2 - some results
Message-ID: <20091116221827.GL13235@redhat.com>
References: <1258404660.3533.150.camel@cail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258404660.3533.150.camel@cail>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 03:51:00PM -0500, Alan D. Brunelle wrote:

[..]
> ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
> 
> The next thing to look at is to see what the "penalty" is for the
> additional code: see how much bandwidth we lose for the capability
> added. Here we see the sum of the system's throughput for the various
> tests:
> 
> ---- ---- - ----------- ----------- ----------- ----------- 
> Mode RdWr N    base       ioc off   ioc no idle  ioc idle   
> ---- ---- - ----------- ----------- ----------- ----------- 
>  rnd   rd 2        17.3        17.1         9.4         9.1 
>  rnd   rd 4        27.1        27.1         8.1         8.2 
>  rnd   rd 8        37.1        37.1         6.8         7.1 
> 

Hi Alan,

This seems to be the most notable result in terms of performance degradation.

I ran two random readers on a locally attached SATA disk. There in fact
I gain in terms of performance because we perform less number of seeks
now as we allocate a continous slice to one group and then move onto
next group.

But in your setup it looks like there is a striped set of disks and seek
cost is less and waiting per group for sync-noidle workload is hurting
instead.

One simple way to test that would be to set slice_idle=0 so that CFQ does
not try to do any idling at all. Can you please re-run above test. This
will help in figuring out whether above performance regression is coming
from idling on sync-noidle workload group per cgroup or not.

Above numbers are in what units?

Thanks
Vivek
