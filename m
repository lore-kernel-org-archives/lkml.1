Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbZCZM4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbZCZM4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 08:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZCZM4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 08:56:05 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:42044 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbZCZM4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 08:56:04 -0400
Subject: Re: [dm-devel] Barriers still not passing on simple dm devices...
From: Chris Mason <chris.mason@oracle.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       device-mapper development <dm-devel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
In-Reply-To: <Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com>
References: <49C7DD3C.2020401@redhat.com>
	 <Pine.LNX.4.64.0903241000010.29968@hs20-bc2-1.build.redhat.com>
	 <20090324140524.GV27476@kernel.dk>
	 <Pine.LNX.4.64.0903241010490.29968@hs20-bc2-1.build.redhat.com>
	 <20090324143034.GW27476@kernel.dk>
	 <Pine.LNX.4.64.0903241033070.4088@hs20-bc2-1.build.redhat.com>
	 <20090324150517.GX27476@kernel.dk>
	 <Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com>
	 <20090325152751.GV27476@kernel.dk>
	 <Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com>
Content-Type: text/plain
Date: Thu, 26 Mar 2009 08:55:34 -0400
Message-Id: <1238072134.5676.12.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49CB7B4B.003A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 18:39 -0400, Mikulas Patocka wrote:

> > The error handling is complex, no doubt
> > about that. But the trial barrier test is pretty trivial and even could
> > be easily abstracted out. If a later barrier write fails, then that's
> > really no different than if a normal write fails. Error handling is not
> > easy in that case.
> 
> I had a discussion with Andi about it some times ago. The conclusion was 
> that all the current filesystems handle barriers failing in the middle of 
> the operation without functionality loss, but it makes barriers useless 
> for any performance-sensitive tasks (commits that wouldn't block 
> concurrent activity). Non-blocking commits could only be implemented if 
> barriers don't fail.
> 

If a barrier fails at runtime, the filesystems do fall back to not doing
barriers without real problems.  But, that's because they don't actually
rely on the barriers to decide if an async commit is a good idea.

One exception is reiserfs, which does one wait_on_buffer at a later time
if barriers are on.  But, this isn't an async commit, this is just
moving an unplug.

In general, async commits happen with threads and they aren't related to
barriers.  Barriers don't really give us error handling, and they are at
the very end of a long chain of technical problems around commits that
don't block concurrent activity.

-chris


