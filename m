Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbYBDMal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbYBDMal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 07:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbYBDMae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 07:30:34 -0500
Received: from host-240-152.cust.aaawireless.net ([216.23.240.152]:51909 "EHLO
	mail.slackadelic.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbYBDMad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 07:30:33 -0500
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Feb 2008 07:30:33 EST
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: "f.cecco77@tiscali.it" <f.cecco77@tiscali.it>, tglx@linutronix.de
Subject: Re: hpet on nforce4/MCP51 in asus a6t
Date: Mon, 4 Feb 2008 12:20:19 +0000
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <19861822.1202063637753.JavaMail.root@ps23>
In-Reply-To: <19861822.1202063637753.JavaMail.root@ps23>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802041220.20849.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding tglx to CC as he knows more about HPET's than I]

On Sunday 03 February 2008 18:33:57 f.cecco77@tiscali.it wrote:
> Hello,
> I have  a asus a6t with nforce4/MCP51 chipset. I pass to kernel 2.6.24
> 32 bit the options acpi_use_timer_override and hpet=force, in this way
> and the timer IRQ ends up routed as  IO-APIC-edge instead of XT-PIC.
> With acpi_use_timer_override I just get:
>
> TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>
> and it works through the IO-APIC.
>
> Instead the hpet is disabled and I  just get :
>
> Time: acpi_pm clocksource has been installed.
> Clocksource tsc unstable (delta = -85010975 ns)
>
> Is possible to have hpet working also with if the BIOS doesn't support
> it ?

One point before we start - MCP51 is nForce 5, not nForce 4 (which is CK804).

If my understanding is correct, acpi_use_timer_override is only a workaround 
required for those nForce 5 boards that don't enable the HPET for you.

So IIUC, you should be able to use either 'hpet=force' 
or 'acpi_use_timer_override', either of which should solve any timing issues 
you see, but you shouldn't need both (which should solve your problem of 
acpi_use_timer_override ignoring the HPET - it shouldn't be needed 
if 'hpet=force' enables the HPET).

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
