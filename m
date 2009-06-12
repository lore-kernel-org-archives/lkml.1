Return-Path: <linux-kernel-owner+w=401wt.eu-S1762997AbZFLPzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762997AbZFLPzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757774AbZFLPyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:54:52 -0400
Received: from relay3.sgi.com ([192.48.156.57]:51349 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754275AbZFLPyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:54:51 -0400
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Message-Id: <1FF0104F-7D97-4A6A-B80E-E7EE511AA916@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
In-Reply-To: <alpine.DEB.2.00.0906120420080.26259@p34.internal.lan>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: Kernel 2.6.30: Memory/XFS leak, OOM killer kills many processes
Date: Fri, 12 Jun 2009 10:54:53 -0500
References: <alpine.DEB.2.00.0906111158470.2563@p34.internal.lan> <alpine.DEB.2.00.0906111255280.6809@p34.internal.lan> <4A313F84.20900@sandeen.net> <96F5FBF8-17B6-4AA9-BAB4-377AF596692C@sgi.com> <alpine.DEB.2.00.0906120420080.26259@p34.internal.lan>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 12, 2009, at 3:37 AM, Justin Piszcz wrote:

>
>
> On Thu, 11 Jun 2009, Felix Blyakher wrote:
>
>>
>> On Jun 11, 2009, at 12:31 PM, Eric Sandeen wrote:
>>
>>> Justin Piszcz wrote:
>>>> On Thu, 11 Jun 2009, Justin Piszcz wrote:
>> The following should fix it:
>>
>> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
>> index 4b0f6ef..7928b99 100644
>> --- a/fs/xfs/xfs_bmap.c
>> +++ b/fs/xfs/xfs_bmap.c
>> @@ -6086,6 +6086,7 @@ xfs_getbmap(
>>                     break;
>>     }
>>
>> +       kmem_free(out);
>>     return error;
>> }
>>
>>
>> Felix
>
> Just FYI if anyone tries to run the patch it will not work:
>
> # patch -p1 < ../xfs.patch patching file fs/xfs/xfs_bmap.c
> patch: **** malformed patch at line 11: }

Must have been copy-and-paste problem. The real one is good :)

> So just goto line ~6086 and add the kmem_free(out); above the return  
> error.
>
> Status:
> This patch fixes the problem, thanks!

Thanks for reporting and verifying the fix!
It's ready now for the linux-next in the official xfs repo,
going upstream with the pull request later today and then be
ready for inclusion in 2.6.30.

Felix

>
>
> Justin.
>

