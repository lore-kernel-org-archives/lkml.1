Return-Path: <linux-kernel-owner+w=401wt.eu-S1761451AbXKBWdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761451AbXKBWdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 18:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbXKBWdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 18:33:38 -0400
Received: from palrel10.hp.com ([156.153.255.245]:53313 "EHLO palrel10.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbXKBWdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 18:33:37 -0400
Message-ID: <472BA5BC.6000901@hp.com>
Date: Fri, 02 Nov 2007 15:33:32 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Felix von Leitner <felix-linuxkernel@fefe.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Netdev <netdev@vger.kernel.org>
Subject: Re: bizarre network timing problem
References: <20071017205127.GA21334@codeblau.de> <47167BDE.4000103@redhat.com>	<20071017220019.GA22765@codeblau.de> <471689BF.2040909@hp.com>	<20071018094230.GA2978@codeblau.de> <4717964A.8080100@hp.com> <20071102221146.GA4354@codeblau.de>
In-Reply-To: <20071102221146.GA4354@codeblau.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Felix von Leitner wrote:
> Thus spake Rick Jones (rick.jones2@hp.com):
> 
>>>How could I test this theory?
>>
>>Can you take another trace that isn't so "cooked?"  One that just sticks 
>>with TCP-level and below stuff?
> 
> 
> Sorry for taking so long.  Here is a tcpdump.  The side on port 445 is
> the SMB server using TCP_CORK.
> 
> 23:03:20.283772 IP 127.0.0.1.33230 > 127.0.0.1.445: S 1503927325:1503927325(0) win 32792 <mss 16396,sackOK,timestamp 9451736 0,nop,wscale 7>
> 23:03:20.283774 IP 127.0.0.1.445 > 127.0.0.1.33230: S 1513925692:1513925692(0) ack 1503927326 win 32768 <mss 16396,sackOK,timestamp 9451737 9451736,nop,wscale 7>
 >
> 23:03:20.283797 IP 127.0.0.1.33230 > 127.0.0.1.445: . ack 1 win 257 <nop,nop,timestamp 9451737 9451737>
> 23:03:20.295851 IP 127.0.0.1.33230 > 127.0.0.1.445: P 1:195(194) ack 1 win 257 <nop,nop,timestamp 9451740 9451737>
> 23:03:20.295881 IP 127.0.0.1.445 > 127.0.0.1.33230: . ack 195 win 265 <nop,nop,timestamp 9451740 9451740>
> 23:03:20.295959 IP 127.0.0.1.445 > 127.0.0.1.33230: P 1:87(86) ack 195 win 265 <nop,nop,timestamp 9451740 9451740>
> 23:03:20.295998 IP 127.0.0.1.33230 > 127.0.0.1.445: . ack 87 win 256 <nop,nop,timestamp 9451740 9451740>
> 23:03:20.296063 IP 127.0.0.1.33230 > 127.0.0.1.445: P 195:287(92) ack 87 win 256 <nop,nop,timestamp 9451740 9451740>
> 23:03:20.296096 IP 127.0.0.1.445 > 127.0.0.1.33230: P 87:181(94) ack 287 win 265 <nop,nop,timestamp 9451740 9451740>
> 23:03:20.296135 IP 127.0.0.1.33230 > 127.0.0.1.445: P 287:373(86) ack 181 win 255 <nop,nop,timestamp 9451740 9451740>
> 23:03:20.296163 IP 127.0.0.1.445 > 127.0.0.1.33230: P 181:239(58) ack 373 win 265 <nop,nop,timestamp 9451740 9451740>
> 23:03:20.296201 IP 127.0.0.1.33230 > 127.0.0.1.445: P 373:459(86) ack 239 win 255 <nop,nop,timestamp 9451740 9451740>
> 23:03:20.296245 IP 127.0.0.1.445 > 127.0.0.1.33230: P 239:309(70) ack 459 win 265 <nop,nop,timestamp 9451740 9451740>
> 23:03:20.296286 IP 127.0.0.1.33230 > 127.0.0.1.445: P 459:535(76) ack 309 win 254 <nop,nop,timestamp 9451740 9451740>
> 23:03:20.296314 IP 127.0.0.1.445 > 127.0.0.1.33230: P 309:461(152) ack 535 win 265 <nop,nop,timestamp 9451740 9451740>
> 23:03:20.296361 IP 127.0.0.1.33230 > 127.0.0.1.445: P 535:594(59) ack 461 win 253 <nop,nop,timestamp 9451740 9451740>
> 23:03:20.296400 IP 127.0.0.1.445 > 127.0.0.1.33230: . 461:16845(16384) ack 594 win 265 <nop,nop,timestamp 9451740 9451740>
> 23:03:20.335748 IP 127.0.0.1.33230 > 127.0.0.1.445: . ack 16845 win 125 <nop,nop,timestamp 9451750 9451740>
> 
> [note the .2 sec pause]

I wonder if the ack 16384 win 125 not updating the window is part of it?  With a 
  window scale of 7, the advertised window of 125 is only 16000 bytes, and it 
looks based on what follows that TCP has another 16384 to send, so my guess is 
that TCP was waiting to have enough window, the persist timer expired and TCP 
then had to say "oh well, send what I can"  Probably a coupling with this being 
less than the MSS (16396) involved too.

> 23:03:20.547763 IP 127.0.0.1.445 > 127.0.0.1.33230: P 16845:32845(16000) ack 594 win 265 <nop,nop,timestamp 9451803 9451750>
> 23:03:20.547797 IP 127.0.0.1.33230 > 127.0.0.1.445: . ack 32845 win 0 <nop,nop,timestamp 9451803 9451803>

Notice that an ACK comes-back with a zero window in it - that means that by this 
point the receiver still hasn't consumed the 16384+16000 bytes sent to id.

> 23:03:20.547855 IP 127.0.0.1.33230 > 127.0.0.1.445: . ack 32845 win 96 <nop,nop,timestamp 9451803 9451803>

Now the receiver has pulled some data, on the order of 96*128 bytes so TCP can 
now go ahead and send the remaining 384 bytes.

> 23:03:20.547863 IP 127.0.0.1.445 > 127.0.0.1.33230: P 32845:33229(384) ack 594 win 265 <nop,nop,timestamp 9451803 9451803>
> 23:03:20.547890 IP 127.0.0.1.33230 > 127.0.0.1.445: . ack 33229 win 96 <nop,nop,timestamp 9451803 9451803>
> 
> [note the .2 sec pause]

I'll bet that 96 * 128 is 12288 and we have another persist timer expiring.

I also wonder if the behaviour might be different if you were using send() 
rather than sendfile() - just random musings...

> 23:03:20.755775 IP 127.0.0.1.445 > 127.0.0.1.33230: P 33229:45517(12288) ack 594 win 265 <nop,nop,timestamp 9451855 9451803>
> 23:03:20.755855 IP 127.0.0.1.33230 > 127.0.0.1.445: . ack 45517 win 96 <nop,nop,timestamp 9451855 9451855>
> 23:03:20.755868 IP 127.0.0.1.445 > 127.0.0.1.33230: P 45517:49613(4096) ack 594 win 265 <nop,nop,timestamp 9451855 9451855>
> 23:03:20.755898 IP 127.0.0.1.33230 > 127.0.0.1.445: . ack 49613 win 96 <nop,nop,timestamp 9451855 9451855>
> 
> [another one]
> 
> 23:03:20.963789 IP 127.0.0.1.445 > 127.0.0.1.33230: P 49613:61901(12288) ack 594 win 265 <nop,nop,timestamp 9451907 9451855>
> 23:03:20.963871 IP 127.0.0.1.33230 > 127.0.0.1.445: . ack 61901 win 96 <nop,nop,timestamp 9451907 9451907>
> 23:03:20.963885 IP 127.0.0.1.445 > 127.0.0.1.33230: P 61901:64525(2624) ack 594 win 265 <nop,nop,timestamp 9451907 9451907>
> 23:03:20.963909 IP 127.0.0.1.33230 > 127.0.0.1.445: . ack 64525 win 96 <nop,nop,timestamp 9451907 9451907>
> 23:03:20.964101 IP 127.0.0.1.33230 > 127.0.0.1.445: P 594:653(59) ack 64525 win 96 <nop,nop,timestamp 9451907 9451907>
> 23:03:21.003790 IP 127.0.0.1.445 > 127.0.0.1.33230: . ack 653 win 265 <nop,nop,timestamp 9451917 9451907>
> 23:03:21.171811 IP 127.0.0.1.445 > 127.0.0.1.33230: P 64525:76813(12288) ack 653 win 265 <nop,nop,timestamp 9451959 9451907>
> 
> You get the idea.
> 
> Anyway, now THIS is the interesting case, because we have two packets in
> the answer, and you see the first half of the answer leaving immediately
> (when I wanted the whole answer to be sent) but the second only leaving
> after the .2 sec delay.

And it wasn't waiting for an ACK/window-update.  You could try:

ifconfig lo mtu 1500

and see what happens then.

>>If SMB is a one-request-at-a-time protocol (I can never remember),
> It is.

Joy.

>> you could simulate it with a netperf TCP_RR test by passing suitable values
>> to the test-specific -r option:
> 
>>netperf -H <remote> -t TCP_RR -- -r <req>,<rsp>
> 
>>If that shows similar behaviour then you can ass-u-me it isn't your 
>>application.
> 
> 
> Oh I'm pretty sure it's not my application, because my application performs
> well over ethernet, which is after all its purpose.  Also I see the
> write, the TCP uncork, then a pause, and then the packet leaving.

Well, a wise old engineer tried to teach me that the proper spelling is ass-u-me 
:) so just for grins, you might try the TCP_RR test anyway :)  And even if your 
application is correct (although I wonder why the receiver isn't sucking 
data-out very quickly...) if you can reproduce the problem with netperf it will 
be easier for others to do so.

rick jones
