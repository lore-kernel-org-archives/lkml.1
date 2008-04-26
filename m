Return-Path: <linux-kernel-owner+w=401wt.eu-S1762684AbYDZVK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762684AbYDZVK6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 17:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYDZVKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 17:10:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbYDZVKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 17:10:50 -0400
Message-ID: <48139A35.6050608@zytor.com>
Date: Sat, 26 Apr 2008 14:10:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       jbarnes@virtuousgeek.org
Subject: Re: [git pull] "big box" x86 changes, boot protocol
References: <20080426185516.GA32364@elte.hu> <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org> <20080426195407.GA13729@elte.hu> <20080426133928.a6f40caa.akpm@linux-foundation.org> <20080426210632.GW2252@cs181133002.pp.htv.fi>
In-Reply-To: <20080426210632.GW2252@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
>>> +	memcpy(&early_res[i], &early_res[i + 1],
>>> +	       (j - 1 - i) * sizeof(struct early_res));

>> nit: memcpy() shouldn't be used for overlapping copies.  It happens to be
>> OK (for dst<src) in the kernel implementations.  We hope.
>> ...
> 
> We always use the gcc builtin for memcpy() here.
> 

You have to do something pretty weird for memcpy() to not work for
dst <= src even with overlap; this usually involves architectures that 
have explicit cache control instructions to establish the dst in the 
cache, if used before src is read.

This is not an issue on x86, though.

	-hpa
