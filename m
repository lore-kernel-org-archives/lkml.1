Return-Path: <linux-kernel-owner+w=401wt.eu-S1762875AbYAKV76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762875AbYAKV76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 16:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761868AbYAKV7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 16:59:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761799AbYAKV7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 16:59:48 -0500
Message-ID: <4787E6CD.3080709@redhat.com>
Date: Fri, 11 Jan 2008 16:59:41 -0500
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071018)
MIME-Version: 1.0
To: Anton Salikhmetov <salikhmetov@gmail.com>
CC: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       jesper.juhl@gmail.com
Subject: Re: [PATCH 2/2][RFC][BUG] msync: updating ctime and mtime at syncing
References: <1200006638.19293.42.camel@codedot>	 <1200012249.20379.2.camel@codedot> <4787BC89.2010106@redhat.com> <4df4ef0c0801111340n515a3c70n4b26468ddb47ebd2@mail.gmail.com>
In-Reply-To: <4df4ef0c0801111340n515a3c70n4b26468ddb47ebd2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Salikhmetov wrote:
> 2008/1/11, Peter Staubach <staubach@redhat.com>:
>   
>> Anton Salikhmetov wrote:
>>     
>>> From: Anton Salikhmetov <salikhmetov@gmail.com>
>>>
>>> The patch contains changes for updating the ctime and mtime fields for memory mapped files:
>>>
>>> 1) adding a new flag triggering update of the inode data;
>>> 2) implementing a helper function for checking that flag and updating ctime and mtime;
>>> 3) updating time stamps for mapped files in sys_msync() and do_fsync().
>>>       
>> Sorry, one other issue to throw out too -- an mmap'd block device
>> should also have its inode time fields updated.  This is a little
>> tricky because the inode referenced via mapping->host isn't the
>> one that needs to have the time fields updated on.
>>
>> I have attached the patch that I submitted last.  It is quite out
>> of date, but does show my attempt to resolve some of these issues.
>>     
>
> Thanks for your feedback!
>
> Now I'm looking at your solution and thinking about which parts of it
> I could adapt to the infrastructure I'm trying to develop.
>
> However, I would like to address the block device case within
> a separate project. But for now, I want the msync() and fsync()
> system calls to update ctime and mtime at least for memory-mapped
> regular files properly. I feel that even this little improvement could address
> many customer's troubles such as the one Jacob Oestergaard reported
> in the bug #2645.

Not that I disagree and I also have customers who would really like
to see this situation addressed so that I can then fix it in RHEL,
but the block device issue was raised by Andrew Morton during my
first attempt to get a patch integrated.

Just so that you are aware of who has raised which issues...  :-)

    Thanx...

       ps
