Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbYL1VMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbYL1VMZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 16:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224AbYL1VMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 16:12:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:7644 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220AbYL1VMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 16:12:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vQxAG0T9ZFb14nF9VrJJgU1kmVvY2EfQX4btJRqRCOSqdapfykclyhsJpL6nYJB11Z
         HtgBYaouBKaD+aATq8eUDybMKuuSAh2/eo0JsE9M7B5dL7tlyNkRtnWb05COaII80aIE
         is+zD9zPy+IiwLyleAC+ak3Z4kSCNhAqY9Sbw=
Message-ID: <742b1fb30812281312l1847f07by7c6c40e3bdf9e086@mail.gmail.com>
Date: Sun, 28 Dec 2008 22:12:07 +0100
From: "Patrizio Bassi" <patrizio.bassi@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [BUG] 2.6.28 kseriod oops on resume afte hibernation
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <742b1fb30812281209y16000506idb1e390d5f11be1a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <742b1fb30812251225o38a2e4bak2d9f10ca3c23ada3@mail.gmail.com>
	 <20081225210355.GA7105@x200.localdomain>
	 <742b1fb30812281209y16000506idb1e390d5f11be1a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/28 Patrizio Bassi <patrizio.bassi@gmail.com>:
> 2008/12/25 Alexey Dobriyan <adobriyan@gmail.com>:
>> On Thu, Dec 25, 2008 at 09:25:38PM +0100, Patrizio Bassi wrote:
>>> Call Trace:
>>>  [<c027ac74>] 0xc027ac74
>>>  [<c0124598>] 0xc0124598
>>>  [<c027cd1c>] 0xc027cd1c
>>>  [<c02750a2>] 0xc02750a2
>>>  [<c0275587>] 0xc0275587
>>>  [<c0124598>] 0xc0124598
>>>  [<c0275482>] 0xc0275482
>>>  [<c01242ab>] 0xc01242ab
>>>  [<c0124275>] 0xc0124275
>>>  [<c0103823>] 0xc0103823
>>> Code: 37 c0 31 c0 c7 47 58 1c 87 37 c0 5e 5b 5e 5f 5d c3 55 57 56 53
>>> 83 ec 28 fc b9 06 00 00 00 89 c3 8b 00 8d 7c 24 10 89 04 24 89 c6 <f3>
>>> a5 8b 44 24 14 8b 54 24 18 8b 7c 24 1c 8b 6c 24 10 89 44 24
>>> EIP: [<c027dbdf>]  SS:ESP 0068:d28b3f54
>>> ---[ end trace e760723794b1da56 ]---
>>
>> Always run with CONFIG_KALSYMS=y, so normal backtraces are on
>> and nobody will waste time asking to enable it and enabling it.
>>
>
> Reproduced:
>
> Restarting tasks ... done.
> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<c027ee13>] synaptics_reconnect+0x1a/0x9b
> *pde = 00000000
> Oops: 0000 [#1]
> last sysfs file: /sys/power/state
> Modules linked in: arc4 ecb cryptomgr aead crypto_blkcipher
> crypto_algapi ath5k mac80211 led_class cfg80211
>
> Pid: 207, comm: kseriod Tainted: G       A   (2.6.28 #29) A1B
> EIP: 0060:[<c027ee13>] EFLAGS: 00010282 CPU: 0
> EIP is at synaptics_reconnect+0x1a/0x9b
> EAX: 00000000 EBX: d2a16400 ECX: 00000006 EDX: c027edf9
> ESI: 00000000 EDI: d28a3f64 EBP: d214ac80 ESP: d28a3f54
>  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> Process kseriod (pid: 207, ti=d28a2000 task=d287d0e0 task.ti=d28a2000)
> Stack:
>  00000000 d214a7e0 c027bea8 d287d0e0 c01245ec d28a3f68 d28a3f68 d295e000
>  d295d800 d2a00e70 d2a00200 d2a16400 00000000 d214ac80 c027df50 d2a00200
>  d2a00200 d2a00270 c02762d6 d2a00200 00000246 d214ac80 c02767bb d28a3fb4
> Call Trace:
>  [<c027bea8>] atkbd_set_leds+0x4e/0xdd
>  [<c01245ec>] autoremove_wake_function+0x0/0x2d
>  [<c027df50>] psmouse_reconnect+0x81/0x10c
>  [<c02762d6>] serio_reconnect_port+0x21/0x47
>  [<c02767bb>] serio_thread+0x105/0x2a0
>  [<c01245ec>] autoremove_wake_function+0x0/0x2d
>  [<c02766b6>] serio_thread+0x0/0x2a0
>  [<c01242ff>] kthread+0x36/0x5a
>  [<c01242c9>] kthread+0x0/0x5a
>  [<c010382f>] kernel_thread_helper+0x7/0x10
> Code: 3b c0 31 c0 c7 47 58 b3 20 3b c0 5e 5b 5e 5f 5d c3 55 57 56 53
> 83 ec 28 fc b9 06 00 00 00 89 c3 8b 00 8d 7c 24 10 89 04 24 89 c6 <f3>
> a5 8b 44 24 14 8b 54 24 18 8b 7c 24 1c 8b 6c 24 10 89 44 24
> EIP: [<c027ee13>] synaptics_reconnect+0x1a/0x9b SS:ESP 0068:d28a3f54
> ---[ end trace da78f1dea9902482 ]---
>
>

it seems that after resume i can use the machine but i cannot shutdown it.
when i try to reboot or halt, gentoo script hangs in remounting / in r-o mode.

doesn't happen if i don't hibernate. i don't know if it's related. i
see nothing in the console/kernel logs.


-- 
Patrizio Bassi
www.patriziobassi.it
http://piazzadelpopolo.patriziobassi.it
