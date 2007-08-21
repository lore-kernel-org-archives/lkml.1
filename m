Return-Path: <linux-kernel-owner+w=401wt.eu-S932338AbXHUS13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338AbXHUS13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 14:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762545AbXHUS1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 14:27:16 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:39516 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760790AbXHUS1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 14:27:14 -0400
Message-ID: <46CB2E7B.70103@linux.vnet.ibm.com>
Date: Tue, 21 Aug 2007 23:57:07 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Jonathan Lim <jlim@sgi.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Send exit code through for taskstats.ac_exitcode
References: <200708211824.l7LIO10g379050@sabah.engr.sgi.com>
In-Reply-To: <200708211824.l7LIO10g379050@sabah.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Lim wrote:
> On Mon Aug 20 20:44:13 2007, balbir@linux.vnet.ibm.com wrote:
>> Jonathan Lim wrote:
>>> taskstats.ac_exitcode is assigned to task_struct.exit_code in
>>> bacct_add_tsk() through the following kernel function calls: 
>>>
>>>   do_exit()
>>>     taskstats_exit_send()
>>>       fill_pid()
>>>         bacct_add_tsk()
>>>
>>> The problem is that in do_exit(), task_struct.exit_code is set to 'code' 
>>> only after taskstats_exit_send() has been called.  So we need to send
>>> 'code' through to bacct_add_tsk().
>> Hi, Jonathan,
>>
>> The patches look like a step in the right direction, I would suggest an
>> alternate implementation
>>
>> Why can't we assign tsk->exit_code to code earlier? Can we not move up the
>> assignment to before taskstats_exit()? Wouldn't that be much simpler?
> 
> Hi Balbir,
> 
> That was what I wanted to do at first, but there was some concern over whether
> it would affect any of the intervening function calls.  If there's no
> particular reason why the tsk->exit_code assignment is placed where it's at
> now, then yes, I would much rather move it to before taskstats_exit().
> 
> I looked at the following functions involving tsk:
> 
>   exit_mm
>     mm_release
>       deactivate_mm
>   exit_sem
>   __exit_files
>   __exit_fs
>   cpuset_exit
>   exit_keys
> 
> and don't see anything that setting exit_code would affect.  What do you think?
> 

I think your search and analysis leads me to believe that, it might be the
correct thing to do. I would suggest we patch it that way and run a functional
test like LTP to ensure we did not break anything.

What do you think?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
