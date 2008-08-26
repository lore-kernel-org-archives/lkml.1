Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbYHZJX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbYHZJX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 05:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbYHZJXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 05:23:50 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:29758 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbYHZJXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 05:23:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding:sender;
        b=Nuev+dUwRinNAb4usX+YXD42/yaoOcKFEO7iWqc3dvst31b73aQd2yZuZT5cErMT/Q
         eD6T/ELbiISkNgdd/jAYQlX8RDUPSYcEqsqXt/tuFit4jVetLwI5RiQdp2iaEP+7bY9T
         c19gkvm761JYrhUFMplx+PT26fSFjCtTTy0Bw=
Message-ID: <48B3CB9F.4070903@tuffmail.co.uk>
Date: Tue, 26 Aug 2008 10:23:43 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-kernel <linux-kernel@vger.kernel.org>, power@bughost.org
Subject: Re: What is "extra timer interrupt" in powertop output?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> After disabling CD-ROM polling the next top-100 winner is "extra timer
> interrupt":
>
> Cn Avg residency P-states (frequencies)
> C0 (cpu running) ( 4.2%) 750 Mhz 0.0%
> polling 0.0ms ( 0.0%) 500 Mhz 100.0%
> C1 0.0ms ( 0.0%)
> C2 0.9ms (95.8%)
>
>
> Wakeups-from-idle per second : 1101.2 interval: 5.0s
> Power usage (ACPI estimate): 11.7W (2.2 hours)
>
> Top causes for wakeups:
> 31.6% ( 8.4) : extra timer interrupt
> 15.0% ( 4.0) hald-addon-acpi : schedule_timeout (process_timeout)
>
> I assume, this is what is simply called "timer":
> {pts/1}:~%> cat /proc/interrupts
> CPU0
> 0: 9060975 XT-PIC-XT timer

>
> Any way to find out why there are so many of them? System is using dynamic
> ticks:
> {pts/1}:~/src/linux-git%> grep NO_HZ /boot/config
> CONFIG_NO_HZ=y
>

One possible reason is the hardware timer used cannot delay for long
periods, so the kernel has to wake up more often than necessary.  Um. 
This doesn't seem to be explained well in docs.

The question is do you have HPET (good hardware timer) enabled? 
Enabling HPET is supposed to be one of the things powertop suggests. 
Sometimes it is a BIOS option, or may require a kernel option, or may
not be supported on your motherboard.

Alan
