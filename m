Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbYFYKMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbYFYKMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 06:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbYFYKMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 06:12:05 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:44885 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbYFYKMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 06:12:03 -0400
Message-ID: <48621A01.8090803@bull.net>
Date: Wed, 25 Jun 2008 12:12:17 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Solofo.Ramangalahy@bull.net, linux-kernel@vger.kernel.org,
       Matt Helsley <matthltc@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [RFC -mm 0/6] sysv ipc: scale msgmnb with the number of cpus
References: <20080605145712.116223941@bull.net> <484A9D52.2020703@colorfullife.com> <18527.41440.273383.388943@frecb006361.adech.frec.bull.fr> <48613635.70103@colorfullife.com>
In-Reply-To: <48613635.70103@colorfullife.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul wrote:
> Solofo.Ramangalahy@bull.net wrote:
> 
>> Humm... now this make me think that you did not change the MSGMNB
>> value when you changed MSGMNI and MSGMAX.
>> Maybe that was on purpose?
>>
>>   
> 
> I was afraid that it might break user space applications that queue a 
> few kb of messages.
> That's also the reason for
> 
>>                 if (msgsz + msq->q_cbytes <= msq->q_qbytes &&
>>                                 1 + msq->q_qnum <= msq->q_qbytes) {
>>                         break;
>>                 }
> 
> It's possible to send 0-byte messages even if the  message queue is full 
> [except that you can't send more than MSGMNB messages].
> 

Manfred,

If I'm not missign anything when reading the code, sending up to MSGMNB 
0-bytes messages would make us enqueue MSGMNB msg_msg structures (this 
is in the worst case where no receiver is waiting for those messages).
==> MSGMNB * 24 bytes (or 48 bytes in 64-bit mode))
==> 384 KB with current MSGMNB value (16K).

But 1,5 MB with a MSGMNB=64K

Even if it is a worst case, it should be considered and may be we should 
refine the formula Solofo has proposed if you think this is not a 
reasonable value.
May be add a dependency on the memory size?

Regards,
Nadia
