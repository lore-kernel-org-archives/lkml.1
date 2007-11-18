Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbXKRTi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbXKRTi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 14:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbXKRTiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 14:38:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56823 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbXKRTiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 14:38:20 -0500
Message-ID: <47409484.8040304@zytor.com>
Date: Sun, 18 Nov 2007 11:37:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv3 0/4] sys_indirect system call
References: <200711170531.lAH5VaXR025225@devserv.devel.redhat.com> <473FED5F.2010303@zytor.com> <474007B3.30205@redhat.com>
In-Reply-To: <474007B3.30205@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> H. Peter Anvin wrote:
>> It seems to me that we could accomplish the same thing by passing the
>> number of parameters in the upper bits of the system call number
>> register (%eax in the case of x86.)
> 
> This isn't really a generic solution.  The number of parameters is
> limited to six.  There are syscalls with six parameters already.  There
> are many more with five which could only handle one more parameter.
> 
> Also, is it really simpler?  You'd need to have another table which
> contains the default number of parameters a system call takes so that
> you can fill in the default value of zero.  This extra memory access has
> to be performed for every system call.
> 
> I think it is unlikely that this approach is faster.  To the contrary,
> I'd guess.
> 
> I don't have much invested into this but it seems the sys_indirect
> approach is so much simpler.  Overhead is only paid if you really need
> it which is rarely the case.  Plus, you might have heard Linus and Zack
> talk about syslets again.  Starting syslets can be done using the same
> interface, I guess.
> 

What bothers me about the sys_indirect approach is that it will get 
increasingly expensive as time goes on, and in doing so it does a 
user-space memory reference, which are extra expensive.  The extra table 
can be colocated with the main table (a structure, in effect) so they'll 
share the same cache line.

	-hpa
