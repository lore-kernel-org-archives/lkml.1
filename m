Return-Path: <linux-kernel-owner+w=401wt.eu-S1030320AbXBTRR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030320AbXBTRR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030318AbXBTRR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:17:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:20224 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030320AbXBTRR6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:17:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,197,1170662400"; 
   d="scan'208"; a="199238969:sNHT24829245"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to completion event
Date: Tue, 20 Feb 2007 20:17:51 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC871D9D@mssmsx411>
In-Reply-To: <20070220170335.GR6133@think.oraclecorp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to completion event
Thread-Index: AcdVEZVsmYpe/bSPRNiTFsq500HwRQAAE19w
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: "Chris Mason" <chris.mason@oracle.com>
Cc: "Zach Brown" <zach.brown@oracle.com>, <linux-aio@kvack.org>,
       <linux-kernel@vger.kernel.org>, "Benjamin LaHaise" <bcrl@kvack.org>,
       "Suparna bhattacharya" <suparna@in.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 20 Feb 2007 17:17:55.0697 (UTC) FILETIME=[0F8CBE10:01C75513]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

aio-stress command lines used for test
1) mem=1G in kernel boot param if you have more
2) mk2fs for test_file
3) dd if=/dev/zero of=<test_file> bs=1M count=1200
4) aiostress -s 1200m -o 2 -i 1 -r 16k <test_file>

Leonid
-----Original Message-----
From: Chris Mason [mailto:chris.mason@oracle.com] 
Sent: Tuesday, February 20, 2007 8:04 PM
To: Ananiev, Leonid I
Cc: Zach Brown; linux-aio@kvack.org; linux-kernel@vger.kernel.org;
Benjamin LaHaise; Suparna bhattacharya; Andrew Morton
Subject: Re: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to
completion event

On Tue, Feb 20, 2007 at 07:57:49PM +0300, Ananiev, Leonid I wrote:
> Zach> This addresses an oops reported by Leonid Ananiev
> <leonid.i.ananiev@intel.com>
> Zach> as archived at http://lkml.org/lkml/2007/2/8/337.
> ....
> Zach> This was tested by running O_DIRECT aio-stress concurrently with
> buffered reads
> 
> The oops was with aio-stress only running in the loop
> WITHOUT buffered or mmaped IO which are patched and discussed now.
> Actually 47% aio is finished with EIO after patch.

I looked through the thread and couldn't find the aio-stress command
line used for the whole test.  Could you please post it here?

If aio+dio is being used to extend the file, you'll get pages in the
page cache, which is hopefully why you're able to trigger the EIOs.

-chris
