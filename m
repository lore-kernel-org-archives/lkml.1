Return-Path: <linux-kernel-owner+w=401wt.eu-S932367AbZHZLII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbZHZLII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757269AbZHZLIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:08:07 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50034 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048AbZHZLIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:08:06 -0400
Date: Wed, 26 Aug 2009 12:08:09 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yohan <kernel@yohan.staff.proxad.net>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: VM issue causing high CPU loads
Message-ID: <20090826110809.GG10955@csn.ul.ie>
References: <4A92A25A.4050608@yohan.staff.proxad.net> <20090824162155.ce323f08.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090824162155.ce323f08.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 04:21:55PM -0700, Andrew Morton wrote:
> On Mon, 24 Aug 2009 16:23:22 +0200
> Yohan <kernel@yohan.staff.proxad.net> wrote:
> 
> > Hi,
> > 
> >     Is someone have an idea for that :
> > 
> >         http://bugzilla.kernel.org/show_bug.cgi?id=14024
> > 
> 
> Please generate a kernel profile to work out where all the CPU tie is
> being spent.  Documentation/basic_profiling.txt is a starting point.
> 

In the absense of a profile, here is a total stab in the dark. Is this a
NUMA machine? If so, is /proc/sys/vm/zone_reclaim_mode set to 1 and does
setting it to 0 help?

This is based on a relatively recent bug where malloc() could stall for
long times with large amounts of CPU usage due to useless scanning in
page reclaim.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
