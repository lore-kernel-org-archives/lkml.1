Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbYH1WAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbYH1WAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 18:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755908AbYH1WAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 18:00:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835AbYH1WAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 18:00:30 -0400
Message-ID: <48B71FFA.9050801@redhat.com>
Date: Thu, 28 Aug 2008 18:00:26 -0400
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20080715)
MIME-Version: 1.0
To: Joe Korty <joe.korty@ccur.com>
CC: "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NFSv3: cached permissions subset enhancement, v2
References: <20080827142820.GA22661@tsunami.ccur.com> <2BBFD074-16C3-4640-8F3D-DF604F4146A7@netapp.com> <20080828182848.GA19286@tsunami.ccur.com> <20080828205727.GA21880@tsunami.ccur.com>
In-Reply-To: <20080828205727.GA21880@tsunami.ccur.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Korty wrote:
> On Thu, Aug 28, 2008 at 02:28:48PM -0400, Joe Korty wrote:
>   
>> On Thu, Aug 28, 2008 at 12:03:47PM -0400, Myklebust, Trond wrote:
>>     
>>> This isn't a good solution. The correct thing to do here is to resend
>>> the request for just those permissions that the VFS requested.
>>>       
>> Is there any chance that the cached permissions are shared amoung
>> multiple open(2)'s of the same file?  If sharing happens then we
>> really need to cache all of MAY_EXEC | MAY_WRITE | MAY_READ, rather
>> than just that subset asked for by the open(2) that happens to
>> be the one filling in the cache.
>>
>> In any case, I've rewritten the patch per the above suggestion, and
>>     
>
>
> Hi Trond,
> I've tested the new patch with the test sequence mentioned in the
> original customer bug report, and it seems to work.

It would also be good to pursue getting that NFS server fixed.
It is not protocol compliant.  That's not the way that the
ACCESS operation is specified to work.  The server explicitly
should not return NFS3ERR_ACCESS when access is denied.  The
status portion of the return is supposed to indicate the success
or failure of the ACCESS operation itself, not the access
rights that a process may have w.r.t. a file.  The bitmask is
to be used for that.

       ps
