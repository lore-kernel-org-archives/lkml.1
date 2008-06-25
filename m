Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbYFYGVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbYFYGVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 02:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYFYGVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 02:21:23 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48213 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYFYGVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 02:21:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18529.58173.415727.712894@frecb006361.adech.frec.bull.fr>
Date: Wed, 25 Jun 2008 08:18:37 +0200
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Solofo.Ramangalahy@bull.net, linux-kernel@vger.kernel.org,
       Matt Helsley <matthltc@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [RFC -mm 0/6] sysv ipc: scale msgmnb with the number of cpus
In-Reply-To: <48613635.70103@colorfullife.com>
References: <20080605145712.116223941@bull.net>
	<484A9D52.2020703@colorfullife.com>
	<18527.41440.273383.388943@frecb006361.adech.frec.bull.fr>
	<48613635.70103@colorfullife.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
From: Solofo.Ramangalahy@bull.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul writes:
 > > Humm... now this make me think that you did not change the MSGMNB
 > > value when you changed MSGMNI and MSGMAX.
 > > Maybe that was on purpose?
 > >
 > >   
 > I was afraid that it might break user space applications that queue a 
 > few kb of messages.

Ok, the choice of a maximum value of 65536 which is already is use for
several months/years was made partly for the same concern.
Beside, as the values are not enforced, we should be relatively safe.

Searching the archives, I also found usage of a value "around a MB".

 > That's also the reason for
 > >                 if (msgsz + msq->q_cbytes <= msq->q_qbytes &&
 > >                                 1 + msq->q_qnum <= msq->q_qbytes) {
 > >                         break;
 > >                 }
 > It's possible to send 0-byte messages even if the  message queue is full 
 > [except that you can't send more than MSGMNB messages].

Thanks for this information. I should add that I checked that no
regression was introduced with ltp-full-20080531, but I did not look
more closely (e.g. coverage of this part of the code).

-- 
solofo
