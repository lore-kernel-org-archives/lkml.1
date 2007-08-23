Return-Path: <linux-kernel-owner+w=401wt.eu-S1764263AbXHWQfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764263AbXHWQfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 12:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764760AbXHWQe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 12:34:56 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:64370 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764953AbXHWQez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 12:34:55 -0400
Message-ID: <46CDB733.2000506@cfl.rr.com>
Date: Thu, 23 Aug 2007 12:34:59 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Martin Vogt <vogt@itwm.fraunhofer.de>
CC: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: fs corruption by doing nothing
References: <46CD92B6.5090900@itwm.fraunhofer.de>
In-Reply-To: <46CD92B6.5090900@itwm.fraunhofer.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Aug 2007 16:35:02.0321 (UTC) FILETIME=[8DB4BA10:01C7E5A3]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15380.000
X-TM-AS-Result: No--6.803100-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Vogt wrote:
> 
> Hello,
> 
> this bug report describes the following scenario:
> 
> - Insert a Knoppix 5.1.1 CD
>   into a fileserver with a clean reiserfs system and
>   Knoppix completely destroys the reiser filesystem on the fileserver,
>   just by booting Knoppix.
> 
> 
> Its unclear if this is a knoppix bug, but reiserfs
> simply tries to "correct something" which is wrong.
> 
>> ReiserFS: sda2: found reiserfs format "3.6" with standard journal
>> ReiserFS: sda2: using ordered data mode
>> ReiserFS: sda2: warning: sh-461: journal_init: wrong transaction max size
>> (144767). Changed to 1024
> 
> ^^^^^^^^^^here
> 
>> ReiserFS: sdb2: found reiserfs format "3.6" with standard journal
>> ReiserFS: sdb2: using ordered data mode
>> ReiserFS: sdb2: warning: sh-461: journal_init: wrong transaction max size
>> (144767). Changed to 1024
> 
> ^^^^^^^^^^here
> 
> After that the filesystem is completely broken.

Looks to me that there are two bugs here.  The first is with knoppix as 
it is mounting each individual mirrored disk instead of the raid device. 
  The second appears to be in the kernel as it is detecting and 
correcting what it thinks is an error but isn't.


