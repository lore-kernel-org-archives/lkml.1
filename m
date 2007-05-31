Return-Path: <linux-kernel-owner+w=401wt.eu-S1760817AbXEaShb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760817AbXEaShb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbXEaShT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:37:19 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:41481 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754381AbXEaShR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:37:17 -0400
Message-ID: <465F15ED.1070304@cfl.rr.com>
Date: Thu, 31 May 2007 14:37:33 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: device-mapper development <dm-devel@redhat.com>,
       David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>,
       Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com> <20070529234832.GT85884050@sgi.com> <465DAA15.3070703@cfl.rr.com> <465DDE1D.3000809@cfl.rr.com> <20070531062404.GH32105@kernel.dk>
In-Reply-To: <20070531062404.GH32105@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 May 2007 18:37:28.0897 (UTC) FILETIME=[BDE84310:01C7A3B2]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15210.000
X-TM-AS-Result: No--6.023500-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> No Stephan is right, the barrier is both an ordering and integrity
> constraint. If a driver completes a barrier request before that request
> and previously submitted requests are on STABLE storage, then it
> violates that principle. Look at the code and the various ordering
> options.

I am saying that is the wrong thing to do.  Barrier should be about 
ordering only.  So long as the order they hit the media is maintained, 
the order the requests are completed in can change.  barrier.txt bears 
this out:

"Requests in ordered sequence are issued in order, but not required to 
finish in order.  Barrier implementation can handle out-of-order 
completion of ordered sequence.  IOW, the requests MUST be processed in 
order but the hardware/software completion paths are allowed to reorder 
completion notifications - eg. current SCSI midlayer doesn't preserve 
completion order during error handling."


