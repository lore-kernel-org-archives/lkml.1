Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbYBJR0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbYBJR0L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 12:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYBJRZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 12:25:58 -0500
Received: from bizon.gios.gov.pl ([212.244.124.8]:48253 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbYBJRZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 12:25:57 -0500
Date: Sun, 10 Feb 2008 18:25:39 +0100 (CET)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: olel@bizon.gios.gov.pl
To: Maximilian Wilhelm <max@rfc2324.org>
cc: linux-kernel@vger.kernel.org, Eric.Moore@lsi.com
Subject: Re: Kernel Panic in MPT SAS on 2.6.24 (and 2.6.23.14, 2.6.23.9)
In-Reply-To: <20080210024633.GA20450@outback.rfc2324.org>
Message-ID: <Pine.LNX.4.64.0802101823020.22894@bizon.gios.gov.pl>
References: <20080206210426.GD11236@outback.rfc2324.org> <47AB82DD.90201@ans.pl>
 <20080208012028.GF11236@outback.rfc2324.org> <20080208014805.GG11236@outback.rfc2324.org>
 <20080210024633.GA20450@outback.rfc2324.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1702972562-1202664339=:22894"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1702972562-1202664339=:22894
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 10 Feb 2008, Maximilian Wilhelm wrote:

> Am Friday, den  8 February hub Maximilian Wilhelm folgendes in die Tasten=
:
>
>> Just noticed that Eric's address was wrong, so resend with corrected Cc.
>
>> Eric, my intial report was http://lkml.org/lkml/2008/2/6/300
>>
>>> Am Thursday, den  7 February hub Krzysztof Oledzki folgendes in die Tas=
ten:
>>>
>>> Hi!
>>>
>>>>> While installing my new firewall I got the following kernel panic in
>>>>> the MPT SAS driver which I need for the disks.
>>>
>>>>> The first kernel I bootet was 2.6.23.14 which did panic so I tried a
>>>>> 2.6.24 which panics, too. Our usual FAI kernel (2.6.23.9) is also
>>>>> affected.
>>>
>>>> Could you please try 2.6.22-stable?
>>>
>>> Yes it works :-/
>>>
>>> I've put some things which on the web which might be helpful:
>>>
>>> dmesg=09=09http://files.rfc2324.org/mptsas_panic/2.6.22-dmesg
>>> lspci -v=09http://files.rfc2324.org/mptsas_panic/2.6.22-lspci-v
>>> .config=09=09http://files.rfc2324.org/mptsas_panic/2.6.22-config
>>>
>>> I'll search for the last working kernel and try to break it down to a
>>> commit tommorow when I can get a serial console or direct access.
>>> The Java driven console redirection is everything else than fulfilling =
:-(
>>>
>>>> It looks *very* similar to my problem:
>>>
>>>> http://bugzilla.kernel.org/show_bug.cgi?id=3D9909
>>>
>>> It seems to be the same controller:
>>>
>>> 01:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068E PCI=
-Express Fusion-MPT SAS (rev 08)
>>> =09Subsystem: Dell Unknown device 1f10
>>> =09Flags: bus master, fast devsel, latency 0, IRQ 16
>>> =09I/O ports at ec00 [size=3D256]
>>> =09Memory at fc8fc000 (64-bit, non-prefetchable) [size=3D16K]
>>> =09Memory at fc8e0000 (64-bit, non-prefetchable) [size=3D64K]
>>> =09Expansion ROM at fc900000 [disabled] [size=3D1M]
>>> =09Capabilities: [50] Power Management version 2
>>> =09Capabilities: [68] Express Endpoint IRQ 0
>>> =09Capabilities: [98] Message Signalled Interrupts: Mask- 64bit+ Queue=
=3D0/0 Enable-
>>> =09Capabilities: [b0] MSI-X: Enable- Mask- TabSize=3D1
>
> I did a git bisect between v2.6.22 v2.6.23 and it seems that
>  6cb8f91320d3e720351c21741da795fed580b21b
> introduced some badness.

Thanks! This was *really* useful!

Now, how about attached patch? Should work with both 2.6.23 and 2.6.24.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1702972562-1202664339=:22894
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=scsi-mpt-fusion-dont-oops-if-NumPhys-0.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0802101825390.22894@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=scsi-mpt-fusion-dont-oops-if-NumPhys-0.patch

W1NDU0ldIG1wdCBmdXNpb246IERvbid0IG9vcHMgaWYgTnVtUGh5cz09MA0K
DQpEb24ndCBvb3BzIGlmIE51bVBoeXM9PTAsIGluc3RlYWQgcmV0dXJuIC1F
Tk9ERVYuDQpUaGlzIHBhdGNoIGZpeGVzIGh0dHA6Ly9idWd6aWxsYS5rZXJu
ZWwub3JnL3Nob3dfYnVnLmNnaT9pZD05OTA5DQoNClNpZ25lZC1vZmYtYnk6
IEtyenlzenRvZiBQaW90ciBPbGVkemtpIDxvbGVAYW5zLnBsPg0KDQpkaWZm
IC1OdXIgYS9kcml2ZXJzL21lc3NhZ2UvZnVzaW9uL21wdHNhcy5jIGIvZHJp
dmVycy9tZXNzYWdlL2Z1c2lvbi9tcHRzYXMuYw0KLS0tIGEvZHJpdmVycy9t
ZXNzYWdlL2Z1c2lvbi9tcHRzYXMuYwkyMDA3LTEwLTA5IDIyOjMxOjM4LjAw
MDAwMDAwMCArMDIwMA0KKysrIGIvZHJpdmVycy9tZXNzYWdlL2Z1c2lvbi9t
cHRzYXMuYwkyMDA4LTAyLTEwIDE3OjM4OjUxLjAwMDAwMDAwMCArMDEwMA0K
QEAgLTE3NzIsNiArMTc3MiwxMSBAQA0KIAlpZiAoZXJyb3IpDQogCQlnb3Rv
IG91dF9mcmVlX2NvbnNpc3RlbnQ7DQogDQorCWlmICghYnVmZmVyLT5OdW1Q
aHlzKSB7DQorCQllcnJvciA9IC1FTk9ERVY7DQorCQlnb3RvIG91dF9mcmVl
X2NvbnNpc3RlbnQ7DQorCX0NCisNCiAJLyogc2F2ZSBjb25maWcgZGF0YSAq
Lw0KIAlwb3J0X2luZm8tPm51bV9waHlzID0gYnVmZmVyLT5OdW1QaHlzOw0K
IAlwb3J0X2luZm8tPnBoeV9pbmZvID0ga2NhbGxvYyhwb3J0X2luZm8tPm51
bV9waHlzLA0K

---187430788-1702972562-1202664339=:22894--
