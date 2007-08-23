Return-Path: <linux-kernel-owner+w=401wt.eu-S1760561AbXHWLne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760561AbXHWLne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 07:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302AbXHWLn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 07:43:27 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:35729 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1753032AbXHWLn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 07:43:26 -0400
Date: Thu, 23 Aug 2007 15:49:36 +0400
From: Konstantin Baydarov <kbaidarov@ru.mvista.com>
To: vgoyal@in.ibm.com
Cc: RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] kexec: reenable HPET before kexec
Message-ID: <20070823154936.3b7ae498@windmill.dev.rtsoft.ru>
In-Reply-To: <20070823090845.GA13065@in.ibm.com>
References: <20070820205530.1ffd5876@windmill.dev.rtsoft.ru>
	<20070823090845.GA13065@in.ibm.com>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.19; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 14:38:45 +0530
Vivek Goyal <vgoyal@in.ibm.com> wrote:
> Does your kernel 2 boot normally? I mean through BIOS and boot-loader?
> This explanation seems to be suggesting that because PM and ACPI is
> disabled, kernel 2 does not search for HPET. If this is the case,
> this kernel will not boot even through normal boot-loader and will
> try to use PIT instead?
> 
> If so, it is not an kexec issue at all.
> 
> Thanks
> Vivek

kernel 2 boots normally through BIOS and boot-loader. I agree with your
explanation.
It seems that kernel 2 can't enable PIT, when it is executed by kexec.
As kernel 1 disabled HPET(IRQ0 source) and PIT is "broken"(or isn't
enabled) IRQ0 are not triggered at all, and kernel 2 hangs.
As kernel 2 boots normally through BIOS and boot-loader, than
additional code needed(in Linux kernel init code) for PIT or ACPI
or APIC initialization, I mean the same code as executed on BIOS stage.
I agree that it's not an kexec issue. But can we use my fix as a
workaround(to make kexec work) until PIT will be fixed?
Everything above is correct for i386/x86_64 RT(2.6.23-rc2-rt2) kernel
and for i368 "plain"(2.6.23-rc3) kernel. Bug isn't reproduced in 2.6.23-rc3
x86_64 kernel, because x86_64 code never disables HPET. So on every
boot(initiated by kexec or BIOS) IRQ0 are triggered.

