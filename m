Return-Path: <linux-kernel-owner+w=401wt.eu-S932776AbXBTSlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776AbXBTSlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 13:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932973AbXBTSlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 13:41:15 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:50968 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932776AbXBTSlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 13:41:15 -0500
In-Reply-To: <1171988988.6271.26.camel@heimdal.trondhjem.org>
References: <20070219203527.20419.68418.sendpatchset@tetsuo.zabbo.net> <B41635854730A14CA71C92B36EC22AAC83B044@mssmsx411> <20070219215048.GI6133@think.oraclecorp.com> <20070220002109.GG31205@kvack.org> <1171987310.6271.23.camel@heimdal.trondhjem.org> <20070220160854.GO6133@think.oraclecorp.com> <1171988988.6271.26.camel@heimdal.trondhjem.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <528148DD-0533-4D82-A242-25A4C5D1A977@oracle.com>
Cc: Chris Mason <chris.mason@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>,
       "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org, Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] aio: propogate post-EIOCBQUEUED errors to completion event
Date: Tue, 20 Feb 2007 10:40:03 -0800
To: Trond Myklebust <trond.myklebust@fys.uio.no>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> There are some strange O_DIRECT corner cases in here such that the  
>> 'last
>> writer' may actually be a 'last reader' and winning can mean have  
>> a copy
>> of the page in page cache older than the copy on disk.
>
> As long as it is marked dirty so that it eventually gets synced to  
> disk,
> it shouldn't matter.

No, Chris is pointing out that an an O_DIRECT write can leave clean  
read pages in the page cache.

All it takes is giving a source buffer for the write which is an mmap 
()ed apeture of the region that is being written to.  If you get the  
offsets right you can get the get_user_pages() down in fs/direct-io.c  
will populate the page cache before the actual O_DIRECT write gets to  
it.

- z
