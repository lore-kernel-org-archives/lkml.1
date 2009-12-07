Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbZLGFd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbZLGFd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 00:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZLGFd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 00:33:27 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:49125 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbZLGFd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 00:33:26 -0500
Message-ID: <4B1C93E0.4070806@xenontk.org>
Date: Mon, 07 Dec 2009 11:04:24 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.4pre) Gecko/20091014 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jonathan Miles <jon@cybus.co.uk>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: OOM kernel behaviour
References: <4B1402FC.80307@cybus.co.uk> <4B1537CA.7020107@xenontk.org> <alpine.DEB.2.00.0912011007360.8841@router.home> <4B154E10.7050300@xenontk.org> <alpine.DEB.2.00.0912011124490.10426@router.home> <20091202155537.GH1457@csn.ul.ie>
In-Reply-To: <20091202155537.GH1457@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2009 09:25 PM, Mel Gorman wrote:
> On Tue, Dec 01, 2009 at 11:26:37AM -0600, Christoph Lameter wrote:
>> On Tue, 1 Dec 2009, David John wrote:
>>
>>> Here are three logs from three days. Log3.txt is today's log and the OOM
>>> killer murdered Thunderbird as I was attempting to write this message.
>>> The kernel config is also attached.
>>
>> Hmmm... This is all caused by the HIGHMEM zone freecount going beyond min
>> which then triggers reclaim which for some reason fails (should not there
>> is sufficient material there to reclaim). There is enough memory in the
>> NORMAL zone. Wonder if something broke in 2.6.31 in reclaim? Mel?
>>
> 
> I'm not aware of breakage of that level, nor do I believe the page
> allocator problems are related to this bug.
> 
> However, I just took a look at the logs from the three days and I see
> things like
> 
> Nov 25 23:58:53 avalanche kernel: Free swap  = 0kB
> Nov 25 23:58:53 avalanche kernel: Total swap = 2048248kB
> 
> 
> Something on that system is leaking badly. Do something like
> 
> ps aux --sort vsz
> 
> and see what process has gone mental and is consuming all of swap. It's
> possible that the OOM killer is triggering too easily but it's possible
> that a delayed triggering of the OOM killer would have been just that -
> a delay. Eventually all memory and all swap would be used.
> 

Hi All,

It is a leak in Compiz. Killing and restarting Compiz frees up the swap.
The issue is better in 2.6.32 for some reason. The funny thing is I've
been using Compiz with 2.6.31 for a couple of months now, with no
updates to either, so I'm not sure what triggered this problem.

Regards,
David.
