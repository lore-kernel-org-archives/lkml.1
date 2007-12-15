Return-Path: <linux-kernel-owner+w=401wt.eu-S1761663AbXLOSfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761663AbXLOSfx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 13:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbXLOSfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 13:35:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:4098 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbXLOSfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 13:35:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=jNkqT5/LEavXTNBrsou5zMt6zXMlNVNf9M7IE9RdwoZXFNfL/wrGVu8Ph/JVDl76uBe2hcVw5UqFacyg5MhW+8/My2hz9Q4kj/Z/XF3z54ve2eOJAb9DTb4aiAXAUZzSwWx+5D0FD8djNsm6V9ojyUlt1faAUL9vi8WSN0iWjM0=
Message-ID: <47642003.7090900@gmail.com>
Date: Sat, 15 Dec 2007 19:42:11 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Icedove 1.5.0.14pre (X11/20071020)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Miles Lane <miles.lane@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-rc5-mm1 -- inconsistent {in-softirq-W} -> {softirq-on-R}
   usage.
References: <a44ae5cd0712141413u4ddbfd06gca259cfc3bc0ab1a@mail.gmail.com>	<20071214153633.5d8f609a.akpm@linux-foundation.org>	<a44ae5cd0712141958o10d9a320h3b8173019ac6b0eb@mail.gmail.com> <20071215031341.66dc0d05.akpm@linux-foundation.org>
In-Reply-To: <20071215031341.66dc0d05.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote, On 12/15/2007 12:13 PM:

> On Fri, 14 Dec 2007 22:58:24 -0500 "Miles Lane" <miles.lane@gmail.com> wrote:



...

>> I applied the patch and then tried my test again.  This time my system
>> locked up.
>> Perhaps I should open a new thread for this, since the problem looks
>> pretty different.
>>
>> Dec 14 21:32:55 feargod kernel: process `cat' is using deprecated
>> sysctl (syscall) net.ipv6.neigh.default.retrans_time; Use
>> net.ipv6.neigh.default.retran
>> s_time_ms instead.
>> Dec 14 21:32:55 feargod kernel:
>> Dec 14 21:32:55 feargod kernel: =====================================
>> Dec 14 21:32:55 feargod kernel: [ BUG: bad unlock balance detected! ]
>> Dec 14 21:32:55 feargod kernel: -------------------------------------
>> Dec 14 21:32:55 feargod kernel: cat/6180 is trying to release lock
>> (kkkkkkk�����H3��) at:
>> Dec 14 21:32:55 feargod kernel: [packet_seq_stop+0xe/0x10]
>> packet_seq_stop+0xe/0x10
>> Dec 14 21:32:55 feargod kernel: but there are no more locks to release!
>> Dec 14 21:32:55 feargod kernel:
>> Dec 14 21:32:55 feargod kernel: other info that might help us debug this:
>> Dec 14 21:32:55 feargod kernel: 2 locks held by cat/6180:
>> Dec 14 21:32:55 feargod kernel:  #0:  (&p->lock){--..}, at:
>> [crypto_algapi:seq_read+0x25/0x191c1] seq_read+0x25/0x26f
>> Dec 14 21:32:55 feargod kernel:  #1:
>> (&net->packet.sklist_lock){-.--}, at: [packet_seq_start+0x14/0x4d]
>> packet_seq_start+0x14/0x4d



Miles, I didn't check this yet, but since there were some considerable
changes, including locking, you could try with reverting some of these
last 3 patches to net/packet by Denis:

http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.25.git;a=history;f=net/packet/af_packet.c;h=485af5691d64270a02322925a6ccfad9d02b7f78;hb=HEAD

Regards,
Jarek P.

