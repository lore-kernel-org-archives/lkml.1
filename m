Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbXE1Job@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbXE1Job (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 05:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbXE1JoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 05:44:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbXE1JoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 05:44:17 -0400
Date: Mon, 28 May 2007 10:43:58 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: device-mapper development <dm-devel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       David Chinner <dgc@sgi.com>, Phillip Susi <psusi@cfl.rr.com>,
       Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Message-ID: <20070528094358.GM25091@agk.fab.redhat.com>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
	David Chinner <dgc@sgi.com>, Phillip Susi <psusi@cfl.rr.com>,
	Stefan Bader <Stefan.Bader@de.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	Tejun Heo <htejun@gmail.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18010.12472.209452.148229@notabene.brown>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 11:30:32AM +1000, Neil Brown wrote:
> 1/ A BIO_RW_BARRIER request should never fail with -EOPNOTSUP.
 
The device-mapper position has always been that we require

>  a zero-length BIO_RW_BARRIER 

(i.e. containing no data to read or write - or emulated, possibly
device-specific)

before we can provide full barrier support.
  (Consider multiple active paths - each must see barrier.)

Until every device supports barriers -EOPNOTSUP support is required.
  (Consider reconfiguration of stacks of devices - barrier support is a
   dynamic block device property that can switch between available and
   unavailable at any time.)

Alasdair
-- 
agk@redhat.com
