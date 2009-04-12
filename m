Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbZDLSMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbZDLSMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 14:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZDLSMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 14:12:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:53888 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbZDLSMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 14:12:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=py142Cn5o4RnxdZerFdZj14lxjWcTi2wVkt3IQBl14vW0BZlp2qlA+eXeXTeuYHi96
         Bp4DRNy7d/ASCzkljml8Aiyk/YFTrSzB29tFXkGJhZw33tuFz38zvK8STgKI60WfBGk/
         w4Y+OcvYS5Va6rlWhZNxfz9u/UO8hVwEDBDeQ=
Date: Sun, 12 Apr 2009 22:12:39 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa@zytor.com, tglx@linutronix.de, xemul@openvz.org, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org, macro@linux-mips.org, andi@firstfloor.org
Subject: Re: [rfc 0/4] x86 - apic dummy ops with cleanups
Message-ID: <20090412181239.GE6942@lenovo>
References: <20090412164738.967602112@openvz.org> <20090412172431.GA26459@elte.hu> <20090412180014.GD6942@lenovo> <20090412180239.GA3489@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090412180239.GA3489@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, Apr 12, 2009 at 08:02:39PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > Thanks, Ingo!
| > 
| > Actually I found one a bit suspicious thing (not sure if it was 
| > initially designed to behave like that).
| > 
| > Suppose we have SMP compiled kernel and even supported on HW level 
| > but then we disable apic thru kernel option. And then when system 
| > startup it should be working fine since we go to uniprocessor 
| > mode. Then the machine going for reboot and we have:
| > 
| > Starting from arch/x86/kernel/reboot.c
| > 
| > native_machine_shutdown
| > 	smp_send_stop
| > 		smp_ops.smp_send_stop
| > 			native_smp_send_stop
| > 				disable_local_APIC
| > 					apic_write(APIC_SPIV, value);
| > 
| > Since we have reserved APIC memory mapped area (in _anycase_) it 
| > doesn't cause any problems but was it initially supposed?
| 
| i dont think that was supposed so. If the APIC wasnt even enabled 
| then we shouldnt try to disable it. Note that there are a few 
| unusual paths to APIC enablement: for example by twiddling the 
| nmi_watchdog knob in /proc/sys - or in theory through a CPU hotplug 
| event.
| 
| 	Ingo
|

Ugh... I expected something like "No, look at that code! You've
missed this snippet!". Which would make me happy :-)

I'll take a look.

        Cyrill
