Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbYF2FOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbYF2FOK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 01:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbYF2FN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 01:13:59 -0400
Received: from gw.goop.org ([64.81.55.164]:35475 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbYF2FN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 01:13:58 -0400
Message-ID: <48671A12.90205@goop.org>
Date: Sat, 28 Jun 2008 22:13:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <4866F6FE.9000503@goop.org> <486704AC.2090207@qumranet.com>
In-Reply-To: <486704AC.2090207@qumranet.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>>
>> Yes, it's intended behaviour.  Filesystem IO syscalls are considered 
>> "fast" and are interruptible.  Usermode code can reasonably expect 
>> that file IO will never return EINTR.
>
> That's filesystem dependent; if you mount an nfs filesystem with the 
> 'intr' mount option, it will be interruptible (which makes sense, as 
> it is impossible to guarantee the server's responsiveness).

'intr' is a pretty bad idea, and I would never recommend it ('soft' is 
better).  It's an excellent way to destroy data when a stray signal 
causes a syscall to fail with EINTR in an unexpected way (write being 
the obvious one, but link, unlink, truncate or even close can fail in 
odd ways can cause havok).

I don't know of any other filesystem with a similarly bad option.

    J
