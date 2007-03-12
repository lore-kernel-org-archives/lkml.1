Return-Path: <linux-kernel-owner+w=401wt.eu-S932837AbXCLWcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837AbXCLWcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 18:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932953AbXCLWcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 18:32:07 -0400
Received: from phpmyadmin.profiwh.com ([85.93.165.67]:56020 "EHLO
	cacti.profiwh.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932837AbXCLWcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 18:32:06 -0400
Message-ID: <45F5D4E7.7040209@gmail.com>
Date: Mon, 12 Mar 2007 23:32:07 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
References: <Pine.LNX.4.44L0.0703121100460.2489-100000@iolanthe.rowland.org> <45F57F94.6010502@gmail.com> <Pine.LNX.4.64.0703122157550.14144@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0703122157550.14144@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina napsal(a):
> (trimmed CC list a bit)
> 
> On Mon, 12 Mar 2007, Jiri Slaby wrote:
> 
>>>>      UHCI: Eliminate asynchronous skeleton Queue Headers
>>> Post it along with the usbmon log, and I'll try to figure out what happened.
>> Here it comes:
>> USBMON:
>> f7525b40 1832950485 C Ii:004:01 0 8 = 00005300 00000000
>> f7525b40 1832950517 S Ii:004:01 -115 8 <
>> f7525140 1832950540 S Co:004:00 s 21 09 0200 0000 0001 1 = 01
>> f7525140 1832952485 C Co:004:00 0 1 >
>> Corresponds to numlock; 7; numlock; 7.

Alan, sorry for the previous bad post, I mismatched 2 files. This is 
hopefully correct.

> thanks. Could you also please redo the test with the offending uhci patch 
> reverted and send the output of a working situation?

- BAD kernel:

USBMON output:
d28dba40 1882513063 C Ii:008:01 0 8 = 00005300 00000000
d28dba40 1882513090 S Ii:008:01 -115 8 <
f7b31340 1882515363 S Co:008:00 s 21 09 0200 0000 0001 1 = 00
f7b31340 1882517065 C Co:008:00 0 1 >




UHCI snapshot before hang:
Root-hub state: running   FSBR: 0
HC status
   usbcmd    =     00c1   Maxp64 CF RS
   usbstat   =     0000
   usbint    =     000f
   usbfrnum  =   (1)764
   flbaseadd = 0303d764
   sof       =       40
   stat1     =     01a5   LowSpeed Enabled Connected
   stat2     =     0095   Enabled Connected
Most recent frame: 75a2 (418)   Last ISO frame: 75a2 (418)
Periodic load table
         12      0       0       0       127     0       0       0
         0       0       0       0       127     0       0       0
         0       0       0       0       127     0       0       0
         0       0       0       0       127     0       0       0
Total: 520, #INT: 4, #ISO: 0
Frame List
Skeleton QHs
- skel_unlink_qh
     [c3c41000] Skel QH link (00000001) element (00000001)
       queue is empty
- skel_iso_qh
     [c3c41060] Skel QH link (00000001) element (00000001)
       queue is empty
- skel_int128_qh
     [c3c410c0] Skel QH link (03c41542) element (00000001)
       queue is empty
     [c3c41540] INT QH link (03c41362) element (02c4a0f0)
         period 128 phase 0 load 12 us
urb_priv [f7b2da4c] urb [f7b314c0] qh [c3c41540] Dev=7 EP=1(IN) INT Actlen=0
         1: [c2c4a0f0] link (02c4a0c0) e3 IOC Active NAK Length=7ff MaxLen=0 
DT1 EndPt=1 Dev=7, PID=69(IN) (buf=36a4a040)
       Dummy TD
[c2c4a0c0] link (02c4a120) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=0, 
PID=e1(OUT) (buf=00000000)
- skel_int64_qh
     [c3c41120] Skel QH link (03c41362) element (00000001)
       queue is empty
- skel_int32_qh
     [c3c41180] Skel QH link (03c41362) element (00000001)
       queue is empty
- skel_int16_qh
     [c3c411e0] Skel QH link (03c41362) element (00000001)
       queue is empty
- skel_int8_qh
     [c3c41240] Skel QH link (03c41482) element (00000001)
       queue is empty
     [c3c41480] INT QH link (03c41602) element (02c4a030)
         period 8 phase 4 load 93 us
urb_priv [f7b2d3bc] urb [d28dbc40] qh [c3c41480] Dev=2 EP=1(IN) INT Actlen=0
         1: [c2c4a030] link (02c4a060) e3 LS IOC Active NAK Length=7ff 
MaxLen=3 DT0 EndPt=1 Dev=2, PID=69(IN) (buf=037c5000)
       Dummy TD
[c2c4a060] link (02c4a0f0) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=0, 
PID=e1(OUT) (buf=00000000)
     [c3c41600] INT QH link (03c41662) element (02c4a150)
         period 8 phase 4 load 17 us
urb_priv [f7b2da30] urb [d28dba40] qh [c3c41600] Dev=8 EP=1(IN) INT Actlen=0
         1: [c2c4a150] link (02c4a120) e3 IOC Active NAK Length=7ff MaxLen=7 
DT1 EndPt=1 Dev=8, PID=69(IN) (buf=037c5180)
       Dummy TD
[c2c4a120] link (02c4a180) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=0, 
PID=e1(OUT) (buf=00000000)
     [c3c41660] INT QH link (03c41362) element (02c4a1b0)
         period 8 phase 4 load 17 us
urb_priv [f7b2d9f8] urb [d1622840] qh [c3c41660] Dev=8 EP=2(IN) INT Actlen=0
         1: [c2c4a1b0] link (02c4a1e0) e3 IOC Active NAK Length=7ff MaxLen=4 
DT0 EndPt=2 Dev=8, PID=69(IN) (buf=037c5300)
       Dummy TD
[c2c4a1e0] link (02c4a210) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=0, 
PID=e1(OUT) (buf=00000000)
- skel_int4_qh
     [c3c412a0] Skel QH link (03c41362) element (00000001)
       queue is empty
- skel_int2_qh
     [c3c41300] Skel QH link (03c41362) element (00000001)
       queue is empty
- skel_async_qh
     [c3c41360] Skel QH link (00000001) element (02c4a000)
       queue is empty
- skel_term_qh
     [c3c413c0] Skel QH link (00000001) element (02c4a000)
       queue is empty




UHCI snapshot after hang:
Root-hub state: running   FSBR: 0
HC status
   usbcmd    =     00c1   Maxp64 CF RS
   usbstat   =     0000
   usbint    =     000f
   usbfrnum  =   (1)c2c
   flbaseadd = 0303dc2c
   sof       =       40
   stat1     =     01a5   LowSpeed Enabled Connected
   stat2     =     0095   Enabled Connected
Most recent frame: 9efc (764)   Last ISO frame: 9efc (764)
Periodic load table
         12      0       0       0       127     0       0       0
         0       0       0       0       127     0       0       0
         0       0       0       0       127     0       0       0
         0       0       0       0       127     0       0       0
Total: 520, #INT: 4, #ISO: 0
Frame List
Skeleton QHs
- skel_unlink_qh
     [c3c41000] Skel QH link (00000001) element (00000001)
       queue is empty
- skel_iso_qh
     [c3c41060] Skel QH link (00000001) element (00000001)
       queue is empty
- skel_int128_qh
     [c3c410c0] Skel QH link (03c41542) element (00000001)
       queue is empty
     [c3c41540] INT QH link (03c41362) element (02c4a0f0)
         period 128 phase 0 load 12 us
urb_priv [f7b2da4c] urb [f7b314c0] qh [c3c41540] Dev=7 EP=1(IN) INT Actlen=0
         1: [c2c4a0f0] link (02c4a0c0) e3 IOC Active NAK Length=7ff MaxLen=0 
DT1 EndPt=1 Dev=7, PID=69(IN) (buf=36a4a040)
       Dummy TD
[c2c4a0c0] link (02c4a120) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=0, 
PID=e1(OUT) (buf=00000000)
- skel_int64_qh
     [c3c41120] Skel QH link (03c41362) element (00000001)
       queue is empty
- skel_int32_qh
     [c3c41180] Skel QH link (03c41362) element (00000001)
       queue is empty
- skel_int16_qh
     [c3c411e0] Skel QH link (03c41362) element (00000001)
       queue is empty
- skel_int8_qh
     [c3c41240] Skel QH link (03c41482) element (00000001)
       queue is empty
     [c3c41480] INT QH link (03c41602) element (02c4a030)
         period 8 phase 4 load 93 us
urb_priv [f7b2d3bc] urb [d28dbc40] qh [c3c41480] Dev=2 EP=1(IN) INT Actlen=0
         1: [c2c4a030] link (02c4a060) e3 LS IOC Active NAK Length=7ff 
MaxLen=3 DT0 EndPt=1 Dev=2, PID=69(IN) (buf=037c5000)
       Dummy TD
[c2c4a060] link (02c4a0f0) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=0, 
PID=e1(OUT) (buf=00000000)
     [c3c41600] INT QH link (03c41662) element (02c4a120)
         period 8 phase 4 load 17 us
urb_priv [f7b2da30] urb [d28dba40] qh [c3c41600] Dev=8 EP=1(IN) INT Actlen=0
         1: [c2c4a120] link (02c4a180) e3 IOC Active NAK Length=7ff MaxLen=7 
DT0 EndPt=1 Dev=8, PID=69(IN) (buf=037c5180)
       Dummy TD
[c2c4a180] link (02c4a150) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=0, 
PID=e1(OUT) (buf=00000000)
     [c3c41660] INT QH link (03c41362) element (02c4a1b0)
         period 8 phase 4 load 17 us
urb_priv [f7b2d9f8] urb [d1622840] qh [c3c41660] Dev=8 EP=2(IN) INT Actlen=0
         1: [c2c4a1b0] link (02c4a1e0) e3 IOC Active NAK Length=7ff MaxLen=4 
DT0 EndPt=2 Dev=8, PID=69(IN) (buf=037c5300)
       Dummy TD
[c2c4a1e0] link (02c4a210) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=0, 
PID=e1(OUT) (buf=00000000)
- skel_int4_qh
     [c3c412a0] Skel QH link (03c41362) element (00000001)
       queue is empty
- skel_int2_qh
     [c3c41300] Skel QH link (03c41362) element (00000001)
       queue is empty
- skel_async_qh
     [c3c41360] Skel QH link (00000001) element (02c4a000)
       queue is empty
- skel_term_qh
     [c3c413c0] Skel QH link (00000001) element (02c4a000)
       queue is empty




*******************************************************************
- GOOD kernel (reverted):

USBMON output:
f7b31ec0 2545055172 C Ii:004:01 0 8 = 00005300 00000000
f7b31ec0 2545055198 S Ii:004:01 -115 8 <
f588aec0 2545055215 S Co:004:00 s 21 09 0200 0000 0001 1 = 01
f588aec0 2545057168 C Co:004:00 0 1 >
f7b31ec0 2545135153 C Ii:004:01 0 8 = 00000000 00000000
f7b31ec0 2545135166 S Ii:004:01 -115 8 <



UHCI snapshot:
Root-hub state: running   FSBR: 0
HC status
   usbcmd    =     00c1   Maxp64 CF RS
   usbstat   =     0000
   usbint    =     000f
   usbfrnum  =   (0)988
   flbaseadd = 2fce2988
   sof       =       40
   stat1     =     01a5   LowSpeed Enabled Connected
   stat2     =     0095   Enabled Connected
Most recent frame: 10a4d (589)   Last ISO frame: 10a4d (589)
Periodic load table
         12      0       0       0       34      0       0       0
         0       0       0       0       34      0       0       0
         0       0       0       0       34      0       0       0
         0       0       0       0       34      0       0       0
Total: 148, #INT: 3, #ISO: 0
Frame List
Skeleton QHs
- skel_unlink_qh
     [e2d00000] Skel QH link (00000001) element (00000001)
       queue is empty
- skel_iso_qh
     [e2d00060] Skel QH link (00000001) element (00000001)
       queue is empty
- skel_int128_qh
     [e2d000c0] Skel QH link (22d00602) element (00000001)
       queue is empty
     [e2d00600] INT QH link (22d00362) element (31db7030)
         period 128 phase 0 load 12 us
urb_priv [e2cc63bc] urb [f7427bc0] qh [e2d00600] Dev=3 EP=1(IN) INT Actlen=0
         1: [f1db7030] link (31db7090) e3 IOC Active NAK Length=7ff MaxLen=0 
DT0 EndPt=1 Dev=3, PID=69(IN) (buf=32f3f040)
       Dummy TD
[f1db7090] link (31db70c0) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=0, 
PID=e1(OUT) (buf=00000000)
- skel_int64_qh
     [e2d00120] Skel QH link (22d00362) element (00000001)
       queue is empty
- skel_int32_qh
     [e2d00180] Skel QH link (22d00362) element (00000001)
       queue is empty
- skel_int16_qh
     [e2d001e0] Skel QH link (22d00362) element (00000001)
       queue is empty
- skel_int8_qh
     [e2d00240] Skel QH link (22d006c2) element (00000001)
       queue is empty
     [e2d006c0] INT QH link (22d00722) element (31db7060)
         period 8 phase 4 load 17 us
urb_priv [e2cc63a0] urb [f7b31ec0] qh [e2d006c0] Dev=4 EP=1(IN) INT Actlen=0
         1: [f1db7060] link (31db70f0) e3 IOC Active NAK Length=7ff MaxLen=7 
DT0 EndPt=1 Dev=4, PID=69(IN) (buf=2fce3180)
       Dummy TD
[f1db70f0] link (31db7180) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=0, 
PID=e1(OUT) (buf=00000000)
     [e2d00720] INT QH link (22d00362) element (31db7120)
         period 8 phase 4 load 17 us
urb_priv [e2cc6384] urb [f72a52c0] qh [e2d00720] Dev=4 EP=2(IN) INT Actlen=0
         1: [f1db7120] link (31db7150) e3 IOC Active NAK Length=7ff MaxLen=4 
DT0 EndPt=2 Dev=4, PID=69(IN) (buf=2fce3300)
       Dummy TD
[f1db7150] link (31db7180) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=0, 
PID=e1(OUT) (buf=00000000)
- skel_int4_qh
     [e2d002a0] Skel QH link (22d00362) element (00000001)
       queue is empty
- skel_int2_qh
     [e2d00300] Skel QH link (22d00362) element (00000001)
       queue is empty
- skel_int1_qh
     [e2d00360] Skel QH link (22d003c2) element (00000001)
       queue is empty
- skel_ls_control_qh
     [e2d003c0] Skel QH link (22d00422) element (00000001)
       queue is empty
- skel_fs_control_qh
     [e2d00420] Skel QH link (22d00482) element (00000001)
       queue is empty
- skel_bulk_qh
     [e2d00480] Skel QH link (22d004e2) element (00000001)
       queue is empty
- skel_term_qh
     [e2d004e0] Skel QH link (00000001) element (31db7000)
       queue is empty




regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
