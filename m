Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbYJHEvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbYJHEvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 00:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYJHEvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 00:51:07 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:35450 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbYJHEvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 00:51:06 -0400
Message-Id: <6.0.0.20.2.20081008132532.056cc400@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Wed, 08 Oct 2008 13:48:10 +0900
To: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, torvalds@linux-foundation.org
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on
  32bit arch
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
In-Reply-To: <200810081335.44576.nickpiggin@yahoo.com.au>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2>
 <20081007105056.16d9e785.akpm@linux-foundation.org>
 <1223405963.26330.83.camel@lappy.programming.kicks-ass.net>
 <200810081335.44576.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: IMSS-7.0.0.1640-5.5.0.1026-16204.003
X-TM-AS-Result: No--20.986-5.0-31-1
X-imss-scan-details: No--20.986-5.0-31-1;No--20.986-5.0-31-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At 11:35 08/10/08, Nick Piggin wrote:
>On Wednesday 08 October 2008 05:59, Peter Zijlstra wrote:
>>
>> The whole point is that such usage is outside the specification and thus
>> we don't strictly need to fix this.
>>
>> So the question Nick is asking is, do we want to slow down the kernel
>> for a few broken user-space applications. Esp. since the race doesn't
>> affect anybody else except the broken users of the file descriptor.
>
>Right you are. That's the fundamental question. The actual details of
>the fix and how likely the race is don't really matter until we
>answer the first question (except to say that the "fix" is never going
>to be free).

Simultaneous access by two or more writer can corrupt file content,
so this case needs some locks(flock or fcntl) to preserve synchronization
of file content. This is responsibility of user-space application.
But file->f_pos race issue can occur even if multiple threads just read 
simultaneously. I think this is not responsibility of user-space application. 
To avoid this currently, an application needs some locks to protect file offset
even if it just read a file. So I think f_pos race should be fixed.

