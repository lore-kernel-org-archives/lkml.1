Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbZFEKhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbZFEKhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 06:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZFEKhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 06:37:01 -0400
Received: from electron.quantumfyre.co.uk ([87.106.55.16]:37952 "EHLO
	electron.quantumfyre.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751889AbZFEKhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 06:37:00 -0400
Date: Fri, 5 Jun 2009 11:36:58 +0100 (BST)
From: Julian Phillips <julian@quantumfyre.co.uk>
X-X-Sender: jp3@reaper.quantumfyre.co.uk
To: Robert Hancock <hancockrwd@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: A question about using a private anonymous mmap
In-Reply-To: <4A2865BF.1080301@gmail.com>
Message-ID: <alpine.LNX.2.00.0906051134410.7822@reaper.quantumfyre.co.uk>
References: <alpine.LNX.2.00.0906041740110.21303@reaper.quantumfyre.co.uk> <4A2865BF.1080301@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009, Robert Hancock wrote:

> Julian Phillips wrote:
>>  I have a program which creates a reasonably large private anonymous map.
>>  The program then writes into a few places in the map, but ends up reading
>>  from all of them.
>>
>>  When I run this program on a system running 2.6.20.7 the process only ever
>>  seems to use enough memory to hold the data that has actually been written
>>  (well - in units of PAGE_SIZE).  When I run the program on a system
>>  running 2.6.24.5 then as it reads the map the amount of memory used
>>  continues to increase until the complete map has actually been allocated
>>  (and since the total size is greater than the physically available RAM
>>  causes swapping).  Basically I seem to be seeing copy-on-read instead of
>>  copy-on-write type behaviour.
>>
>>  Is this an expected change, and is there any option I can tweak to get the
>>  old behaviour back?
>
> Looks like this was as a result of the ZERO_PAGE removal:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=557ed1fa2620dc119adb86b34c614e152a629a80
>
> The commit comment notes: "Inserting a ZERO_PAGE for anonymous read faults 
> appears to be a false optimisation: if an application is performance 
> critical, it would not be doing many read faults of new memory, or at least 
> it could be expected to write to that memory soon afterwards. If cache or 
> memory use is critical, it should not be working with a significant number of 
> ZERO_PAGEs anyway (a more compact representation of zeroes should be used)."

That does seem to be the cause, or at least when I revert that commit I 
get the same behaviour from 2.6.24.5 as I do from 2.6.20.7.

Thanks.

-- 
Julian

  ---
If there is no wind, row.
 		-- Polish proverb
