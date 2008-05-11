Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbYEKRYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbYEKRYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 13:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbYEKRX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 13:23:56 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:20263 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbYEKRXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 13:23:55 -0400
Date: Sun, 11 May 2008 11:25:49 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [2.6 patch] kernel/sched*: optimize inlining
In-reply-to: <fa.sBJgAJSNbPht40KbEGBXczzW3vQ@ifi.uio.no>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org
Message-id: <48272C1D.8020301@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.kBy7Kr77qTR+lDVDv4OKx7n5m1Y@ifi.uio.no>
 <fa.8/KGOoB8CQ+uVBJXmUNHaIfXQSg@ifi.uio.no>
 <fa.sBJgAJSNbPht40KbEGBXczzW3vQ@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sun, May 11, 2008 at 01:18:20PM +0200, Andreas Mohr wrote:
>> [manual reply, no access to original content]
>>
>> Hi,
>>
>> rather NACKish here (from my minor side, that is, since there are no
>> useful explanations, and in the case of a lack of explanations no
>> backing numbers either which would have been helpful to resolve this ;).
>>
>> "x86: add optimized inlining"
>> (http://kerneltrap.org/mailarchive/git-commits-head/2008/4/26/1612644)
>> does not really say anything relevant to your patch, AFAICS.
>>
>> That one simply says that previously every inline was force-inlined (ugh),
>> which now gcc is allowed to properly decide by itself now. This, however,
>> does _NOT_ imply that it's now somehow fully sufficient for a perfect outcome
>> to simply remove all open-coded "inline"s.
> 
> They both do the same - gcc is no longer forced to inline these 
> functions.
> 
> With either my patch or the "optimized inlining" it's 100% gcc's 
> choice whether or not to inline functions marked as "inline" in 
> kernel/sched* .
> 
> If you didn't complain when "x86: add optimized inlining" got into 
> Linus' tree you can't validly complain about my patch.

It's not really the same thing. Not forcing gcc to do the inlining where 
it's marked is one thing, but removing the hint to inline the function 
entirely is something else. In this case without the hint it clearly 
makes the wrong decision, since there is no reason to not inline a 
function that just calls another function.

GCC 4.3 is supposed to have some improvements in this area with 
pre-inline optimization and early inlining, but older gcc versions may 
still have this issue.
