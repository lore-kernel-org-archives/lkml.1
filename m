Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbZBVMBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbZBVMBh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 07:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZBVMB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 07:01:27 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:54621 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZBVMB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 07:01:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fNUMIUxYdR55eiLK1AUyEUNJkJXYimgsXR6ESBZIoLSYdDG7HuWCzSChegkLeacb1c
         KIyRXay1TaILDVb/bbs/DoThs0pJaGGyijG2qFxgt1eorgVO4S6o1bZJKstkGp2E6ufI
         viDkWLjJUV7J9E3Jw+fT2HOwxQHFXxKaEyeFk=
Message-ID: <49A13E91.1090601@gmail.com>
Date: Sun, 22 Feb 2009 13:01:21 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090218 SUSE/3.0b2-1.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>, Bob Copeland <me@bob>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
References: <20090222111807.GB5538@silver.sucs.org>
In-Reply-To: <20090222111807.GB5538@silver.sucs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.2.2009 12:18, Sitsofe Wheeler wrote:
> While testing a linux-tip from yesterday, a
> BUG kmalloc-4096: Poison overwritten
> warning appeared inside dmesg. I'm not aware of what I was doing other
> that browsing a few web pages and using ssh in the lead up to it. Output
> is attached below:
>
> [ 3666.410818] ath5k phy0: unsupported jumbo
> [ 4432.305651] ath5k phy0: unsupported jumbo
> [ 4466.022644] totem[4664]: segfault at 5bf7b980 ip b5b39cbb sp b0d5f130 error 6 in libpulse.so.0.4.1[b5afb000+4d000]
> [ 4617.353923] totem[5189]: segfault at 4c7a2ee0 ip b59bfdca sp b1c12ec0 error 6 in libpulse.so.0.4.1[b5981000+4d000]
> [ 7412.846146] =============================================================================
> [ 7412.846159] BUG kmalloc-4096: Poison overwritten
> [ 7412.846163] -----------------------------------------------------------------------------
> [ 7412.846166]
> [ 7412.846172] INFO: 0xf6438010-0xf6438053. First byte 0x80 instead of 0x6b
> [ 7412.846188] INFO: Allocated in dev_alloc_skb+0x21/0x40 age=629 cpu=0 pid=0
> [ 7412.846197] INFO: Freed in skb_release_data+0x5e/0x90 age=21 cpu=0 pid=0
> [ 7412.846204] INFO: Slab 0xc17a27e0 objects=7 used=5 fp=0xf6438000 flags=0x400020c3
> [ 7412.846210] INFO: Object 0xf6438000 @offset=0 fp=0xf643a060
> [ 7412.846212]
> [ 7412.846216]   Object 0xf6438000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [ 7412.846245]   Object 0xf6438010:  80 00 00 00 ff ff ff ff ff ff 00 30 ab 1a 32 3f ....ÿÿÿÿÿÿ.0«.2?

Hmm, beacon written after the memory was freed.

> [ 7412.846273]   Object 0xf6438020:  00 30 ab 1a 32 3f e0 24 59 62 25 b5 01 00 00 00 .0«.2?à$Yb%µ....
> [ 7412.846301]   Object 0xf6438030:  64 00 31 00 00 08 57 69 72 65 6c 65 73 73 01 04 d.1...Wireless..
> [ 7412.846329]   Object 0xf6438040:  82 84 8b 96 03 01 06 05 04 01 02 00 00 55 fa af .............Uú¯
> [ 7412.846357]   Object 0xf6438050:  5d 55 fa 5d 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b ]Uú]kkkkkkkkkkkk
> [ 7412.846385]   Object 0xf6438060:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk

...

The unsupported jumbo message might be a clue. When we jump to the next: 
label, the buffer is at the end of the list in software, while in 
hardware it isn't. In theory, we might hit the bug with rx buffers 
exhaustion, because the test (bf_last == bf) doesn't work as expected then.
