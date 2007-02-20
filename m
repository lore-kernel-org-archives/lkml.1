Return-Path: <linux-kernel-owner+w=401wt.eu-S1750948AbXBTS1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948AbXBTS1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 13:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbXBTS1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 13:27:10 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:43643 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbXBTS1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 13:27:09 -0500
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC871DA3@mssmsx411>
References: <B41635854730A14CA71C92B36EC22AAC871DA3@mssmsx411>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <930023BF-0955-4C3A-989F-9ECC3D7ECCC9@oracle.com>
Cc: <linux-aio@kvack.org>, <linux-kernel@vger.kernel.org>,
       "Benjamin LaHaise" <bcrl@kvack.org>,
       "Suparna bhattacharya" <suparna@in.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to completion event
Date: Tue, 20 Feb 2007 10:26:44 -0800
To: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 20, 2007, at 9:33 AM, Ananiev, Leonid I wrote:

> There is change in the patch which is uncommented in preface.
> Now aio_ring_insert_entry() is not called if req->ki_users>=1.
> Before was called.
> Could you comment it?

It is described in the patch description, though perhaps not  
explicitly enough:

"To get this working we change the aio_complete() path so that the ring
insertion is performed as the final iocb reference is dropped."

This stops an aio_complete() from generating a completion event  
before the submission path has had a chance to generate an error.   
This could happen if O_DIRECT bios completed very quickly before the  
submission path had a chance to return up and call  
ivalidate_inode_pages2_range().

- z


