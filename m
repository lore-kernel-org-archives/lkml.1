Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbYGUTsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbYGUTsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbYGUTsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:48:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754347AbYGUTsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:48:20 -0400
Date: Mon, 21 Jul 2008 12:47:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: Ingo Molnar <mingo@elte.hu>, Ian Schram <ischram@telenet.be>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       wireless <linux-wireless@vger.kernel.org>, j@w1.fi
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000370
In-Reply-To: <4884E6E6.7010800@lwfinger.net>
Message-ID: <alpine.LFD.1.10.0807211246280.31863@woody.linux-foundation.org>
References: <20080721134506.GA27598@elte.hu> <20080721143023.GA32451@elte.hu> <20080721150446.GA17746@elte.hu> <20080721.082419.70392960.davem@davemloft.net> <4884D2F1.2030704@telenet.be> <20080721190646.GA19044@elte.hu> <4884DFEE.4060003@lwfinger.net>
 <20080721193425.GA29287@elte.hu> <4884E6E6.7010800@lwfinger.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 Jul 2008, Larry Finger wrote:
> 
> Yes, I'm chasing a distinct bug. The header for mine is
> 
> Jul 21 12:19:37 larrylap kernel: kernel BUG at net/core/dev.c:1328!

Ok, that one is fixed now in my tree. Or at least it's turned into a 
warning, so the machine should work.

> With an invalid opcode, mine is likely due to stack corruption.

No, invalid opcode is because we use the "ud2" instruction for BUG(), 
which causes an invalid op exception. So any BUG[_ON]() will always cause 
that on x86.

		Linus
