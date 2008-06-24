Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbYFXSAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbYFXSAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 14:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756691AbYFXSAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 14:00:32 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:12174 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759338AbYFXSAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 14:00:30 -0400
Message-ID: <48613635.70103@colorfullife.com>
Date: Tue, 24 Jun 2008 20:00:21 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Solofo.Ramangalahy@bull.net
CC: linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>, Nadia Derbey <Nadia.Derbey@bull.net>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [RFC -mm 0/6] sysv ipc: scale msgmnb with the number of cpus
References: <20080605145712.116223941@bull.net> <484A9D52.2020703@colorfullife.com> <18527.41440.273383.388943@frecb006361.adech.frec.bull.fr>
In-Reply-To: <18527.41440.273383.388943@frecb006361.adech.frec.bull.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Solofo.Ramangalahy@bull.net wrote:
> Humm... now this make me think that you did not change the MSGMNB
> value when you changed MSGMNI and MSGMAX.
> Maybe that was on purpose?
>
>   
I was afraid that it might break user space applications that queue a 
few kb of messages.
That's also the reason for
>                 if (msgsz + msq->q_cbytes <= msq->q_qbytes &&
>                                 1 + msq->q_qnum <= msq->q_qbytes) {
>                         break;
>                 }
It's possible to send 0-byte messages even if the  message queue is full 
[except that you can't send more than MSGMNB messages].

--
    Manfred
