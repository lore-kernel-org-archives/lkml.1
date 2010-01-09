Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161Ab0AIVNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab0AIVNq convert rfc822-to-quoted-printable (ORCPT
	<rfc822;w@1wt.eu>); Sat, 9 Jan 2010 16:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996Ab0AIVNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 16:13:46 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:37889 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab0AIVNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 16:13:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Gw452c3ocAGXz/3kSlJrudrtLxJ6QmtJRfz5/626FJwZx3TXDlEY7JfNYwPGnQ0NHh
         qTxeWYxzFi67RXhJKKbFJLq0lKs5xzZ5W9tuAiBELc6yGdQfEITsQAhrE5HrqK5jFIoO
         eooSXBfT8n8gBzW5He1L9O+CdxG4QBH7n9wyg=
MIME-Version: 1.0
In-Reply-To: <20100109101038.GA17555@in.ibm.com>
References: <20100109101038.GA17555@in.ibm.com>
Date: Sat, 9 Jan 2010 13:13:39 -0800
Message-ID: <86802c441001091313y1f64f011t616f08cd282a7123@mail.gmail.com>
Subject: Re: [PATCH] Make Intel 8-way Xeons boot again
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: ananth@in.ibm.com
Cc: suresh.b.siddha@intel.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 9, 2010 at 2:10 AM, Ananth N Mavinakayanahalli
<ananth@in.ibm.com> wrote:
> On an 8-way system with Intel Xeon X7350 CPUs, booting 2.6.32 or newe=
r
> kernels fails at:
>
> ...
> CPU0: Intel(R) Xeon(R) CPU =A0 =A0 =A0 =A0 =A0 X7350 =A0@ 2.93GHz ste=
pping 0b
> Booting Node =A0 0, Processors =A0#1 #2 #3 #4 #5 #6 #7 Ok.
> Brought up 8 CPUs
> Total of 8 processors activated (46906.05 BogoMIPS).
>
> Git bisect showed 2fbd07a5f as the offending commit.
>
> With the patch below, I am able to boot the latest Linus' git tree on
> the machine. If this patch is correct, it needs to get into the stabl=
e
> tree too.
>
> Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> ---
> Index: linux-2.6/arch/x86/kernel/apic/probe_64.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/arch/x86/kernel/apic/probe_64.c =A0 =A0 =A02010-01=
-09 14:54:29.000000000 +0530
> +++ linux-2.6/arch/x86/kernel/apic/probe_64.c =A0 2010-01-09 14:57:53=
=2E000000000 +0530
> @@ -70,7 +70,7 @@
> =A0 =A0 =A0 =A0if (apic =3D=3D &apic_flat) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0switch (boot_cpu_data.x86_vendor) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case X86_VENDOR_INTEL:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (num_processors > 8)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (num_processors >=3D=
 8)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0apic =3D=
 &apic_physflat;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case X86_VENDOR_AMD:

can you send out whole bootlog with apic=3Ddebug?

YH
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
