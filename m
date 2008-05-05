Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbYEEKX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbYEEKX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 06:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbYEEKXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 06:23:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50082 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbYEEKXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 06:23:48 -0400
Message-ID: <481EE031.3090303@firstfloor.org>
Date: Mon, 05 May 2008 12:23:45 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH REPOST] CPA: Add statistics about state of direct mapping
 v4
References: <20080502094649.GA11185@basil.nowhere.org> <alpine.LFD.1.10.0805051208240.3318@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805051208240.3318@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> +static unsigned long direct_pages_count[PG_LEVEL_NUM];
>> +
>> +void __meminit update_page_count(int level, unsigned long pages)
> 
> Why __meminit ? This is used in split_large_page()

True. Can you please just remove it? I think it came when this
was still only used in early memory init.

[insert standard rant about the work:code size benefit ratio of these
fine grained section identifiers being far too high]

>> +{
>> +#ifdef CONFIG_PROC_FS
> 
> Why keep an empty function when PROC_FS is disabled ?

So we don't have to add a ifdef in all the callers. Yes could probably
have an empty inline in that case in some header, but frankly that would
be a lot of code lines for saving only very minor code size in a very
unlikely CONFIG case.

-Andi

