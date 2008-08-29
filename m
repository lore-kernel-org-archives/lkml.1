Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbYH2Rh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbYH2Rh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbYH2RhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:37:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:62923 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbYH2RhL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:37:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=i5U5AdCWe4s4JDmglXSN6bpdVzJDPR2QnKxp5GwSSnba604zLwjIXuiwF7RnJHTyex
         zto6d1SAIO8qDd7MvAdGAJMkq0eDSSJN1wlEulTuKir6JdNh6iUPNfpAB53mKhUDPOkU
         DcC18KT0yDA7BtTCoqesmS+EXJBILYs2x3oxU=
Message-ID: <86802c440808291037v688b72e0kda1a606e246223a9@mail.gmail.com>
Date: Fri, 29 Aug 2008 10:37:09 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "=?ISO-8859-1?Q?J.A._Magall=F3n?=" <jamagallon@ono.com>
Subject: Re: Out of mtrrs
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <8EF35F63-8FF6-483F-9DED-D573C40430C8@ono.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <BEE3259F-0ED8-4030-9CA5-D8892C9096C2@ono.com>
	 <20080829090139.30c69ead@infradead.org>
	 <8EF35F63-8FF6-483F-9DED-D573C40430C8@ono.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 9:17 AM, "J.A. Magallón" <jamagallon@ono.com> wrote:
>
> On 2008.08.29, at 18:01, Arjan van de Ven wrote:
>
>> On Fri, 29 Aug 2008 17:32:49 +0200
>> ""J.A. Magallón"" <jamagallon@ono.com> wrote:
>>
>>> Hi all...
>>>
>>> I'm using the xorg intel driver, and drm/X report it has no free mtrrs
>>> in kernel to set up:
>>>
>>> one:~# cat /proc/mtrr
>>> reg00: base=0xfffe0000 (4095MB), size= 128KB: write-protect, count=1
>>> reg01: base=0xfffc0000 (4095MB), size= 128KB: uncachable, count=1
>>> reg02: base=0x00000000 (   0MB), size= 256MB: write-back, count=1
>>> reg03: base=0x10000000 ( 256MB), size= 256MB: write-back, count=1
>>> reg04: base=0x1f800000 ( 504MB), size=   8MB: uncachable, count=1
>>> reg05: base=0x1f600000 ( 502MB), size=   2MB: uncachable, count=1
>>> reg06: base=0x1f500000 ( 501MB), size=   1MB: uncachable, count=1
>>> reg07: base=0x00000000 (   0MB), size= 128KB: uncachable, count=1
>>>
>
> with disable_mtrr_trim, I get te same:
>
> reg00: base=0xfffe0000 (4095MB), size= 128KB: write-protect, count=1
> reg01: base=0xfffc0000 (4095MB), size= 128KB: uncachable, count=1
> reg02: base=0x00000000 (   0MB), size= 256MB: write-back, count=1
> reg03: base=0x10000000 ( 256MB), size= 256MB: write-back, count=1
> reg04: base=0x1f800000 ( 504MB), size=   8MB: uncachable, count=1
> reg05: base=0x1f600000 ( 502MB), size=   2MB: uncachable, count=1
> reg06: base=0x1f500000 ( 501MB), size=   1MB: uncachable, count=1
> reg07: base=0x00000000 (   0MB), size= 128KB: uncachable, count=1
>

the mtrr looks crazy from setting by BIOS...

32bit or 64bit?

please set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1

and boot with "debug" in boot command line...

and send out

dmesg -s 262144 > dmesg.txt

YH
