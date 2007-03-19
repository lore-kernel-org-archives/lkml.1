Return-Path: <linux-kernel-owner+w=401wt.eu-S1752805AbXCSTt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbXCSTt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 15:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbXCSTt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 15:49:56 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:16509 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbXCSTtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 15:49:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sfDnKVmYYZ5R8ePkiG1z5qgR3V00WAjRKM5wUPBFB8vDYxVLBvYAvn0vkCE2YLER/wR41SAC5PAMotT/G8Zdg6QcQsdBPhIA5tfuvtSD7fy04qwVQgMYK4132rDWstmDdJWb9TdPrK3TSGLMx5YJSdhbT+XxEo6UtPLAHgNVVy4=
Message-ID: <b93822910703191249i40a70418ka8165da52070ae82@mail.gmail.com>
Date: Mon, 19 Mar 2007 20:49:53 +0100
From: "Stefan Prechtel" <stefan.prechtel@googlemail.com>
To: tglx@linutronix.de
Subject: Re: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, "Len Brown" <lenb@kernel.org>,
       "Andi Kleen" <ak@suse.de>, "john stultz" <johnstul@us.ibm.com>
In-Reply-To: <1174332477.13341.561.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
	 <1174325803.13341.515.camel@localhost.localdomain>
	 <1174326499.13341.517.camel@localhost.localdomain>
	 <b93822910703191153x20249f00vb604a0eda075a23a@mail.gmail.com>
	 <1174332477.13341.561.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/19, Thomas Gleixner <tglx@linutronix.de>:
> We have a broadcast mechanism for this, which gets activated from ACPI,
> but the broadcast mechanism is not activated:
>
> [    3.798000] Clock Event Device: pit
> ....
> [    3.798000] tick_broadcast_mask: 00000000
>
> Can you please boot with 2.6.20 or earlier and check the output
> of /proc/interrupts ?
>
> IRQ#0 and the LOC (local APIC timer) Interrupts should increment in the
> same frequency.
>
>         tglx

Here is the output of /proc/interrupts on 2.6.20:
           CPU0       CPU1
  0:       7089          0  local-APIC-edge-fasteio   timer
....
and this on 2.6.21-rc*:
           CPU0       CPU1
  0:        255          0  local-APIC-edge-fasteoi   timer
....

on 2.6.21-rc* the number "255" doesn't change.

But if it is ACPI relevant, shouldn't it boot with acpi=off?
I've tried with acpi=off and noapic but only with nolapic it started.

And the content of /proc/acpi/processor/C000/power shows only one
c-state; shouldn't it show more C-states? (please correct me if I'm
wrong)

 # cat /proc/acpi/processor/C000/power
active state:            C1
max_cstate:              C8
bus master activity:     00000000
maximum allowed latency: 2000 usec
states:
   *C1:                  type[C1] promotion[--] demotion[--]
latency[000] usage[00000000] duration[00000000000000000000]


Regards,
Stefan Prechtel
