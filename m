Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbYJZKi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbYJZKi5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 06:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYJZKis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 06:38:48 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:7467 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbYJZKiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 06:38:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Q2IVD67BidKAMYtb54kDnFqfbG8V1z1t2jjfqeZBZRFTkcmZtrlFoMOisJ2KizkArJ
         mNPvNdCnJsStWYNce8+JKux0ArDsmRTDe4Q2YNrxER2W7lNYZ86Jfw6s4Hy8fnC5YJwq
         937n0xmBDMSP0a3BILi2rAEFR8yE4CDNg5StU=
Message-ID: <490448B0.8050307@gmail.com>
Date: Sun, 26 Oct 2008 11:38:40 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Edward Hsu <edward_hsu@realtek.com.tw>,
       Ivan Vecera <ivecera@redhat.com>
Subject: Re: r8169 MAC addresses broken
References: <490380C8.6070003@simon.arlott.org.uk> <4903947A.3060206@gmail.com> <20081025223443.GA30913@electric-eye.fr.zoreil.com>
In-Reply-To: <20081025223443.GA30913@electric-eye.fr.zoreil.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu napsal(a):
> Jiri Slaby <jirislaby@gmail.com> :
> [...]
>> Ah, I thought I have broken hardware. I have similar problem, my mac is
>> initially all zeroes. When I set it up, it works until suspend. After that I
>> need to unbind the driver, bind it again, and it works then (mac is still the
>> set one).
>>
>> I'm out of the notebook right now, but it is 10ec:8168:
>> 06:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI
>> Express Gigabit Ethernet controller (rev 01)
>> 	Subsystem: ASUSTeK Computer Inc. Unknown device 11f5
>>
>> I used it perfectly far later than 2.6.24 (maybe 2.6.26?), 2.6.27 is yet
>> defunct.
> 
> 2.6.27 proper ? That's bad news.
> 
> Can you send a dmesg for 2.6.27 and 2.6.28-rc1 ?

2.6.28-rc1 doesn't boot, the rest of dmesgs is at:
http://decibel.fi.muni.cz/~xslaby/r8169_mac/

However I may have a hw failure or some bug overwrote my eeprom, I see this
in current mmotm:
r8169 0000:06:00.0: PCI INT A disabled
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
r8169 0000:06:00.0: setting latency timer to 64
r8169: mac_version = 0x0c
r8169 0000:06:00.0: irq 43 for MSI/MSI-X
r8169: MAC address found in EEPROM: 00:00:00:00:00:00
eth0: RTL8168b/8111b at 0xffffc200042b0000, 00:00:00:00:00:00, XID 38000000
IRQ 43
r8169: mac_version = 0x0c

which looks like even in the eeprom are all zeroes now. Also 2.6.25 is
affected by this now and it worked (from_Jul dmesg).
