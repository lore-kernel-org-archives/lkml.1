Return-Path: <linux-kernel-owner+w=401wt.eu-S1751413AbZH0HNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbZH0HNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 03:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZH0HNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 03:13:47 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:49922 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbZH0HNr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 03:13:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KkMkQupo6mOKNKWVzNToAJyUk27xLmmgzj3RfO7E+AxF/TfgcQYeWP/Xztejddrcvx
         JSYpIXkCg/iH5AyhIG/f6cCE+UNV/SLOFecLGNjr/IKaLnGtwlOrOIKwEeJCKTFfJq1Z
         yaedENvjV6kR3Wf4HtW5YyGBVpfuTpVHr7VF0=
MIME-Version: 1.0
In-Reply-To: <200908270313.32528.volkerarmin@googlemail.com>
References: <200908211814.56800.volkerarmin@googlemail.com>
	 <200908222126.31390.volkerarmin@googlemail.com>
	 <86802c440908222322s44957498s72a76940f89271cf@mail.gmail.com>
	 <200908270313.32528.volkerarmin@googlemail.com>
Date: Thu, 27 Aug 2009 00:13:48 -0700
Message-ID: <86802c440908270013k4b8c75b1h6bac33a623ded5e7@mail.gmail.com>
Subject: Re: amd64 + mtrr: only 3.1gb of 8gb are covered, kernel 2.6.30 and 
	earlier.
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Volker Armin Hemmann <volkerarmin@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 6:13 PM, Volker Armin
Hemmann<volkerarmin@googlemail.com> wrote:
> Hi,
>
> On Sonntag 23 August 2009, Yinghai Lu wrote:
>> On Sat, Aug 22, 2009 at 12:26 PM, Volker Armin
>>
>> Hemmann<volkerarmin@googlemail.com> wrote:
>> > when I went from 4gb to 6gb I had a performance degradation. Since the
>> > 8gb are faster and the new cpu is faster, I don't see degradation. But I
>> > wonder how much better performance could be with 'correct' mtrr.
>>
>> that is weird. with 4g should have mem hole remapping.
>>
>> do you still have /proc/mtrr for 6g setup?
>>
>> YH
>
> some more information, mtrr of 8gb with my X2 6000:
>
> reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
> reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
> reg02: base=0x0c0000000 ( 3072MB), size=  128MB, count=1: write-back
> reg03: base=0x0c8000000 ( 3200MB), size=   64MB, count=1: write-back
> reg04: base=0x0cc000000 ( 3264MB), size=   32MB, count=1: write-back
> reg05: base=0x0ce000000 ( 3296MB), size=   16MB, count=1: write-back
>
> from June with 2.6.30, dmesg from that incident is attached
>
> compared that with the mtrr with my X4:
>
> reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
> reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
> reg02: base=0x0c0000000 ( 3072MB), size=  128MB, count=1: write-back
>
>
> just ignore the fgrlx parts - whenever I checked it did not made a difference
> if X was started or not.
>

theo one with X4, you got extra device

[    0.383812] pci 0000:03:00.0: reg 10 io port: [0xd800-0xd8ff]
[    0.383828] pci 0000:03:00.0: reg 18 64bit mmio: [0xfebff000-0xfebfffff]
[    0.383844] pci 0000:03:00.0: reg 30 32bit mmio: [0xfebc0000-0xfebdffff]
[    0.383878] pci 0000:03:00.0: supports D1 D2
[    0.383879] pci 0000:03:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.383916] pci 0000:03:00.0: PME# disabled

so BIOS allocate more mmio space for it.

YH
