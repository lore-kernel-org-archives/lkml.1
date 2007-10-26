Return-Path: <linux-kernel-owner+w=401wt.eu-S1765187AbXJZWn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765187AbXJZWn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbXJZWnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:43:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42365 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450AbXJZWnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:43:09 -0400
Date: Fri, 26 Oct 2007 15:42:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Zach Brown <zach.brown@oracle.com>
cc: Karl Schendel <kschendel@datallegro.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Leonid Ananiev <leonid.i.ananiev@linux.intel.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Fix bad data from non-direct-io read after direct-io
 write
In-Reply-To: <47226A75.1020008@oracle.com>
Message-ID: <alpine.LFD.0.999.0710261541410.30120@woody.linux-foundation.org>
References: <47225835.4050309@datallegro.com>
 <alpine.LFD.0.999.0710261425240.30120@woody.linux-foundation.org>
 <47226A75.1020008@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Oct 2007, Zach Brown wrote:
> 
> I think that test should be changed to

How about not testing at all? Which was what the old code did.

Just do the invalidate unconditionally for any writes, and screw the end 
result of the invalidate, since we cannot afford to overwrite the previous 
return value anyway in any realistic scenario?

		Linus
