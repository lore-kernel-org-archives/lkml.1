Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbYBDSK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbYBDSK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 13:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYBDSKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 13:10:52 -0500
Received: from main.gmane.org ([80.91.229.2]:52719 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbYBDSKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 13:10:51 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: cecco <f.cecco77@tiscali.it>
Subject: Re: hpet on nforce4/MCP51 in asus a6t
Date: Mon, 4 Feb 2008 18:10:40 +0000 (UTC)
Message-ID: <loom.20080204T173607-160@post.gmane.org>
References: <19861822.1202063637753.JavaMail.root@ps23> <200802041220.20849.carlos@strangeworlds.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 213.230.130.57 (Mozilla/5.0 (X11; U; Linux i686; it; rv:1.8.1.11) Gecko/20071128 Iceweasel/2.0.0.11 (Debian-2.0.0.11-1))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlos Corbacho <carlos <at> strangeworlds.co.uk> writes:

> 
> [Adding tglx to CC as he knows more about HPET's than I]
> 
> On Sunday 03 February 2008 18:33:57 f.cecco77 <at> tiscali.it wrote:
> > Hello,
> > I have  a asus a6t with nforce4/MCP51 chipset. I pass to kernel 2.6.24
> > 32 bit the options acpi_use_timer_override and hpet=force, in this way
> > and the timer IRQ ends up routed as  IO-APIC-edge instead of XT-PIC.
> > With acpi_use_timer_override I just get:
> >
> > TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> >
> > and it works through the IO-APIC.
> >
> > Instead the hpet is disabled and I  just get :
> >
> > Time: acpi_pm clocksource has been installed.
> > Clocksource tsc unstable (delta = -85010975 ns)
> >
> > Is possible to have hpet working also with if the BIOS doesn't support
> > it ?
> 
> One point before we start - MCP51 is nForce 5, not nForce 4 (which is CK804).
> 
> If my understanding is correct, acpi_use_timer_override is only a workaround 
> required for those nForce 5 boards that don't enable the HPET for you.
> 
> So IIUC, you should be able to use either 'hpet=force' 
> or 'acpi_use_timer_override', either of which should solve any timing issues 
> you see, but you shouldn't need both (which should solve your problem of 
> acpi_use_timer_override ignoring the HPET - it shouldn't be needed 
> if 'hpet=force' enables the HPET).
> 
> -Carlos

Thanks for your answer. In my case only acpi_use_timer_override helps with
timing issues, enabling apic. Unfortunately,  either the options hpet=force or 
acpi_use_timer_override  don't enable HPET on asus a6t. The situation is always
the same:

cecco:/home/cecco# grep Clock /proc/timer_list
Clock Event Device: pit
Clock Event Device: lapic
Clock Event Device: lapic

I don't understand because with Turion X2 or amd64 is so difficult to have hpet
and dynticks working. Is important to have a cool notebook, but Amd doesn't seem
 to understand it. Amd has introduced C1e state for a good powersaving, saying
it is equivalent to C3 state but I haven't any prove about this.

Cecco


