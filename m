Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbYGUU2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbYGUU2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbYGUU2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:28:32 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:44749 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbYGUU2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:28:31 -0400
Message-ID: <4884F16D.7010709@lwfinger.net>
Date: Mon, 21 Jul 2008 15:28:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Ian Schram <ischram@telenet.be>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       wireless <linux-wireless@vger.kernel.org>, j@w1.fi
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000370
References: <20080721134506.GA27598@elte.hu> <20080721143023.GA32451@elte.hu> <20080721150446.GA17746@elte.hu> <20080721.082419.70392960.davem@davemloft.net> <4884D2F1.2030704@telenet.be> <20080721190646.GA19044@elte.hu> <4884DFEE.4060003@lwfinger.net> <20080721193425.GA29287@elte.hu> <4884E6E6.7010800@lwfinger.net> <alpine.LFD.1.10.0807211246280.31863@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807211246280.31863@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 21 Jul 2008, Larry Finger wrote:
>> Yes, I'm chasing a distinct bug. The header for mine is
>>
>> Jul 21 12:19:37 larrylap kernel: kernel BUG at net/core/dev.c:1328!
> 
> Ok, that one is fixed now in my tree. Or at least it's turned into a 
> warning, so the machine should work.
> 
>> With an invalid opcode, mine is likely due to stack corruption.
> 
> No, invalid opcode is because we use the "ud2" instruction for BUG(), 
> which causes an invalid op exception. So any BUG[_ON]() will always cause 
> that on x86.

Thanks for the explanation.

With your latest tree, I do get the warning. Unfortunately, it still breaks my 
wireless and I still need to do the bisection. That is complicated by getting a 
kernel that won't build after the first try. I think I now have a workaround.

Larry
