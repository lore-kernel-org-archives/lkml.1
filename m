Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbZKVTvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbZKVTvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 14:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbZKVTvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 14:51:00 -0500
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:58972 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbZKVTu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 14:50:59 -0500
Message-ID: <4B099624.4010106@vanwingerde.net>
Date: Sun, 22 Nov 2009 20:51:00 +0100
From: Gertjan van Wingerde <gertjan@vanwingerde.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090926 Lightning/1.0pre Shredder/3.0b4
MIME-Version: 1.0
To: David Ellingsworth <david@identd.dyndns.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
       rt2x00 Users List <users@host1.serialmonkey.com>,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>
Subject: Re: [rt2x00-users] ieee80211_tx_status: headroom too small
References: <30353c3d0911201730n4682ff7dy8225d475599eb9bb@mail.gmail.com>	 <4B0806EC.3050201@gmail.com>	 <30353c3d0911212309i20c9b9d3y821b508d8f1c81a4@mail.gmail.com>	 <4B0932C8.90208@gmail.com> <30353c3d0911220959l68cde41cpfd8c02c290497c30@mail.gmail.com> <4B09878D.8060708@gmail.com>
In-Reply-To: <4B09878D.8060708@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020203040306000001000107"
X-OriginalArrivalTime: 22 Nov 2009 19:51:00.0466 (UTC) FILETIME=[1DA9C520:01CA6BAD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020203040306000001000107
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/22/09 19:48, Gertjan van Wingerde wrote:
> On 11/22/09 18:59, David Ellingsworth wrote:
>> On Sun, Nov 22, 2009 at 7:47 AM, Gertjan van Wingerde
>> <gwingerde@gmail.com> wrote:
>>> On 11/22/09 08:09, David Ellingsworth wrote:
>>>> On Sat, Nov 21, 2009 at 10:27 AM, Gertjan van Wingerde
>>>> <gwingerde@gmail.com> wrote:
>>>>> On 11/21/09 02:30, David Ellingsworth wrote:
>>>>>> Wasn't sure where to send this, but with the latest 2.6.32-rc8-wl
>>>>>> kernel built from the wireless-testing repository I'm getting a number
>>>>>> of "ieee80211_tx_status: headroom too small" errors in my syslog. I'm
>>>>>> using the rt61pci driver in conjunction with hostap as a wpa2 secured
>>>>>> access point. The relevant information about my card from lspci is:
>>>>>>
>>>>>> 01:08.0 0280: 1814:0301
>>>>>>         Subsystem: 1458:e934
>>>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
>>>>>> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
>>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Latency: 64, Cache Line Size: 128 bytes
>>>>>>         Interrupt: pin A routed to IRQ 18
>>>>>>         Region 0: Memory at fe6f0000 (32-bit, non-prefetchable) [size=32K]
>>>>>>         Capabilities: [40] Power Management version 2
>>>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>>>>>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>>>>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>>>>>         Kernel driver in use: rt61pci
>>>>>>
>>>>>> If you need any other information, I'll be happy to provide it.
>>>>>>
>>>>>
>>>>> Hi David,
>>>>>
>>>>> This seems to be caused by the rt2x00 driver not properly declaring its alignment
>>>>> maneuvring space properly, and thus it doesn't leave enough headroom left for
>>>>> copying to the monitor interface.
>>>>>
>>>>> Can you check whether the attached patch fixes the issue for you?
>>>>> Note: patch looks a bit bigger than it actually is due to indenting cleanups.
>>>>>
>>>>
>>>> Gertjan,
>>>>
>>>> I haven't really been able to test this. The kernel version I was
>>>> using at the time was 2.6.32-rc7-wl and not 2.6.32-rc8-wl. I'm rather
>>>> certain the patch will resolve the issue, but I've been unable to get
>>>> my wireless card to function properly with the latest 2.6.32-rc8-wl
>>>> master branch. I'm not entirely sure what changed since two days ago,
>>>> but I know the following:
>>>>
>>>> 1. 2.6.32-rc8 from Linus' master branch works fine but still exhibits
>>>> this issue. However, this patch will not apply on top of 2.6.32-rc8.
>>>>
>>>> 2. 2.6.32-rc7-wl(11/19/2009) worked fine with the exception of the
>>>> above mentioned error. Unable to test patch since I pulled all the
>>>> recent modifications down.
>>>> 3. 2.6.32-rc8-wl does not work at all for me, but patch does apply.
>>>>
>>>> I'm not entirely sure what the differences are between Linus' master
>>>> branch of 2.6.32-rc8 and the current 2.6.32-rc8-wl tree are or what
>>>> changes have been made on the wireless-testing master branch in the
>>>> last couple of days that are preventing me from fully testing this
>>>> patch.
>>>>
>>>> With the current wireless-testing master branch, 2.6.32-rc8-wl, with
>>>> and without the patch I can associate and authenticate with my AP but
>>>> am unable to do anything else. Any attempt to establish a wireless
>>>> connection thus dies while trying to obtain an ip address via DHCP.
>>>> Sadly, no errors are logged indicating what the cause of this problem
>>>> might be. Given that I've only seen these errors after establishing a
>>>> wireless connection, it's a little difficult for me to test without
>>>> being able to transmit any data.
>>>>
>>>> I don't know if it's worth the effort or not, but if this patch were
>>>> re-based against Linus' master branch I might be able to test it since
>>>> my AP at least works with 2.6.32-rc8.
>>>
>>> David,
>>>
>>> OK. Find attached the patch ported to Linus' tree. It should apply to
>>> any version of Linus' tree after 2.6.32-rc8.
>>> I think it is good to get real confirmation that the patch behaves
>>> as expected.
>>>
>>> ---
>>> Gertjan.
>>>
>>
>> Gertjan,
>>
>> The patch applies but doesn't quite fix the issue with the rt61pci
>> driver. With the patch applied, I still occasionally receive the error
>> message. I added a printk after the error to see how much was missing.
>> It indicates that skb_headroom is 12 and sizeof(*rthdr) is 13 when it
>> fails.
>>
> 
> David,
> 
> That is unexpected. This more starts to look like a problem that is
> outside of rt2x00.
> 
> Would you be able to see what the available skb_headroom is when the TX
> frame enters the rt61pci driver, i.e. when the rt2x00mac_tx function is
> entered?
> 

(cc-ing Johannes, as this seems to be pointing towards mac80211 as well)

David,

I think I got figured out why the patch I sent didn't work. It seems mac80211
doesn't reserve headroom for both the driver requested space and the special
monitor interface header at the same time, but just for the maximum of the two.
This seems to be because it assumes that they are not needed at the same time.
However, this is not true for rt2x00, as it uses the headroom to align the frame
and never reclaims the used headroom (as the whole frame was moved forward in the
skb).

The easy fix here is to let mac80211 reserve headroom for both numbers, instead of
just the maximum.

Find the patch to achieve that attached.

I think that with both the rt2x00 patch and this patch applied the problem should
be gone.

---
Gertjan.

--------------020203040306000001000107
Content-Type: text/plain;
 name="mac80211_headroom_fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mac80211_headroom_fix.diff"

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 797f539..cba33ce 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -842,10 +842,11 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	/*
 	 * The hardware needs headroom for sending the frame,
 	 * and we need some headroom for passing the frame to monitor
-	 * interfaces, but never both at the same time.
+	 * interfaces. This may not be both at the same time, but
+	 * account for both to be safe.
 	 */
-	local->tx_headroom = max_t(unsigned int , local->hw.extra_tx_headroom,
-				   sizeof(struct ieee80211_tx_status_rtap_hdr));
+	local->tx_headroom = local->hw.extra_tx_headroom +
+				   sizeof(struct ieee80211_tx_status_rtap_hdr);
 
 	debugfs_hw_add(local);
 

--------------020203040306000001000107--
