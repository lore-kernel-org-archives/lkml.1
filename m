Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbZEKMpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbZEKMpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbZEKMpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:45:36 -0400
Received: from dwdmx5.dwd.de ([141.38.3.242]:58139 "EHLO dwdmx5.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbZEKMpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:45:35 -0400
Date: Mon, 11 May 2009 12:45:29 +0000 (GMT)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@praktifix.dwd.de
To: Trond Myklebust <trond.myklebust@fys.uio.no>
cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: NFS write OOPS with 2.6.29.2
In-Reply-To: <1242044201.6691.4.camel@heimdal.trondhjem.org>
Message-ID: <Pine.LNX.4.64.0905111240190.27423@praktifix.dwd.de>
References: <Pine.LNX.4.64.0905031552340.1774@praktifix.dwd.de> 
 <20090504231426.2e5a51b0.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0905091913010.3181@praktifix.dwd.de> 
 <1241929074.5149.1.camel@heimdal.trondhjem.org> 
 <Pine.LNX.4.64.0905110919490.27423@praktifix.dwd.de>
 <1242044201.6691.4.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Trond Myklebust wrote:

> On Mon, 2009-05-11 at 09:24 +0000, Holger Kiehl wrote:
>> On Sun, 10 May 2009, Trond Myklebust wrote:
>>
>>> On Sat, 2009-05-09 at 19:16 +0000, Holger Kiehl wrote:
>>>> On Mon, 4 May 2009, Andrew Morton wrote:
>>>>
>>>>>
>>>>> (cc linux-nfs)
>>>>>
>>>>> On Sun, 3 May 2009 16:03:38 +0000 (GMT) Holger Kiehl <Holger.Kiehl@dwd.de> wrote:
>>>>>
>>>>>> Hello
>>>>>>
>>>>>> With plain kernel 2.6.29.2 I get the following OOPS (several of them) when
>>>>>> writing lots of small files on the client system:
>>>>>>
>>>>>>     May  3 18:48:34 obelix kernel: ------------[ cut here ]------------
>>>>>>     May  3 18:48:34 obelix kernel: kernel BUG at fs/nfs/write.c:252!
>>>>>
>>>>> I think this is a well-know bug, and fixes should be available in 2.6.29.3?
>>>>>
>>>> Thanks for this information. I just tried 2.6.29.3 and it still oopses.
>>>> Are there any patches I can try?
>>>
>>> The attached backports against 2.6.29 are untested, but they are known
>>> to compile at least. Could you give them a try?
>>>
>> Thanks. They do compile but when there is a mmap on the NFS drive the
>> program gets a SIGBUS:
>>
>>     unlink("/home/afdbench/afd2/fifodir/AFD_ACTIVE") = 0
>>     close(3)                                = 0
>>     open("/home/afdbench/afd2/fifodir/AFD_ACTIVE", O_RDWR|O_CREAT|O_TRUNC|O_CLOEXEC, 0600) = 3
>>     lseek(3, 78, SEEK_SET)                  = 78
>>     write(3, "\377"..., 1)                  = 1
>>     mmap(NULL, 78, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0) = 0x7f8045cdb000
>>     --- SIGBUS (Bus error) @ 0 (0) ---
>>
>> This was with 2.6.29.3 plus the patches you send me.
>>
>> Holger
>
> Oh, duh... You need this little patchlet too.
>
Thanks! Now it works. One more problem I have is with splice(). My
application reports the following error:

    splice() error : Invalid argument

When it is called as follows:

     if ((bytes_written = splice(fd_pipe[0], NULL, to_fd,
                                 NULL, bytes_read,
                                 SPLICE_F_MOVE | SPLICE_F_MORE)) == -1)

Or may I not use splice() over NFS?

Thanks,
Holger
