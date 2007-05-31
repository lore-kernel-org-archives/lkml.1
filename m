Return-Path: <linux-kernel-owner+w=401wt.eu-S1759838AbXEaRqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759838AbXEaRqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 13:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbXEaRqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 13:46:18 -0400
Received: from sandeen.net ([209.173.210.139]:29724 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262AbXEaRqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 13:46:18 -0400
Message-ID: <465F09E7.7000300@sandeen.net>
Date: Thu, 31 May 2007 12:46:15 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
References: <20070524165935.GB19709@duck.suse.cz> <20070524170554.GC19709@duck.suse.cz> <20070524203653.GA7693@duck.suse.cz> <465DF0B4.2050203@sandeen.net> <465DF91F.3010201@sandeen.net> <20070531174201.GB8392@cvg>
In-Reply-To: <20070531174201.GB8392@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:

> Eric, could you please try the following:
> 
> 1) declare the spinlock in the top of inode.c as
> 
> 	DEFINE_SPINLOCK(udf_drop_lock);
> 
> 2) replace in udf_drop_inode()
> 
> 	kernel_lock -> spin_lock(&udf_drop_lock);
> 	kernel_unlock -> spin_unlock(&udf_drop_lock);
> 
> I'm not sure if it help but you may try ;)
> 
> 		Cyrill
> 

I'm sure it'll avoid the deadlock but....

Any sense of what the BKL is actually trying to protect in this case?

Is it really only trying to prevent concurrent prealloc-discarders, or 
is there more?

-Eric
