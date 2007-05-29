Return-Path: <linux-kernel-owner+w=401wt.eu-S1761501AbXE2UDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761501AbXE2UDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765504AbXE2UDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:03:37 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:64126 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765495AbXE2UDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:03:34 -0400
Message-ID: <465C871F.708@cfl.rr.com>
Date: Tue, 29 May 2007 16:03:43 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
 and dm/md.
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com>
In-Reply-To: <20070528024559.GA85884050@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 May 2007 20:03:48.0241 (UTC) FILETIME=[7835F010:01C7A22C]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15206.000
X-TM-AS-Result: No--7.286100-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> Sounds good to me, but how do we test to see if the underlying
> device supports barriers? Do we just assume that they do and
> only change behaviour if -o nobarrier is specified in the mount
> options?

The idea is that ALL block devices will support barriers; if the 
underlying driver doesn't, then the block layer will work around it.

> The use of barriers in XFS assumes the commit write to be on stable
> storage before it returns.  One of the ordering guarantees that we
> need is that the transaction (commit write) is on disk before the
> metadata block containing the change in the transaction is written
> to disk and the current barrier behaviour gives us that.

Barrier != synchronous write, so if XFS relies on that block being on 
the media when the request is completed, then it is broken.  It should 
only care that the ordering of log-data-log is maintained, not exactly 
when each specific request completes.


