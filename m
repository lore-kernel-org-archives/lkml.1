Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbYACEdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbYACEdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 23:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbYACEc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 23:32:56 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:35163 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbYACEcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 23:32:55 -0500
Date: Thu, 3 Jan 2008 09:29:42 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, htejun@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, maneesh@linux.vnet.ibm.com,
       lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: 2.6.22-stable causes oomkiller to be invoked
Message-ID: <20080103035942.GB26166@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071215104434.GA26325@linux.vnet.ibm.com> <20071217045904.GB31386@linux.vnet.ibm.com> <Pine.LNX.4.64.0712171143280.12871@schroedinger.engr.sgi.com> <20071217120720.e078194b.akpm@linux-foundation.org> <Pine.LNX.4.64.0712171222470.29500@schroedinger.engr.sgi.com> <20071221044508.GA11996@linux.vnet.ibm.com> <Pine.LNX.4.64.0712261258050.16862@schroedinger.engr.sgi.com> <20071228101109.GB5083@linux.vnet.ibm.com> <Pine.LNX.4.64.0801021237330.21526@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0801021346580.3778@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801021346580.3778@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 01:54:12PM -0800, Christoph Lameter wrote:
> Just traced it again on my system: It is okay for the number of pages on 
> the quicklist to reach the high count that we see (although the 16 bit 
> limits are weird. You have around 4GB of memory in the system?). Up to 
> 1/16th of free memory of a node can be allocated for quicklists (this 
> allows the effective shutting down and restarting of large amounts of 
> processes)
> 
> The problem may be that this is run on a HIGHMEM system and the 
> calculation of allowable pages on the quicklists does not take into 
> account that highmem pages are not usable for quicklists (not sure about 
> ZONE_MOVABLE on i386. Maybe we need to take that into account as well?)
> 
> Here is a patch that removes the HIGHMEM portion from the calculation. 
> Does this change anything:
> 

Yep. This one hits it. I don't see the obvious signs of the oom
happening in the 5 mins I have run the script. I will let it run for
some more time.

Thanks!
-- 
regards,
Dhaval
