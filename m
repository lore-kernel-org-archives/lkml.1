Return-Path: <linux-kernel-owner+w=401wt.eu-S1751197AbXBUIoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbXBUIoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 03:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbXBUIoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 03:44:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:16717 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbXBUIoX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 03:44:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,200,1170662400"; 
   d="scan'208"; a="49028511:sNHT24541839"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to completion event
Date: Wed, 21 Feb 2007 11:44:04 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC872061@mssmsx411>
In-Reply-To: <b040c32a0702210035w38dda81du55bc12259324a4b5@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to completion event
Thread-Index: AcdVk0pZY0o1J0pvT8aKa2+50y/wxQAAKkYQ
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: "Ken Chen" <kenchen@google.com>
Cc: "Chris Mason" <chris.mason@oracle.com>,
       "Zach Brown" <zach.brown@oracle.com>, <linux-aio@kvack.org>,
       <linux-kernel@vger.kernel.org>, "Benjamin LaHaise" <bcrl@kvack.org>,
       "Suparna bhattacharya" <suparna@in.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 21 Feb 2007 08:44:07.0242 (UTC) FILETIME=[72C592A0:01C75594]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> where it returns zero 
I've wrote in the mail http://lkml.org/lkml/2007/2/8/337
invalidate_inode_pages2_range() reports BUG:
warning at mm/truncate.c:398  occurs becouse of
invalidate_complete_page2()    returns 0; it returns 0 because of
try_to_release_page()          returns 0; it returns 0 because of
ext3_releasepage()             returns 0; it returns 0 because of
journal_try_to_free_buffers()  returns 0; it returns 0 because of
try_to_free_buffers()          returns 0; it returns 0 because of
drop_buffers()                 returns 0; it returns 0 because of
buffer_busy(bh)                returns 1; it returns 0 because of
buffer_head count is 1 (bh->b_count==1) as additional printk reports.

Leonid
-----Original Message-----
From: Ken Chen [mailto:kenchen@google.com] 
Sent: Wednesday, February 21, 2007 11:36 AM
To: Ananiev, Leonid I
Cc: Chris Mason; Zach Brown; linux-aio@kvack.org;
linux-kernel@vger.kernel.org; Benjamin LaHaise; Suparna bhattacharya;
Andrew Morton
Subject: Re: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to
completion event

On 2/20/07, Ananiev, Leonid <leonid.i.ananiev@intel.com> wrote:
> 1) mem=1G in kernel boot param if you have more
> 2) unmount; mk2fs; mount
> 3) dd if=/dev/zero of=<test_file> bs=1M count=1200
> 4) aiostress -s 1200m -O -o 2 -i 1 -r 16k <test_file>
> 5) if i++<50 goto 2).

Would you please instrument the call chain of
invalidate_complete_page2() and tell us exactly where it returns zero
value in your failure case?

   invalidate_complete_page2
      try_to_release_page
         ext3_releasepage
            journal_try_to_free_buffers
               ???
