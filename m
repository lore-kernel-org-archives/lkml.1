Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbYKNIzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbYKNIzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 03:55:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbYKNIyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 03:54:53 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:35719 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbYKNIyw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 03:54:52 -0500
Message-ID: <491D3CD5.5020105@cosmosbay.com>
Date: Fri, 14 Nov 2008 09:54:45 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Olaf van der Spek <olafvdspek@gmail.com>
CC: "J.R. Mauro" <jrm8005@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unix sockets via TCP on localhost: is TCP slower?
References: <b2cc26e40811121520k711fa702u85e53bbc18b021a0@mail.gmail.com>	 <3aaafc130811131619w3ba48a86u6c6e2af35f149bf1@mail.gmail.com> <b2cc26e40811140051n4e821fddsc5504eedcccc9cdc@mail.gmail.com>
In-Reply-To: <b2cc26e40811140051n4e821fddsc5504eedcccc9cdc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 14 Nov 2008 09:54:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf van der Spek a écrit :
> On Fri, Nov 14, 2008 at 1:19 AM, J.R. Mauro <jrm8005@gmail.com> wrote:
>> On Wed, Nov 12, 2008 at 6:20 PM, Olaf van der Spek <olafvdspek@gmail.com> wrote:
>>> Hi,
>>>
>>> Quite often in discussions, I see people claiming Unix sockets are
>>> faster then TCP sockets on a connection that stays inside localhost.
>> Unix domain sockets should be faster because they're not subject to
>> windowing, ACKs, flow control, encapsulation, etc. etc.
> 
> Why would you use windowing, ACKs, flow control and encapsulation on localhost?
> 
> I expected the kernel to copy data directly from user-space of the
> sending process to a kernel buffer of the receiving process, much like
> UNIX sockets.
> 

localhost uses a standard network device, and whole network stack
is used, no 'special kludges'. You can add iptables rules, you
can do trafic shaping, trafic sniffing (tcpdump), limiting
memory used by all sockets (controlling memory pressure on the
machine)

Doing what you suggest would slow down AF_INET stack.

You probably can expect AF_UNIX to be faster, since this one is really 
special and use shortcuts.

Then, you probably can use shared memory instead of AF_UNIX, or
pipes (and splice()), or ...

Then you probably can use threads and do zero-copy ;)

