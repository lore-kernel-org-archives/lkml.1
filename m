Return-Path: <linux-kernel-owner+w=401wt.eu-S932658AbXDHCFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbXDHCFd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 22:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965289AbXDHCFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 22:05:33 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:32994 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S933636AbXDHCFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 22:05:32 -0400
Date: Sat, 7 Apr 2007 18:35:41 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Willy Tarreau <w@1wt.eu>
cc: Al Boldi <a1426z@gawab.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: compressing intermediate files with LZO on the fly
In-Reply-To: <20070407115830.GE943@1wt.eu>
Message-ID: <Pine.LNX.4.63.0704071830510.25121@qynat.qvtvafvgr.pbz>
References: <200704071432.34157.a1426z@gawab.com> <20070407115830.GE943@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Apr 2007, Willy Tarreau wrote:

> Hi Al,
>
> On Sat, Apr 07, 2007 at 02:32:34PM +0300, Al Boldi wrote:
>> Willy Tarreau wrote:
>>>
>>> ... for some usages (temporary space),
>>> light compression can increase speed. For instance, when processing logs,
>>> I get better speed by compressing intermediate files with LZO on the fly.
>>
>> How can you do that on ext3?
>>
>> Also, can you do that on a partition block-io level?
>
> No, sorry for the confusion. My scripts simply do :
>
> $ lzop -cd file1.lzo | process | lzop -c3 > file2.lzo
>
> With decent CPU, you can reach higher read/write data rates than what a
> single off-the-shelf disk can achieve. For this reason, I think that
> reiser4 would be worth trying for this particular usage. And in this case,
> I'm not interested at all in reliability. It's just temporary storage. If
> the disk fails, I throw it away and buy a new one.

I see the same thing with my nightly scripts that do syslog analysis, last year 
I trimmed 2 hours from the nightly run by processing compressed files instead of 
uncompressed ones (after I did this I configured it to compress the files as 
they are rolled, but rolling every 5 min the compression takes <20 seconds, so 
the compression is < 30 min)

now I just need to find a version of split that can compress it's output files.

David Lang
