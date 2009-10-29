Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbZJ2VjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbZJ2VjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 17:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbZJ2VjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 17:39:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbZJ2VjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 17:39:03 -0400
Message-ID: <4AEA0B71.5050805@redhat.com>
Date: Thu, 29 Oct 2009 16:38:57 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Parag Warudkar <parag.lkml@gmail.com>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Theodore Tso <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 14354] Re: ext4 increased intolerance to unclean shutdown?
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com>	 <20091016091558.GA10184@mit.edu>	 <20091027101534.GA27584@skywalker.linux.vnet.ibm.com> <f7848160910291425q30377641qfe23e74fbc643d89@mail.gmail.com>
In-Reply-To: <f7848160910291425q30377641qfe23e74fbc643d89@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parag Warudkar wrote:
> On Tue, Oct 27, 2009 at 6:15 AM, Aneesh Kumar K.V
> <aneesh.kumar@linux.vnet.ibm.com> wrote:
>> Can you try this patch ?
>>
>> commit a8836b1d6f92273e001012c7705ae8f4c3d5fb65
>> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> Date:   Tue Oct 27 15:36:38 2009 +0530
>>
>>    ext4: discard preallocation during truncate
>>
>>    We need to make sure when we drop and reacquire the inode's
>>    i_data_sem we discard the inode preallocation. Otherwise we
>>    could have blocks marked as free in bitmap but still belonging
>>    to prealloc space.
> 
> Just wanted to let you know that I have applied this patch and one
> unclean shutdown later it seems to have not given me any trouble.
> 
> I will continue testing it - hopefully I won't have to reformat  this
> time ( every time I tested previously I ended up having weird issues
> that I decided to get rid of by reformatting /).

I've been running my testcase, and I just hit the usual corruption with 
this patch in place after 8 iterations, I'm afraid.

-Eric

> Parag
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

