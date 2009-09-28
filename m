Return-Path: <linux-kernel-owner+w=401wt.eu-S1752531AbZI1P3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbZI1P3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 11:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbZI1P3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 11:29:21 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:56576 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZI1P3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 11:29:20 -0400
Message-ID: <4AC0D651.7030009@msgid.tls.msk.ru>
Date: Mon, 28 Sep 2009 19:29:21 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31: booting on a PIII Celeron?
References: <4AC0D59F.8000502@msgid.tls.msk.ru>
In-Reply-To: <4AC0D59F.8000502@msgid.tls.msk.ru>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> Hello.
> I've a problem here with 2.6.31.  kernel is
> compiled for PIII:
> 
>  CONFIG_MPENTIUMIII=y
>  CONFIG_X86_GENERIC=y
> 
> This kernel works on real PIII machine - like this:
> 
> vendor_id    : GenuineIntel
> cpu family    : 6
> model        : 8
> model name    : Pentium III (Coppermine)
> stepping    : 10
> cpu MHz        : 997.580
> 
> But it fails on a Celeron:
> 
> vendor_id    : GenuineIntel
> cpu family    : 6
> model        : 8
> model name    : Celeron (Coppermine)
> stepping    : 6
> cpu MHz        : 797.481
> 

There's one more difference between the two:

PIII, working:
flags: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pse36 mmx fxsr sse up
Celeron, !working:
flags: fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pse36 mmx fxsr sse up

So the celeron machine lacks "apic" flag.  And in my
kernel config, apic is enabled:
  CONFIG_X86_LOCAL_APIC=y
  CONFIG_X86_IO_APIC=y
(but not on the command line like apic=force)

> it fails on early boot, after a bootloader printed
> "Loading kernel... initrd..." -- after that, on the
> Celeron machine, it reboots instantly.
> 
> It's the same kernel binary, I tried it on several
> machines, and the result is pretty consistent - if
> it's a PIII-Celeron it reboots, if it's a PIII -
> kernel boots and works ok.
> 
> All previous kernels with the same config worked on
> these machines, at least as far as this issue is
> concerned.
> 
> Is it a known issue?  Is there anything else I can
> try to debug it?
> 
> Thanks!
> 
> /mjt

