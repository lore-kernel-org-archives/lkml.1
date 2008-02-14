Return-Path: <linux-kernel-owner+w=401wt.eu-S932820AbYBNMPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820AbYBNMPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 07:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762245AbYBNMPC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 07:15:02 -0500
Received: from trashmail.net ([213.155.82.90]:40671 "EHLO trashmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759579AbYBNMO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 07:14:59 -0500
Message-ID: <47B43138.40206@trashmail.net>
Date: Thu, 14 Feb 2008 13:16:56 +0100
From: Mika Lawando <rzryyvzy@trashmail.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Is there a "blackhole" /dev/null directory?
References: <20080214093051.7240852AB0E31@trashmail.net> <1202981957.10928.17.camel@phobos.jasper.bg>
In-Reply-To: <1202981957.10928.17.camel@phobos.jasper.bg>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jasper Bryant-Greene schrieb:
> On Thu, 2008-02-14 at 10:30 +0100, rzryyvzy wrote:
>   
>> /dev/null is often very useful, specially if programs force to save data in some file. But some programs like to creates different temporary file names, so /dev/null could no more work.
>>
>> What is with a "/dev/null"-directory?
>> I mean a "blackhole pseudo directory" which eats every write to null.
>>
>> Here is how it could work:
>> mount -t nulldir nulldir /dev/nulldir
>>
>> Now if a program does a create(2),
>> it creates in the memory the file with its fd.
>> Then if a program does a write(2) to the fd, it eats the writes and give out fakely it has written the number of bytes.
>> When the program calls does a close(2) of the fd, then the complete inode is deleted in the memory.
>>
>> The directory should  be permanently empty except for the inodes with open file descriptors. So only inode information would be temporary saved in this "nulldir tmpfs" directory.
>>
>> Is there already existing a possibility to create a null directory?
>>     
>
> This could be done fairly trivially with FUSE, and IMHO is a good use
> for FUSE because since you're just throwing most data away, performance
> is not a concern.
>   
Unfortunately performance is a concern because if not I would write on 
the hard disk the files, and then remove them with a cronjob.
But from the point of view of the time of developpment, FUSE is a good 
idea, because its possible to write a filesystem quickly in Perl.

-- 
Best regards,
Mika
