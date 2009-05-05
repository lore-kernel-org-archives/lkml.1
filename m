Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbZEEAX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbZEEAX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 20:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbZEEAXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 20:23:47 -0400
Received: from services110.cs.uwaterloo.ca ([129.97.152.166]:44304 "EHLO
	services110.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754098AbZEEAXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 20:23:47 -0400
Message-ID: <49FF8743.1090704@uwaterloo.ca>
Date: Mon, 04 May 2009 20:24:35 -0400
From: Elad Lahav <elahav@uwaterloo.ca>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Elad Lahav <elahav@cs.uwaterloo.ca>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] Implementation of the sendgroup() system call
References: <49FE47A1.7070700@uwaterloo.ca> <87eiv5ibnd.fsf@basil.nowhere.org> <20090504094431.174745mb0jhhm3s4@www.nexusmail.uwaterloo.ca> <20090504145046.GI23223@one.firstfloor.org>
In-Reply-To: <20090504145046.GI23223@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Miltered: at mailchk-m03 with ID 49FF870A.000 by Joe's j-chkmail (http://j-chkmail.ensmp.fr)!
X-UUID: 1d953e2b-ec58-4336-857b-545d64e2ebd3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How much is non negligible in your case?
Please see the following link

http://www.cs.uwaterloo.ca/~elahav/sendgroup/mb_pkt_size.pdf

for a graph showing the (amortised) cost of sending a single packet to a 
group of 1000 recipients, using one of the three following methods:

1. A user-mode loop of sendmsg() calls
2. A kernel-mode loop of udp_sendmsg() calls
3. A single call to sendgroup()
The cost is measured in cycles and was determined using performance 
counters.

In this benchmark, savings introduced by sendgroup() are primarily due 
to the aviodence of multiple system calls, up to a packet size of about 
1000 bytes. Obviously, proportions change for different group sizes 
(though we were able to outperform method 1 with a group size as small 
as 2).

--Elad
