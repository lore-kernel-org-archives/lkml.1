Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbYL2VQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbYL2VQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 16:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYL2VQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 16:16:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:36912 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbYL2VQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:16:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZtCNoA6Mv2draM0IwoIpJ92S8Cy9tjBBWEZQwpQvRppDcpuD0xS0HEREEnUBygxF0i
         M3aXHokSSxc/NJJHwqfpQ3JqSJtwKgY782uWTUIq4xAon24ABj1jyUk0eiqegRnRo3rI
         WW4JCIfQMWCQvZfZ+1Tue+2OIjg7Gi10BT8N4=
Subject: Re: [PATCH] ACPI: Do not modify SCI_EN directly
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <200812291919.07663.rjw@sisk.pl>
References: <200812291919.07663.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Dec 2008 23:16:06 +0200
Message-Id: <1230585366.4667.26.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-29 at 19:19 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> According to the ACPI specification the SCI_EN flag is controlled by
> the hardware, which sets this flag to inform the kernel that ACPI is
> enabled.  For this reason, we shouldn't try to modify SCI_EN
> directly.  Also, we don't need to do it in irqrouter_resume(), since
> lower-level resume code takes care of enabling ACPI in case it hasn't
> been enabled by the BIOS before passing control to the kernel (which
> by the way is against the ACPI specification).


Hi, 

I am an unfortunate owner of an acer notebook ( aspire 5720 if this
matters) and it doesn't come back after second suspend, subsequently  I
figured out that bios doesn't pass control to linux at all, after second
resume, and moreover, a suspend to disk , 'fixes' this and enables me to
do another suspend/resume cycle. This is a poor man workaround I use
now.

I already told about this here, and many peoples from here (including
you) tried to help me, but unfortunately this is very weird issue, and
nether me nor you can do much about, it is all about guesswork,
something, at least something is 'armed' on resume, so it confuses bios
then (it could be that yet, the critical part that confuses bios happens
in second suspend time)

Needless to say that nothing useful appears in the logs, and everything
seems to work fine following each successful resume (both disk and ram).

so I have a question, do you have a git branch to pull that includes all
patches like this to test, so I build it weekly, and who knows, maybe
something like above will fix it.

Anyway I would gladly test any patch that you suspect might be involved
here.


Also, I tried to do a I/O port and PCI config dump before and after a
resume, aka in 'armed' and 'unarmed' state.

While there were many I/O port registers changes, and I yet to process
it bit after bit (and unfortunately there are plenty of undocumented
stuff), I noticed a meaningful change between bad and good state:


>From ICH8 manual:

"PIRQ[n]_ROUT—PIRQ[A,B,C,D] Routing Control Register

and

PIRQ[n]_ROUT—PIRQ[E,F,G,H]

Interrupt Routing Enable (IRQEN) — R/W.
0 = The corresponding PIRQ is routed to one of the ISA-compatible
interrupts
      specified in bits[3:0].
1 = The PIRQ is not routed to the 8259.

NOTE: BIOS must program this bit to 0 during POST for any of the PIRQs
that are being used. The value of this bit may subsequently be changed
by the OS when setting up for I/O APIC interrupt delivery mode."


bit #7 of all those regs is '1' in good state, and '0' in bad state.

I tried to change it back, but this didn't help, so I post this just in
case, I don't think it is useful.


Best regards,
	Maxim Levitsky



