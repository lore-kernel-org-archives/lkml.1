Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYKPBMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYKPBMA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 20:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYKPBLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 20:11:51 -0500
Received: from ns01.unsolicited.net ([69.10.132.115]:47579 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbYKPBLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 20:11:50 -0500
Message-ID: <491F7312.5000209@unsolicited.net>
Date: Sun, 16 Nov 2008 01:10:42 +0000
From: David <david@unsolicited.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: Regression: USB/DVB 2.6.26.8 --> 2.6.27.6
References: <491DDD98.7090306@unsolicited.net> <20081114215607.dc10a235.akpm@linux-foundation.org>
In-Reply-To: <20081114215607.dc10a235.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (cc video4linux-list@redhat.com)
>
> On Fri, 14 Nov 2008 20:20:40 +0000 David <david@unsolicited.net> wrote:
>
>   
>> I've just tried to upgrade my media server to the latest stable kernel
>> and have found problems with my USB DVB  devices. With the new kernel
>> I'm seeing
>>
>> DVB: registering new adapter (Technotrend TT-connect S-2400)
>> DVB: registering frontend 3 (Philips TDA10086 DVB-S)...
>> dvb-usb: recv bulk message failed: -110
>> ttusb2: there might have been an error during control message transfer.
>> (rlen = 0, was 0)
>> dvb-usb: Technotrend TT-connect S-2400 successfully initialized and
>> connected.
>>
>>     
As another data point, I've just reproduced this on an x86-64 machine
with just a single S-2400 using 2.6.28-rc5. The reply message seems to
timeout.

[   99.425530] usb 1-8: new high speed USB device using ehci_hcd and
address 5
[   99.556976] usb 1-8: configuration #1 chosen from 1 choice
[   99.764105] dvb-usb: found a 'Technotrend TT-connect S-2400' in cold
state, will try to load a firmware
[   99.764112] usb 1-8: firmware: requesting dvb-usb-tt-s2400-01.fw
[   99.810325] dvb-usb: downloading firmware from file
'dvb-usb-tt-s2400-01.fw'
[   99.872835] usbcore: registered new interface driver dvb_usb_ttusb2
[   99.880036] usb 1-8: USB disconnect, address 5
[   99.884293] dvb-usb: generic DVB-USB module successfully
deinitialized and disconnected.
[  101.637183] usb 1-8: new high speed USB device using ehci_hcd and
address 6
[  101.770402] usb 1-8: configuration #1 chosen from 1 choice
[  101.770870] dvb-usb: found a 'Technotrend TT-connect S-2400' in warm
state.
[  101.771390] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[  101.771522] DVB: registering new adapter (Technotrend TT-connect S-2400)
[  101.784993] DVB: registering adapter 0 frontend 0 (Philips TDA10086
DVB-S)...
[  103.788068] dvb-usb: recv bulk message failed: -110
[  103.788074] ttusb2: there might have been an error during control
message transfer. (rlen = 0, was 0)
[  103.788312] dvb-usb: Technotrend TT-connect S-2400 successfully
initialized and connected.


Cheers
David
