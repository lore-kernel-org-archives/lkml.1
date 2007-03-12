Return-Path: <linux-kernel-owner+w=401wt.eu-S1030582AbXCLQ15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030582AbXCLQ15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030599AbXCLQ15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:27:57 -0400
Received: from phpmyadmin.profiwh.com ([85.93.165.67]:60259 "EHLO
	cacti.profiwh.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030582AbXCLQ14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:27:56 -0400
Message-ID: <45F57F94.6010502@gmail.com>
Date: Mon, 12 Mar 2007 17:28:04 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jiri Kosina <jikos@jikos.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
References: <Pine.LNX.4.44L0.0703121100460.2489-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0703121100460.2489-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern napsal(a):
> On Mon, 12 Mar 2007, Jiri Slaby wrote:
> 
>> Bisecting figured out the culprit:
>> Commit: 17230acdc71137622ca7dfd789b3944c75d39404
>> Author: Alan Stern <stern@rowland.harvard.edu> Mon, 19 Feb 2007 15:52:45 -0500
>>
>>      UHCI: Eliminate asynchronous skeleton Queue Headers
[...]
> Post it along 
> with the usbmon log, and I'll try to figure out what happened.

Here it comes:
USBMON:
f7525b40 1832950485 C Ii:004:01 0 8 = 00005300 00000000
f7525b40 1832950517 S Ii:004:01 -115 8 <
f7525140 1832950540 S Co:004:00 s 21 09 0200 0000 0001 1 = 01
f7525140 1832952485 C Co:004:00 0 1 >

Corresponds to numlock; 7; numlock; 7.

UHCI snapshot:
Root-hub state: running   FSBR: 0
HC status
   usbcmd    =     00c1   Maxp64 CF RS
   usbstat   =     0000
   usbint    =     000f
   usbfrnum  =   (0)6d4
   flbaseadd = 36a526d4
   sof       =       40
   stat1     =     01a5   LowSpeed Enabled Connected
   stat2     =     0095   Enabled Connected
Most recent frame: 101131 (305)   Last ISO frame: 101131 (305)
Periodic load table
         12      0       0       0       127     0       0       0
         0       0       0       0       127     0       0       0
         0       0       0       0       127     0       0       0
         0       0       0       0       127     0       0       0
Total: 520, #INT: 4, #ISO: 0
Frame List
Skeleton QHs
- skel_unlink_qh
     [f722f000] Skel QH link (00000001) element (00000001)
       queue is empty
- skel_iso_qh
     [f722f060] Skel QH link (00000001) element (00000001)
       queue is empty
- skel_int128_qh
     [f722f0c0] Skel QH link (3722f542) element (00000001)
       queue is empty
     [f722f540] INT QH link (3722f362) element (36848090)
         period 128 phase 0 load 12 us
urb_priv [f767ecd0] urb [f7418b40] qh [f722f540] Dev=7 EP=1(IN) INT Actlen=0
         1: [f6848090] link (36848030) e3 IOC Active NAK Length=7ff MaxLen=0 DT0 
EndPt=1 Dev=7, PID=69(IN) (buf=3722b040)
       Dummy TD
[f6848030] link (368480c0) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=0, PID=e1(OUT) 
(buf=00000000)
- skel_int64_qh
     [f722f120] Skel QH link (3722f362) element (00000001)
       queue is empty
- skel_int32_qh
     [f722f180] Skel QH link (3722f362) element (00000001)
       queue is empty
- skel_int16_qh
     [f722f1e0] Skel QH link (3722f362) element (00000001)
       queue is empty
- skel_int8_qh
     [f722f240] Skel QH link (3722f482) element (00000001)
       queue is empty
     [f722f480] INT QH link (3722f602) element (36848060)
         period 8 phase 4 load 93 us
urb_priv [f767ef70] urb [f74481c0] qh [f722f480] Dev=2 EP=1(IN) INT Actlen=0
         1: [f6848060] link (368481e0) e3 LS IOC Active NAK Length=7ff MaxLen=3 
DT1 EndPt=1 Dev=2, PID=69(IN) (buf=36a71000)
       Dummy TD
[f68481e0] link (36848180) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=0, PID=e1(OUT) 
(buf=00000000)
     [f722f600] INT QH link (3722f662) element (36848120)
         period 8 phase 4 load 17 us
urb_priv [f767ed08] urb [f6566240] qh [f722f600] Dev=8 EP=1(IN) INT Actlen=0
         1: [f6848120] link (368480f0) e3 IOC Active NAK Length=7ff MaxLen=7 DT0 
EndPt=1 Dev=8, PID=69(IN) (buf=36a71180)
       Dummy TD
[f68480f0] link (36848150) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=0, PID=e1(OUT) 
(buf=00000000)
     [f722f660] INT QH link (3722f362) element (368481b0)
         period 8 phase 4 load 17 us
urb_priv [f767e2dc] urb [f7418140] qh [f722f660] Dev=8 EP=2(IN) INT Actlen=0
         1: [f68481b0] link (36848210) e3 IOC Active NAK Length=7ff MaxLen=4 DT0 
EndPt=2 Dev=8, PID=69(IN) (buf=36a71300)
       Dummy TD
[f6848210] link (36848270) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=0, PID=e1(OUT) 
(buf=00000000)
- skel_int4_qh
     [f722f2a0] Skel QH link (3722f362) element (00000001)
       queue is empty
- skel_int2_qh
     [f722f300] Skel QH link (3722f362) element (00000001)
       queue is empty
- skel_async_qh
     [f722f360] Skel QH link (00000001) element (36848000)
       queue is empty
- skel_term_qh
     [f722f3c0] Skel QH link (00000001) element (36848000)
       queue is empty



Side note, it doesn't stop working at all, but there is something like timeout 
or whatever, after a while, the keyboard interacts again.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
