Return-Path: <linux-kernel-owner+w=401wt.eu-S1945927AbXC3DRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945927AbXC3DRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 23:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945929AbXC3DRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 23:17:12 -0400
Received: from smtpout.mac.com ([17.250.248.172]:62083 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945927AbXC3DRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 23:17:11 -0400
In-Reply-To: <20070328131454.cdb06bc3.akpm@linux-foundation.org>
References: <200703281847.05356.toralf.foerster@gmx.de> <75b66ecd0703280956i522cf6cbyc4c9ef8b1666ec15@mail.gmail.com> <Pine.LNX.4.64.0703281909240.29565@twin.jikos.cz> <20070328131454.cdb06bc3.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <46C1CD24-F48E-4EB9-B6A5-E1B3C303C62F@mac.com>
Cc: Jiri Kosina <jikos@jikos.cz>, Lee Revell <rlrevell@joe-job.com>,
       =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
       andrea@suse.de, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: fs/block_dev.c:953: warning: 'found' might be used uninitialized in this function
Date: Thu, 29 Mar 2007 23:16:39 -0400
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 28, 2007, at 16:14:54, Andrew Morton wrote:
> On Wed, 28 Mar 2007 19:23:32 +0200 (CEST)
> Jiri Kosina <jikos@jikos.cz> wrote:
>
>> blockdev: bd_claim_by_kobject() could check value of unititalized  
>> pointer
>>
>> Fixes this warning:
>>
>> fs/block_dev.c: In function `bd_claim_by_kobject':
>> fs/block_dev.c:953: warning: 'found' might be used uninitialized  
>> in this function
>>
>> struct bd_holder *found is initialized only when bd_claim()  
>> returns zero. If it returns nonzero, ptr stays uninitialized.  
>> Later the value of the pointer is checked.
>
> that generates extra code and people get upset.
>
> One approach which we could ue in here is
>
> 	struct bd_holder *found = found;  /* Suppress bogus gcc warning */

Well, that would be correct except the warning is an actual kernel  
bug.  Read Jiri's message (which you also quoted):
> struct bd_holder *found is initialized only when bd_claim() returns  
> zero. If it returns nonzero, ptr stays uninitialized. Later the  
> value of the pointer is checked.

So in this case it has to be initialized to NULL or there's a  
potential BUG() lurking.

Cheers,
Kyle Moffett

