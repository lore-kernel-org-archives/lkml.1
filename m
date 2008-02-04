Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbYBDVqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbYBDVqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbYBDVqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:46:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:42887 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463AbYBDVqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:46:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,304,1199692800"; 
   d="scan'208";a="295737753"
Message-ID: <47A78797.8060601@linux.intel.com>
Date: Mon, 04 Feb 2008 13:45:59 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Zach Brown <zach.brown@oracle.com>, David Chinner <dgc@sgi.com>,
       Nick Piggin <npiggin@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de,
       James.Bottomley@SteelEye.com, andrea@suse.de, clameter@sgi.com,
       akpm@linux-foundation.org, andrew.vasquez@qlogic.com,
       willy@linux.intel.com
Subject: Re: [rfc] direct IO submission and completion scalability issues
References: <20070728012128.GB10033@linux-os.sc.intel.com> <20080203095252.GA11043@wotan.suse.de> <20080204021052.GD155407@sgi.com> <47A7579F.2050809@oracle.com> <20080204201027.GJ15220@kernel.dk>
In-Reply-To: <20080204201027.GJ15220@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
>> I was imagining the patch a little bit differently (per-cpu tasks, do a
>> wake_up from the driver instead of cpu nr testing up in blk, work
>> queues, whatever), but we know how to iron out these kinds of details ;).
> 
> per-cpu tasks/wq's might be better, it's a little awkward to jump
> through hoops
> 

one caveat btw; when the multiqueue storage hw becomes available for Linux,
we need to figure out how to deal with the preference thing; since there
honoring a "non-logical" preference would be quite expensive (it means
you can't make the local submit queues lockless etc etc), so before we go down
the road of having widespread APIs for this stuff.. we need to make sure we're
not going to do something that's going to be really stupid 6 to 18 months down the road.
