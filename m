Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbYIEUlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbYIEUlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 16:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbYIEUld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 16:41:33 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:31617 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYIEUlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 16:41:32 -0400
Cc: Neil Brown <neilb@suse.de>,
       Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       LKML Kernel <linux-kernel@vger.kernel.org>
Message-Id: <04854041-E23D-48B5-B9FF-0B7ECEB2C371@oracle.com>
From: Chuck Lever <chuck.lever@oracle.com>
To: Aaron Straus <aaron@merfinllc.com>
In-Reply-To: <20080905200455.GH22796@merfinllc.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v928.1)
Subject: Re: [NFS] blocks of zeros (NULLs) in NFS files in kernels >= 2.6.20
Date: Fri, 5 Sep 2008 16:36:46 -0400
References: <20080905191939.GG22796@merfinllc.com> <0A24B45A-9761-4310-B1DB-B4738964E862@oracle.com> <20080905200455.GH22796@merfinllc.com>
X-Mailer: Apple Mail (2.928.1)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 5, 2008, at Sep 5, 2008, 4:04 PM, Aaron Straus wrote:
> Hi,
>
> On Sep 05 03:56 PM, Chuck Lever wrote:
>> [ replacing cc: nfs@sf.net with linux-nfs@vger.kernel.org, and neil's
>> old address with his current one ]
>
> Sorry I probably grabbed an old MAINTAINERS file.
>
>> On Sep 5, 2008, at Sep 5, 2008, 3:19 PM, Aaron Straus wrote:
>>> Writer_Version     Outcome:
>>> <= 2.6.19          OK
>>>> = 2.6.20	    BAD
>>
>> Up to which kernel?  Recent ones may address this issue already.
>
> BAD up to 2.6.27-rc?
>
> I have to see exactly which is the last rc version I tested.
>
>>> I can try to bisect between 2.6.19 <-> 2.6.20.
>>
>> That's a good start.
>
> OK will try to bisect.
>
>> Comparing a wire trace with strace output, starting with the writing
>> client, might also be illuminating.  We prefer wireshark as it uses
>> good default trace settings, parses the wire bytes and displays them
>> coherently, and allows you to sort the frames in various useful ways.
>
> OK.  Could you also try to reproduce on your side using those python
> programs?  I want to make sure it's not something specific with our
> mounts, etc.

I have the latest Fedora 9 kernels on two clients, mounting via NFSv3  
using "actimeo=600" (for other reasons).  The server is OpenSolaris  
2008.5.

reader.py reported zeroes in the test file after about 5 minutes.

Looking at the file a little later, I don't see any problems with it.

Since your scripts are not using any kind of serialization (ie file  
locking) between the clients, I wonder if non-determinant behavior is  
to be expected.

-- 
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
