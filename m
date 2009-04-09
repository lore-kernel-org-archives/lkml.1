Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbZDIB2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbZDIB2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 21:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbZDIB2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 21:28:08 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:48847 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbZDIB2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 21:28:07 -0400
Subject: Re: [dm-devel] Barriers still not passing on simple dm devices...
From: Chris Mason <chris.mason@oracle.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       device-mapper development <dm-devel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ak@linux.intel.com
In-Reply-To: <Pine.LNX.4.64.0904080855340.28196@hs20-bc2-1.build.redhat.com>
References: <20090324143034.GW27476@kernel.dk>
	 <Pine.LNX.4.64.0903241033070.4088@hs20-bc2-1.build.redhat.com>
	 <20090324150517.GX27476@kernel.dk>
	 <Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com>
	 <20090325152751.GV27476@kernel.dk>
	 <Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com>
	 <20090326084205.GG27476@kernel.dk>
	 <Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com>
	 <20090331104933.GJ5178@kernel.dk>
	 <Pine.LNX.4.64.0904021923040.19415@hs20-bc2-1.build.redhat.com>
	 <20090403081131.GP5178@kernel.dk>
	 <Pine.LNX.4.64.0904080855340.28196@hs20-bc2-1.build.redhat.com>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 21:27:20 -0400
Message-Id: <1239240440.11220.3.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.49DD4F11.00C9:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 09:37 -0400, Mikulas Patocka wrote:

> So there are two ways:
> 
> - either support only what all in-kernel filesystems do. Using barrier 
> reqiests to flush hw cache. You can remove support for barriers with data, 
> leave just zero-data barrier, you can remove ordering restrictions. 
> In-kernel filesystems never overlap barrier with another metadata request 
> (see above why such overlap can't work), so you can freely reorder 
> zero-data barriers and simplify the code ... because all the requests that 
> could be submitted in paralel with the barrier are either for different 
> partition or non-metadata requests to the same partition from prefetch, 
> direct io or so.
> 
> - or you can allow barriers to be used for purposes as I did. And then, 
> there must be clean indicator "this device supports barriers 
> *and*will*support*them*in*the*future*". Currently there is no such 
> indicator.

I'm afraid expecting barriers forever in the future isn't completely
compatible with dm or md.  Both of these allow the storage to change
over time, and the filesystem needs to handle this without corruptions.

-chris


