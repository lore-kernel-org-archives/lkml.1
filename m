Return-Path: <linux-kernel-owner+w=401wt.eu-S932753AbZHNR5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbZHNR5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 13:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932736AbZHNR5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 13:57:53 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:53134 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932735AbZHNR5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 13:57:53 -0400
Message-ID: <4A85A47D.5080600@colorfullife.com>
Date: Fri, 14 Aug 2009 19:53:01 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Zach Brown <zach.brown@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] ipc: sem optimise simple operations
References: <20090811110902.255877673@suse.de> <20090811111607.310739140@suse.de> <4A81B646.5060301@colorfullife.com> <4A81B728.7040200@oracle.com> <20090812040756.GA5330@wotan.suse.de> <4A830B8C.5000402@colorfullife.com> <20090814085841.GF32342@wotan.suse.de>
In-Reply-To: <20090814085841.GF32342@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2009 10:58 AM, Nick Piggin wrote:
> I do like how it cleanly splits the modify and non-modify operations
> though. But if you feel strongly about saving the sapce, I will
> do as you suggest.
>
>    
No, saving space is secondary.

IMHO the global and the local lists should use the same algorithm, 
that's the main point.
Perhaps even the same function could be used:
One global struct sem_waiters {struct list_head zero; struct list_head 
decrease}.
One struct sem_waiters for each semaphore.

Then something like

     update_queue(sma, sma->complex_ops ? &sma->global_waiters : 
&sma->sem_base[i].local_waiters);

--
     Manfred
