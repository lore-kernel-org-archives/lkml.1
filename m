Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbZKPVcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbZKPVcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:32:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbZKPVcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:32:09 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:23988 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbZKPVcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:32:08 -0500
Subject: Re: [RFC] Block IO Controller V2 - some results
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
In-Reply-To: <20091116211412.GJ13235@redhat.com>
References: <1258404660.3533.150.camel@cail>
	 <20091116211412.GJ13235@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Nov 2009 16:32:15 -0500
Message-ID: <1258407135.3533.152.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-16 at 16:14 -0500, Vivek Goyal wrote:
> On Mon, Nov 16, 2009 at 03:51:00PM -0500, Alan D. Brunelle wrote:
> > Hi Vivek: 
> > 
> > I'm finding some things that don't quite seem right - executive
> > summary: 
> 
> Hi Alan,
> 
> Thanks a lot for such an extensive testing and test results. I am still
> digesting the results but I thought I will make a quick note about writes.
> This patchset works only for sync IO. If you are performing buffered
> writes then you will not see any service differentiation. Providing
> support for buffered write path is in TODO list. 

Ah, I thought you meant sync I/O versus async I/O. So do you mean that
the testing should use _direct_ I/O (bypassing the cache)? 

> 
> > 
> > o  I think the apportionment algorithm doesn't work consistently well
> > for writes.
> > 
> > o  I think there are problems with significant performance loss when
> > doing random I/Os.
> 
> This concerns me. I had a quick look and as per your results, even with
> group_idle=0 you are seeing this regression. I guess this might be coming
> from the fact that we idle on sync-noidle workload per group and that
> idling becomes significant as number of groups increase.
> 
> Thanks
> Vivek

