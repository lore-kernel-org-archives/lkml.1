Return-Path: <linux-kernel-owner+w=401wt.eu-S1760835AbYFVTTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760835AbYFVTTc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757239AbYFVTSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:18:07 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:22576 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760568AbYFVTSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:18:05 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: lmbench regression due to cond_resched nullification change 26-rc5 vs. 25
Date: Sun, 22 Jun 2008 21:17:59 +0200
User-Agent: KMail/1.9.9
References: <200806201014.43576.borntraeger@de.ibm.com> <alpine.LFD.1.10.0806201153470.3167@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806201153470.3167@woody.linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806222117.59620.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 20. Juni 2008 schrieben Sie:
> But quite frankly, regardless of exactly why it happens, it absolutely 
> makes no sense to even have that cond_resched() in the _innermost_ loop - 
> the one that is called for every single fd. It's much better to move the 
> conditional reschedule out a bit.
> 
> That inner loop was very much designed to compile into nice assembly 
> language, and it's possible that the cond_resched() simply causes extra 
> register pressure and keeps us from keeping the bitmasks in registers etc.
> 
> So this trivial patch, which moves the cond_resched() to be outside the 
> single-word select() loop, would be a good idea _regardless_. Does it make 
> any difference for you? If it's purely a "code generation got worse" 
> issue, it should help a bit.

Yes, it helps. I am now at 24 microseconds which is very close to the original 
time for lat_select.

Thanks

