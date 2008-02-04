Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbYBDERE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbYBDERE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 23:17:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbYBDEQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 23:16:52 -0500
Received: from mga06.intel.com ([134.134.136.21]:41649 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754906AbYBDEQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 23:16:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,299,1199692800"; 
   d="scan'208";a="334331757"
Message-ID: <47A69135.3060306@linux.intel.com>
Date: Sun, 03 Feb 2008 20:14:45 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Nick Piggin <npiggin@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de,
       jens.axboe@oracle.com, James.Bottomley@SteelEye.com, andrea@suse.de,
       clameter@sgi.com, akpm@linux-foundation.org, andrew.vasquez@qlogic.com,
       willy@linux.intel.com, Zach Brown <zach.brown@oracle.com>
Subject: Re: [rfc] direct IO submission and completion scalability issues
References: <20070728012128.GB10033@linux-os.sc.intel.com> <20080203095252.GA11043@wotan.suse.de> <20080204021052.GD155407@sgi.com>
In-Reply-To: <20080204021052.GD155407@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> Hi Nick,
> 
> When Matthew was describing this work at an LCA presentation (not
> sure whether you were at that presentation or not), Zach came up
> with the idea that allowing the submitting application control the
> CPU that the io completion processing was occurring would be a good
> approach to try.  That is, we submit a "completion cookie" with the
> bio that indicates where we want completion to run, rather than
> dictating that completion runs on the submission CPU.
> 
> The reasoning is that only the higher level context really knows
> what is optimal, and that changes from application to application.

well.. kinda. One of the really hard parts of the submit/completion stuff is that
the slab/slob/slub/slib allocator ends up basically "cycling" memory through the system;
there's a sink of free memory on all the submission cpus and a source of free memory
on the completion cpu. I don't think applications are capable of working out what is
best in this scenario..


