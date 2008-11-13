Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbYKMXEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbYKMXEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYKMXEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:04:35 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:57025 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbYKMXEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:04:34 -0500
Message-ID: <491CB27C.3090606@nortel.com>
Date: Thu, 13 Nov 2008 17:04:28 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Olaf van der Spek <olafvdspek@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unix sockets via TCP on localhost: is TCP slower?
References: <b2cc26e40811121520k711fa702u85e53bbc18b021a0@mail.gmail.com> <20081113112409.GK13263@ghostprotocols.net> <b2cc26e40811131106g7a1c46d0y89d24b11cb0570fb@mail.gmail.com>
In-Reply-To: <b2cc26e40811131106g7a1c46d0y89d24b11cb0570fb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Nov 2008 23:04:30.0410 (UTC) FILETIME=[2F3C22A0:01C945E4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf van der Spek wrote:
> On Thu, Nov 13, 2008 at 12:24 PM, Arnaldo Carvalho de Melo
> <acme@redhat.com> wrote:
>> Em Thu, Nov 13, 2008 at 12:20:44AM +0100, Olaf van der Spek escreveu:
>>> Hi,
>>>
>>> Quite often in discussions, I see people claiming Unix sockets are
>>> faster then TCP sockets on a connection that stays inside localhost.
>>> Let's say from app A to app B.
>>> Is this indeed the case and if so, how much and why?
>>> My assumption is that the kernel can optimize the 'connection' and let
>>> any performance differences disappear.
>> How much? Please measure.

Lmbench shows local tcp as noticeably slower than unix sockets on a Mac 
G5 running 2.6.27.


*Local* Communication latencies in microseconds - smaller is better
---------------------------------------------------------------
Host           OS 2p/0K  Pipe AF     UDP  RPC/   TCP  RPC/ TCP
                   ctxsw       UNIX         UDP         TCP conn
--------- ------- ----- ----- ---- ----- ----- ----- ----- ----
localhost 2.6.27  2.270  10.5 12.6  19.9  31.5  22.7  35.5  68.




*Local* Communication bandwidths in MB/s - bigger is better
-----------------------------------------------------------------------
Host          OS  Pipe AF    TCP  File   Mmap  Bcopy  Bcopy  Mem   Mem
                        UNIX      reread reread (libc) (hand) read write
--------- ------- ---- ---- ---- ------ ------ ------ ------ ---- -----
localhost 2.6.27  1368 1564 334. 1111.8 2068.8  930.3  947.0 2072 1269.




Chris
