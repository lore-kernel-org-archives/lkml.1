Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbYLOVs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbYLOVs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 16:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482AbYLOVsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 16:48:51 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44901 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378AbYLOVsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 16:48:50 -0500
Message-ID: <4946CFCC.7040805@cs.helsinki.fi>
Date: Mon, 15 Dec 2008 23:44:44 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: Ottavio Campana <ottavio.campana@dei.unipd.it>
CC: linux-kernel@vger.kernel.org, error27@gmail.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, Greg KH <greg@kroah.com>
Subject: Re: Oops when trying to create more than 16000 timers
References: <49468024.1020700@dei.unipd.it>	 <84144f020812150845g10a1ce26ke2844ab495d2591b@mail.gmail.com>	 <4946CEF1.6060405@dei.unipd.it> <84144f020812151337r79268169xf77f2e6f547a51e5@mail.gmail.com> <4946DE5C.8060504@dei.unipd.it>
In-Reply-To: <4946DE5C.8060504@dei.unipd.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ottavio,

Pekka Enberg wrote:
>> I think you're simply hitting RLIMIT_SIGPENDING and then tripping over
>> a bug in alloc_posix_timer() that's fixed by commit
>> aa94fbd5ccd840c8ab26d02439ec799b03a72547 ("fix error-path NULL deref
>> in alloc_posix_timer()") in 2.6.28-rc8.
>>
>> Dan, can you please send your patch to the -stable queue as well?

Ottavio Campana wrote:
> Pekka, can this RLIMIT_SIGPENDING be modified? For my application, I
> will need 60k timers.

I'd assume you can do that via the setrlimit() system call. See the man 
page for details.
