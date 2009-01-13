Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbZAMOn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbZAMOn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755066AbZAMOnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:43:46 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:23138 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754928AbZAMOnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:43:45 -0500
Message-ID: <496CA89C.9090008@panasas.com>
Date: Tue, 13 Jan 2009 16:43:40 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Benny Halevy <bhalevy@panasas.com>,
       open-osd development <osd-dev@open-osd.org>,
       Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [osd-dev] [PATCH 1/9] exofs: osd Swiss army knife
References: <4947BFAA.4030208@panasas.com>	<4947C624.3050602@panasas.com>	<4964CEA4.7080001@panasas.com> <20090113135526.28730314@lxorguk.ukuu.org.uk>
In-Reply-To: <20090113135526.28730314@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jan 2009 14:43:43.0267 (UTC) FILETIME=[54F0B730:01C9758D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> +#define EXOFS_SUPER_ID	0x10000	/* object ID for on-disk superblock */
> 
> And if an OS failure breaks the super block and you have only one how do
> you recover it ?

There is nothing really in this object but the "next_id" which is recoverable
by an fsck utility (Not yet submitted) by a simple osd-list-partition
command. Same for num-of-files. All these values are just cached values,
for convenience.

> 
>>> +#define EXOFS_BM_ID	0x10001	/* object ID for ID bitmap */
Not used will be dropped

>>> +#define EXOFS_ROOT_ID	0x10002	/* object ID for root directory */
OK Only one, but so is all other directories. I'll think about it.
I'll probably postpone it for together with the raid management.

>>> +#define EXOFS_TEST_ID	0x10003	/* object ID for test object */
Not used will be dropped

> 
> Ditto some of the others
> 
>>> +	EXOFS_UINT64_MAX = (~0LL),
>>> +	EXOFS_MAX_INO_ID = (sizeof(ino_t) * 8 == 64) ? EXOFS_UINT64_MAX :
>>> +					(1LL << (sizeof(ino_t) * 8 - 1)),
> 
> Ok so thats quite a big number
> 
>>> +	uint32_t  s_nextid;	/* Highest object ID used */
I fixed all that to be __le64, you can see that on the web here:
http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=shortlog;h=refs/heads/exofs

I will submit another round ASAP. I'm currently busy with user-mode-library.
Once done I'll post the next exofs round. All these and lots of other areas where
converted to proper __leXX types. Specially the directory code had all these
missing. It was all triggered thanks to Morton who pointed me to all these ext2
bug-fixes since 2.6.10.

> 
> but that is a smaller one
> 
>>> +	uint32_t  s_numfiles;	/* Number of files on fs */
> 
> as is this

Yes also fixed to __le64

> 
>>> +	uint32_t  i_atime;        	/* Access time */
>>> +	uint32_t  i_ctime;        	/* Creation time */
>>> +	uint32_t  i_mtime;        	/* Modification time */
> 
> 2038 ? - bits are cheap
> 

OK Avisi got lazy, This is a copy form ext2. I will fix that,
thanks for pointing this out. I will put __le64 for seconds
and also add __le64 for nanoseconds while at it.

Thanks Ingo for your review
Boaz

