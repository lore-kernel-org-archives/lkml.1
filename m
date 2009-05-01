Return-Path: <linux-kernel-owner+w=401wt.eu-S1760633AbZEAMoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760633AbZEAMoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951AbZEAMoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:44:09 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:47263 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbZEAMoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:44:08 -0400
Message-ID: <49FAEE94.9030007@hp.com>
Date: Fri, 01 May 2009 08:44:04 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] blktrace: swap arg name "from" and "to" of 	blk_add_trace_remap
References: <20090430133627.D217.A69D9226@jp.fujitsu.com>	 <49F9D82D.50901@hp.com> <2f11576a0904301913h5aa0ed79gc8c5d98e71445858@mail.gmail.com>
In-Reply-To: <2f11576a0904301913h5aa0ed79gc8c5d98e71445858@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>> I believe this may be more messed up than you believe: Consider the last
>> function: blk_log_remap. Notice how you are printing the /device/ and
>> /sector_from/ as one pair. Isn't that confusing too: wouldn't one expect
>> /device_from/ and /sector_from/ to be paired up?
>>
>> I ran into this problem a long time ago - hence the current code in
>> blkparse contains:
>>
>>        if (act[0] == 'A') {    /* Remap */
>>                get_pdu_remap(t, &r);
>>                t->device = r.device_from;
>>        }
>>
>> Which puts the device_from out at the beginning of the line, and then
>> the 'device' + 'sector' (== 'sector_from') out at the end of the line.
>> (Which, of course, is all confusing.)
> 
> Good viewpoint!
> Currently, 99% blktrace user use blktrace and blkparse command, not
> ftrace framework.
> So, ABI changing is proper way?
> 
> I'd like to hear Jens and Li opinion.

I'll hold off reposting until Jens and Li concur.
Alan
