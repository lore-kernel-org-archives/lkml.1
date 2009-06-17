Return-Path: <linux-kernel-owner+w=401wt.eu-S1761498AbZFQWte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761498AbZFQWte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 18:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757087AbZFQWt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 18:49:27 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:63175 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739AbZFQWt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 18:49:26 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [GIT PULL] block updates for 2.6.31-rc1
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20090616071823.GL11363@kernel.dk>
	<20090617151754.e7c4c58c.akpm@linux-foundation.org>
Date: Wed, 17 Jun 2009 18:49:15 -0400
In-Reply-To: <20090617151754.e7c4c58c.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 17 Jun 2009 15:17:54 -0700")
Message-ID: <yq1ocsmo4r8.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.4A3972EE.0086:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andrew" == Andrew Morton <akpm@linux-foundation.org> writes:

Andrew> i386 allnoconfig:

Andrew> block/blk-settings.c: In function 'blk_set_default_limits':
Andrew> block/blk-settings.c:115: warning: large integer implicitly
Andrew> truncated to unsigned type

I sent Jens a fix earlier today.


Andrew> It doesn't look like it'll cause any runtime problems, but that
Andrew> just means we got lucky.

I didn't do a compile check on 32-bit, I admit that.  But the patch was
explicitly done in a way that wouldn't affect the existing I/O path.


Andrew> Or is the code just buggy?  What are the units of
Andrew> BLK_BOUNCE_HIGH, BLK_BOUNCE_ANY and BLK_BOUNCE_ISA?  Seems that
Andrew> they are physical addresses.  So why are we copying one of these
Andrew> onto a variable which records pfns?

BLK_BOUNCE_* is the DMA mask, yes.  It needs to be converted to pfns.
That's what I messed up when I ripped the call out of DM to put it in
the generic block layer function.

I'll defer to Jens wrt. the choice of -1ULL.

-- 
Martin K. Petersen	Oracle Linux Engineering
