Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbYKDKs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbYKDKs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 05:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYKDKsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 05:48:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37610 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbYKDKst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 05:48:49 -0500
Message-ID: <4910283B.4070501@redhat.com>
Date: Tue, 04 Nov 2008 12:47:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Eduardo Habkost <ehabkost@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use BIOS reboot on Toshiba Portege 4000
References: <200810312118.45368.arvidjaar@mail.ru>	<20081103090843.GI11730@elte.hu> <490ECC4D.9090704@redhat.com>	<20081103133306.GZ23893@blackpad> <490F0DA3.4090108@redhat.com> <m1myggdbzg.fsf@frodo.ebiederm.org>
In-Reply-To: <m1myggdbzg.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> I think we are confusing two issues here.
>
> - Ordinary machine_restart which happens to call emergency_restart.
>   And is proceeded by machine_shutdown.
>
> - And emergency_restart itself.
>
> To some extent I would be a lot happier if Alt-sysrq-r did what
> was necessary to get into a context where it can call machine_restart
> or even better kernel_restart().
> emergency_restart() is a nice idea but is broken by design.
>
>   

Isn't emergency_restart() equivalent to kexec()?  Both start from 
indeterminite conditions.

> That said.  If we can turn off vmx on that one processor.
> That should be enough for the cpu to triple fault and let
> the BIOS do what it needs to do on that cpu i.e. outb(magic, 0x92)
> and toggle a motherboard level reset?
>
>   

If triple fault is wired to INIT (as it is at least on some systems; for 
example one of mine) then the cpu will reset, but why will the bios 
proceed to issue a motherboard reset?  Won't it happily POST it's way to 
boot (leaving the other cpus dead)?

> If I read the earlier comments correctly the deep issue is
> that going through ACPI to reset systems is less reliable than
> doing it the classic way.
>   

It depends on the system; both are unreliable.  But if we use the same 
trick as with kdump (NMI SIPI + vmxoff) the choice will be orthogonal to 
whether vmx is in use or not.

-- 
error compiling committee.c: too many arguments to function

