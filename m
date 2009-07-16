Return-Path: <linux-kernel-owner+w=401wt.eu-S1755107AbZGPKgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbZGPKgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbZGPKgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:36:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64931 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028AbZGPKgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:36:07 -0400
Message-ID: <4A5F0293.3010206@vlnb.net>
Date: Thu, 16 Jul 2009 14:36:03 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ronald Moesbergen <intercommit@gmail.com>
CC: fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       Alan.Brunelle@hp.com, linux-fsdevel@vger.kernel.org,
       jens.axboe@oracle.com, randy.dunlap@oracle.com,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
References: <4A3CD62B.1020407@vlnb.net> <4A5395FD.2040507@vlnb.net>	 <a0272b440907080149j3eeeb9bat13f942520db059a8@mail.gmail.com>	 <4A5493A8.2000806@vlnb.net>	 <a0272b440907092332o7c5bf1d0oa51d1cfc9b9e98f5@mail.gmail.com>	 <4A56FF32.2060303@vlnb.net> <4A570981.5080803@vlnb.net>	 <a0272b440907130512y60a757afqd5629f4ca3ac8e1b@mail.gmail.com>	 <4A5CD3E2.2060307@vlnb.net> <4A5D7794.2070607@vlnb.net> <a0272b440907160032u482bd483s54540001aef7ac73@mail.gmail.com>
In-Reply-To: <a0272b440907160032u482bd483s54540001aef7ac73@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18V0Wey3P0jJ3RQ1slF6alSocV0HW0wL2csbQ9
 QNPcrehIzf8ZCCo9Grw3aeS000rsOANxh7GAhAnH+vQ3VX/ueR
 bqeZytctteHkEKUCWGh0g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ronald Moesbergen, on 07/16/2009 11:32 AM wrote:
> 2009/7/15 Vladislav Bolkhovitin <vst@vlnb.net>:
>>> The drop with 64 max_sectors_kb on the client is a consequence of how CFQ
>>> is working. I can't find the exact code responsible for this, but from all
>>> signs, CFQ stops delaying requests if amount of outstanding requests exceeds
>>> some threshold, which is 2 or 3. With 64 max_sectors_kb and 5 SCST I/O
>>> threads this threshold is exceeded, so CFQ doesn't recover order of
>>> requests, hence the performance drop. With default 512 max_sectors_kb and
>>> 128K RA the server sees at max 2 requests at time.
>>>
>>> Ronald, can you perform the same tests with 1 and 2 SCST I/O threads,
>>> please?
> 
> Ok. Should I still use the file-on-xfs testcase for this, or should I
> go back to using a regular block device?

Yes, please

> The file-over-iscsi is quite
> uncommon I suppose, most people will export a block device over iscsi,
> not a file.

No, files are common. The main reason why people use direct block 
devices is a not supported by anything believe that comparing with files 
they "have less overhead", so "should be faster". But it isn't true and 
can be easily checked.

>> With context-RA patch, please, in those and future tests, since it should
>> make RA for cooperative threads much better.
>>
>>> You can limit amount of SCST I/O threads by num_threads parameter of
>>> scst_vdisk module.
> 
> Ok, I'll try that and include the blk_run_backing_dev,
> readahead-context and io_context patches.
> 
> Ronald.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
