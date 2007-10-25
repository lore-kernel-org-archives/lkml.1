Return-Path: <linux-kernel-owner+w=401wt.eu-S1760429AbXJYIVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760429AbXJYIVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbXJYIVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:21:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60474 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbXJYIU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:20:59 -0400
Message-ID: <472051E8.2070005@garzik.org>
Date: Thu, 25 Oct 2007 04:20:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org
Subject: Re: [PATCH] Permit silencing of __deprecated warnings.
References: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org>	<41621d56a0a0e4e5f861e1725f18990df5e927ad.1193299380.git.jeff@garzik.org> <20071025011516.aea17222.akpm@linux-foundation.org>
In-Reply-To: <20071025011516.aea17222.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 25 Oct 2007 04:06:13 -0400 (EDT) Jeff Garzik <jeff@garzik.org> wrote:
> 
>> The __deprecated marker is quite useful in highlighting the remnants of
>> old APIs that want removing.
>>
>> However, it is quite normal for one or more years to pass, before the
>> (usually ancient, bitrotten) code in question is either updated or
>> deleted.
>>
>> Thus, like __must_check, add a Kconfig option that permits the silencing
>> of this compiler warning.
>>
>> This change mimics the ifdef-ery and Kconfig defaults of MUST_CHECK as
>> closely as possible.
> 
> Sigh.  Can't we just fix the dud code?  Or mark it BROKEN and see what
> happens?

__deprecated has spread to just about every API that people don't 
consider fresh and up-to-date.

Like I noted in the patch description, rewriting grotty ISA/MCA/etc. 
probe code is a thankless, boring task that few are crazy enough to 
attempt :)

As you can see from the patch flood recently I /have/ been working 
through the dud code, but it will still take years.  The changes 
required for each are on average ~200 LOC changed, if not more.

But regardless...  I don't see any reason to force every kernel build to 
remind us of grotty drivers.  Where's the benefit?  Everybody knows they 
are grotty.

Like __must_check this option defaults to the current state of things -- 
warnings -- so you have to take an extra step to turn them off.

	Jeff



