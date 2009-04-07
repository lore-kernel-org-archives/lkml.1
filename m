Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbZDGDye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbZDGDye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 23:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZDGDyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 23:54:25 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:46358 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbZDGDyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 23:54:24 -0400
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
From: Chris Mason <chris.mason@oracle.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Hua Zhong <hzhong@gmail.com>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jens Axboe'" <jens.axboe@oracle.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090406211931.GB8586@mit.edu>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
	 <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain>
	 <20090406151054.GD5178@kernel.dk>
	 <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>
	 <20090406183157.GD7376@mit.edu>
	 <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>
	 <002501c9b6f3$f85b4910$e911db30$@com>  <20090406211931.GB8586@mit.edu>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 23:52:59 -0400
Message-Id: <1239076379.17426.23.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.49DACE20.00FC:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-06 at 17:19 -0400, Theodore Tso wrote:
> On Mon, Apr 06, 2009 at 01:12:08PM -0700, Hua Zhong wrote:
> > Grr..making writeback as default would break people's setup that relies on
> > the ordered semantics, especially in the embedded world. It's a big no-no.
> 
> I've added workarounds for 2.6.30 that provide the replace-via-rename
> and replace-via-truncate workarounds for ext3 data=writeback cases.
> See commits e7c8f507 and f7ab34ea.  
> 
> There won't be an implied fsync for newly created files, yes, but you
> could have crashed 5 seconds earlier, at which point you would have
> lost the newly created file anyway.  Replace-via-rename and
> replace-via-truncate solves the problem for applications which are
> editing pre-existing files, which was most of people's complaints
> about depending on data=ordered semantics.

XFS got a reputation for losing data largely based on null bytes in
files after a crash.  In the XFS case the files always had zeros, and
not garbage that used to be on disk.

Years later xfs still gets beaten up for null bytes in files even though
they added code to prevent a long time ago.

Please leave data=ordered as the default for ext3.  If we really need to
fix ext3, it makes sense to switch to the xfs style i_size update at IO
end instead of data=writeback.

-chris


