Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbYHGPIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbYHGPIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 11:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbYHGPIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 11:08:09 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:59123 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbYHGPII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 11:08:08 -0400
In-Reply-To: <1218105242.15342.184.camel@think.oraclecorp.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Btrfs v0.16 released
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Thu, 7 Aug 2008 16:07:15 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 07/08/2008 16:08:05,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 07/08/2008 16:08:05,
	Serialize complete at 07/08/2008 16:08:05,
	S/MIME Sign failed at 07/08/2008 16:08:05: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 07/08/2008 16:07:16,
	Serialize complete at 07/08/2008 16:07:16
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080807150809.577D82FE8BE@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote on 07/08/2008 11:34:02:

> > > * Helper threads for checksumming and other background tasks.  Most 
CPU
> > > intensive operations have been pushed off to helper threads to take
> > > advantage of SMP machines.  Streaming read and write throughput now
> > > scale to disk speed even with checksumming on.
> > 
> > Can this lead to the same Priority Inversion issues as seen with
> > kjournald?
> 
> Yes, although in general only the helper threads end up actually doing
> the IO for writes.  Unfortunately, they are almost but not quite an
> elevator.  It is tempting to try sorting the bios on the helper queues
> etc.  But I haven't done that because it gets into starvation and other
> fun.
> 
> I haven't done any real single cpu testing, it may make sense in those
> workloads to checksum and submit directly in the calling context.  But
> real single cpu boxes are harder to come by these days.

[just jumping in as a casual bystander with one remark]

For this purpose it seems booting up with limiting to one CPU should be 
sufficient.

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

