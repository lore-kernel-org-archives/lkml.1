Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbYHLCsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbYHLCsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 22:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbYHLCsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 22:48:32 -0400
Received: from sandeen.net ([209.173.210.139]:18971 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbYHLCsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 22:48:31 -0400
Message-ID: <48A0F9FC.1070805@sandeen.net>
Date: Mon, 11 Aug 2008 21:48:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Linda Walsh <lkml@tlinx.org>
CC: LKML <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
Subject: Re: Lock debugging noise or real problem?
References: <48A093A7.40606@tlinx.org> <48A09CA9.9080705@sandeen.net> <48A0F686.2090700@tlinx.org>
In-Reply-To: <48A0F686.2090700@tlinx.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh wrote:
> Eric Sandeen wrote:
>> the explanation for xfs_fsr, at least, is the same as the last time you
>> brought it up ;)
>> http://lkml.org/lkml/2008/2/12/86
>> -Eric
>>   
> ---
> Ah...Looks like the 1st xfs_fsr prob is the same as the one 6 months 
> ago...(sorry)
>     xfs_ilock & xfs_ilock
> 
> But... the 3 imapds and the sort process were all 4 holding
>      xfs_ilock     &    shrink_icache_memory
> 
> And the other two xfs_fsr's were holding different locks than the 
> 6-month-ago bug:
>     dio_get_page   &   xfs_ilock

> Are these the same as well?
> 
> I.e. looks like 3 possibly different probs:
>     #1 (same as 6 months ago)...
>     #2 (3)imapds & sort:      holding   xfs_ilock   &  shrink_icache
>     #3 xfs_fsr with two different locks:      dio_get_page   &   xfs_ilock> 

http://www.google.com/search?q=xfs_fsr+dio_get_page+lockdep

-> http://oss.sgi.com/archives/xfs/2008-01/msg00042.html

I haven't looked closely at #2 but there have been so many lockdep
reports for xfs, and so many explanations of why they don't always get
along, you'll probably be able to find something with some searching.

-Eric
