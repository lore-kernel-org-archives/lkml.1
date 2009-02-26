Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbZBZQ6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbZBZQ6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 11:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbZBZQ6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 11:58:37 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:39457 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988AbZBZQ6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 11:58:36 -0500
Message-ID: <49A6CA74.7000809@oracle.com>
Date: Thu, 26 Feb 2009 08:59:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Sachin P. Sant" <sachinp@in.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, ashwin.ganti@gmail.com
Subject: Re: [Staging/p9auth] Feb 26 Next: build failure
References: <20090226193022.adb78235.sfr@canb.auug.org.au> <49A67892.8060006@in.ibm.com> <20090226155355.GA22194@kroah.com>
In-Reply-To: <20090226155355.GA22194@kroah.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A01020A.49A6CA2D.0191:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Feb 26, 2009 at 04:40:10PM +0530, Sachin P. Sant wrote:
>> Feb 26 Next tree randconfig build fails with
>>
>> drivers/staging/p9auth/p9auth.c: In function cap_write:
>> drivers/staging/p9auth/p9auth.c:249: error: implicit declaration of 
>> function current_uid
>> drivers/staging/p9auth/p9auth.c:261: error: implicit declaration of 
>> function prepare_creds
>> drivers/staging/p9auth/p9auth.c:261: warning: assignment makes pointer from 
>> integer without a cast
>> drivers/staging/p9auth/p9auth.c:266: error: dereferencing pointer to 
>> incomplete type
>> drivers/staging/p9auth/p9auth.c:267: error: dereferencing pointer to 
>> incomplete type
>> drivers/staging/p9auth/p9auth.c:268: error: implicit declaration of 
>> function commit_creds
>> make[3]: *** [drivers/staging/p9auth/p9auth.o] Error 1
> 
> Wierd, I thought cred.h would be pulled in with the current include
> files.

Even if it were, that's not what we want.  We want explicit #includes
for macros or structs etc. that are used in a source file.

> With this .config, if you add:
> 	#include <linux/cred.h>
> to drivers/staging/p9auth/p9auth.c does it solve the build error?
> 
> I'll go add it just to be safe :)

It needs both cred.h and sched.h in my testing.


-- 
~Randy
