Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbYDROnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbYDROnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 10:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbYDROnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 10:43:12 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:23145 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbYDROnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 10:43:11 -0400
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, stable@kernel.org
Message-Id: <8C8966B6-0A42-410B-BD66-1D7C79D6A302@oracle.com>
From: Chuck Lever <chuck.lever@oracle.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
In-Reply-To: <1208469997.5375.4.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: SUNRPC: Fix a memory leak in rpc_create()
Date: Fri, 18 Apr 2008 10:42:19 -0400
References: <20080417010122.148289106@sous-sol.org> <20080417010354.950049854@sous-sol.org>  <200804172325.39462.s.L-H@gmx.de> <1208469997.5375.4.camel@heimdal.trondhjem.org>
X-Mailer: Apple Mail (2.919.2)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 17, 2008, at 6:06 PM, Trond Myklebust wrote:
> On Thu, 2008-04-17 at 23:25 +0200, Stefan Lippers-Hollmann wrote:
>> Hi
>>
>> On Donnerstag, 17. April 2008, you wrote:
>>> -stable review patch.  If anyone has any objections, please let us  
>>> know.
>>> ---------------------
>>>
>>> From: Chuck Lever <chuck.lever@oracle.com>
>>>
>>> upstream commit: ed13c27e546667fb0967ae30f5070cd7f6455f90
>>>
>>> Commit 510deb0d was supposed to move the xprt_create_transport()  
>>> call in
>>> rpc_create(), but neglected to remove the old call site.  This  
>>> resulted in
>>> a transport leak after every rpc_create() call.
>>>
>>> This leak is present in 2.6.24 and 2.6.25.
>>
>> This patch might introduce a regression:
>>
>
> Gah. You're quite right. The commit that introduced the leak was  
> merged
> well after 2.6.24 was released despite what the changelog entry says
> above:
>
> $ git describe 510deb0d
> v2.6.24-3933-g510deb0
>
> I should have double-checked before posting this to stable@kernel.org.
> I'm very sorry...

I guessed it was required for 2.6.24 based on the patch dates (and a  
fuzzy recollection of which release the "bad" commit went in).  The  
date on the "bad" commit was before the release of 2.6.24, so I  
assumed the fix should be applied in 2.6.24 as well.

Mea culpa.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
