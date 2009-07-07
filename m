Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbZGGRmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbZGGRmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 13:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbZGGRmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 13:42:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:35828 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754638AbZGGRmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 13:42:04 -0400
X-Authenticated: #1512929
X-Provags-ID: V01U2FsdGVkX19ktudnnBBk5mLKUL3dEF43doOeL6Jx7mSo9kxH38
	sUT2+o4/YNnOGv
Message-ID: <4A5388EA.7030503@warlich.name>
Date: Tue, 07 Jul 2009 19:42:02 +0200
From: Christof Warlich <christof@warlich.name>
Organization: Warlich Consulting
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>
Subject: Re: "EXT3-fs error" after resume from s2ram
References: <4A4771FD.1020207@warlich.name> <4A480859.5010206@gmail.com> <4A48C799.2010102@warlich.name> <4A495C2D.1040706@gmail.com> <4A49A49C.10104@warlich.name> <4A4C42E2.6030305@gmail.com> <4A51C929.5010909@warlich.name> <4A52931D.5070109@gmail.com> <4A52F39A.1030704@warlich.name> <4A5311C7.1020507@warlich.name> <4A535973.9090206@gmail.com>
In-Reply-To: <4A535973.9090206@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080108020703020006090105"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080108020703020006090105
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Robert Hancock schrieb:
> On 07/07/2009 03:13 AM, Christof Warlich wrote:
>> Christof Warlich schrieb:
>>> Do you think I can fix the issue and circumvent the BIOS by passing
>>> the real geomerty of the drive as kernel boot parameters? This may
>>> also have the nice side effect that I could utilize the full capacity
>>> of the drive. I'll definitly do some experiments in this direction and
>>> let you know immediately if I succeed. Please let me know if this may
>>> be a waste of time or if you know an appropriate fix.
>> I retried with the boot parameter hda=16383,16,63 according to the
>> values that I got from fdisk, but without success. Anyway, I would have
>> expected that the kernel may have had a way to set the LBA48 geometry
>> instead of CHS, but it looks like I'm on the wrong track here...
>
> That's an old IDE parameter, not a libata one, and 160GB is way too 
> large to be settable using CHS. What you likely want to do is pass the 
> ignore_hpa=1 option to libata when it's loaded - either 
> libata.ignore_hpa=1 on kernel command line, or in /etc/modprobe.conf 
> if it's a module (how exactly to do this depends on your 
> distribution). That way the protected area on the disk will get 
> disabled and you can use the full capacity.
Hmm - that doen't seem to fix it :-(:

After the reboot, fdisk still reports 137.4GB, and dmesg now contains 
the line:

ata1.00: device aborted resize (268435456 -> 312581808), skipping HPA 
handling

instead of

ata1.00: HPA detected: current 268435456, native 312581808

that we have seen without the libata.ignore_hpa=1 kernel command line 
option.

After s2ram -f -p, I still see the EXT3-fs error on resume. Is it worth 
to take another log from this suspend /resume cycle?

--------------080108020703020006090105
Content-Type: text/x-vcard; charset=utf-8;
 name="christof.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="christof.vcf"

begin:vcard
fn:Christof Warlich
n:Warlich;Christof
org:Warlich Consulting
adr:;;Am Haselhang 7;Hilpoltstein;Bayern;91161;Deutschland
email;internet:christof@warlich.name
tel;work:09174/492914
tel;home:09174/492914
x-mozilla-html:TRUE
url:www.warlich.name
version:2.1
end:vcard


--------------080108020703020006090105--
