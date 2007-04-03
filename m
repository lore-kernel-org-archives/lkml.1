Return-Path: <linux-kernel-owner+w=401wt.eu-S1161044AbXDCSPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161044AbXDCSPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 14:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161049AbXDCSPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 14:15:22 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:34888 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161044AbXDCSPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 14:15:22 -0400
Message-ID: <46129968.9000304@gmail.com>
Date: Tue, 03 Apr 2007 20:14:00 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk> <460EA727.8070306@gmail.com> <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com> <4610481D.8000102@gmail.com> <46104954.50608@gmail.com> <Pine.LNX.4.64.0704020949160.23099@sbz-30.cs.Helsinki.FI> <20070402071018.GE11996@kernel.dk> <Pine.LNX.4.64.0704021152280.27165@sbz-30.cs.Helsinki.FI> <46111ED7.20201@gmail.com> <Pine.LNX.4.64.0704021837480.6518@sbz-30.cs.Helsinki.FI> <46112650.8080208@gmail.com> <Pine.LNX.4.64.0704021906040.7500@sbz-30.cs.Helsinki.FI> <461165FD.2010508@gmail.com> <Pine.LNX.4.64.0704030908420.20080@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0704030956330.20741@sbz-30.cs.Helsinki.FI> <461256C1.4020906@gmail.com> <Pine.LNX.4.64.0704031723580.3355@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0704032030470.8078@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0704032030470.8078@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2007 07:31 PM, Pekka J Enberg wrote:

> Oh, well, here goes. Rene, would you be so kind and spin the wheel once 
> more? =)

Absolutely!

root@5va2:~# dd if=/dev/mcdx0 of=/dev/null

Oops: 0002 [#1]
CPU:    0
EIP:    0060:[<c1047787>]    Not tainted VLI
EFLAGS: 00010082   (2.6.20.4 #11)
EIP is at free_block+0x58/0xcf
eax: 07ff46c6   ebx: c1d5f100   ecx: c1d5f12c   edx: 160010b9
esi: c16414e0   edi: c160c960   ebp: 00000001   esp: c1575ef0
ds: 007b   es: 007b   ss: 0068
Process events/0 (pid: 4, ti=c1575000 task=c1577510 task.ti=c1575000)
Stack: 00000000 00000002 c165fa38 c165fa38 00000002 c165fa00 00000000 
c1047eb6
        00000000 00000000 c16414e0 c160c960 c16414e0 c160c960 c14ab540 
00000292
        c1047f3a 00000000 00000000 00000292 c14ab544 c154ebc0 c101ec7a 
c154ec14
Call Trace:
  [<c1047eb6>] drain_array+0x94/0xc3
  [<c1047f3a>] cache_reap+0x55/0xe9
  [<c101ec7a>] run_workqueue+0x8f/0x14d
  [<c1047ee5>] cache_reap+0x0/0xe9
  [<c101ee5a>] worker_thread+0x122/0x14b
  [<c100e2d8>] default_wake_function+0x0/0xc
  [<c100e2d8>] default_wake_function+0x0/0xc
  [<c101ed38>] worker_thread+0x0/0x14b
  [<c1021800>] kthread+0x72/0x97
  [<c102178e>] kthread+0x0/0x97
  [<c1002b47>] kernel_thread_helper+0x7/0x10
  =======================
Code: 05 03 15 4c ab 4a c1 8b 02 f6 c4 40 74 03 8b 52 0c 8b 02 a8 80 75 
04 0f 0b eb fe 8b 5a 1c 8b 44 24 20 8b 53 04 8b 74 87 18 8b 03 <89> 02 
c7 03 00 01 10 00 89 50 04 c7 43 04 00 02 20 00 8b 44 24
EIP: [<c1047787>] free_block+0x58/0xcf SS:ESP 0068:c1575ef0

That is, the exact same oops the tar test showed which I expect is 
progress -- the dd is now in fact doing something :-)

When I now switched the monitor to 5va2 itself it was happily generating 
more oopses and supposedly "fixing up recursive faults", while advicing 
me to reboot. 2 seconds later it didn't leave me a choice as it dropped 
dead :-)

Just to keep track, I'm now using the patches (minus 03) at:

http://members.home.nl/rene.herman/mcdx/

(for lkml: with 03, the machine locks itself hard each and every time 
without information).

Thanks again :)

Rene.

