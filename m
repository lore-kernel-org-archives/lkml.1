Return-Path: <linux-kernel-owner+w=401wt.eu-S965683AbXBTA1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965683AbXBTA1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965707AbXBTA1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:27:08 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:14017 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965683AbXBTA1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:27:07 -0500
In-Reply-To: <20070220002109.GG31205@kvack.org>
References: <20070219203527.20419.68418.sendpatchset@tetsuo.zabbo.net> <B41635854730A14CA71C92B36EC22AAC83B044@mssmsx411> <20070219215048.GI6133@think.oraclecorp.com> <20070220002109.GG31205@kvack.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <998821DA-955A-4F4E-A3C5-4BEAE6FFF90B@oracle.com>
Cc: Chris Mason <chris.mason@oracle.com>,
       "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org, Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] aio: propogate post-EIOCBQUEUED errors to completion event
Date: Mon, 19 Feb 2007 16:26:18 -0800
To: Benjamin LaHaise <bcrl@kvack.org>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> I would argue that one common cause of the EIO is userland
>> error (mmap concurrent with O_DIRECT), and EIO is the correct answer.
>
> I disagree.  That means that using the pagecache to synchronize  
> things like
> the proposed online defragmentation will occasionally make O_DIRECT  
> users
> fail.

Well, only if the pages couldn't be invalidated.  Arguably ext3  
should be trying a lot harder to invalidate before giving up and  
returning failure from invalidate_page().

Hopefully this all goes away in the long term with Chris'  
"placeholder" work that stops insertions into the radix tree while  
dio ops are in flight.

- z
