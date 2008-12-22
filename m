Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbYLVNXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbYLVNXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 08:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbYLVNXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 08:23:42 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:46116 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbYLVNXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 08:23:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=A7pVxWfcT1oaXmMu0QxZ31n4VI/nL5gPtJ3f/gVmTwE6fIQHlAeKvYv0F9M8ZvQU+k
         bJL+5XwdYCR870xpJEMwkGC2Rin5wZIUO/0WXn2I4kCjtXspZtR4rFG2+g2/esXonLOE
         0I79oTq2806wzx2e2TKITfwIWYcAfiBXTi29U=
Message-ID: <7c86c4470812220523y7ccca8cag40f758393017cf7c@mail.gmail.com>
Date: Mon, 22 Dec 2008 14:23:38 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Markus Metzger" <markus.t.metzger@intel.com>
Subject: Re: [patch] x86, ptrace: require admin privileges for ptrace BTS extension
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       juan.villacis@intel.com
In-Reply-To: <20081222130218.A31747@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081222130218.A31747@sedona.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,

On Mon, Dec 22, 2008 at 1:02 PM, Markus Metzger
<markus.t.metzger@intel.com> wrote:
> Require admin privileges for ptrace BTS extension.
>
Can you explain the motivations for this?

I thought the BTS extension was a per-process functionality.
So how come I can debug and single step my process without
admin privilege and I cannot capture its own branches. Does this
have to do with user vs. kernel execution of the proces (BTS
captures everything if I recall)?

Thanks.

>
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
> ---
>
> Index: gits/arch/x86/kernel/ptrace.c
> ===================================================================
> --- gits.orig/arch/x86/kernel/ptrace.c  2008-12-22 09:09:25.000000000 +0100
> +++ gits/arch/x86/kernel/ptrace.c       2008-12-22 11:03:01.000000000 +0100
> @@ -21,6 +21,7 @@
>  #include <linux/audit.h>
>  #include <linux/seccomp.h>
>  #include <linux/signal.h>
> +#include <linux/capability.h>
>
>  #include <asm/uaccess.h>
>  #include <asm/pgtable.h>
> @@ -742,6 +743,10 @@
>        struct ptrace_bts_config cfg;
>        int error = 0;
>
> +       error = -EPERM;
> +       if (!capable(CAP_SYS_ADMIN))
> +               goto errout;
> +
>        error = -EOPNOTSUPP;
>        if (!bts_cfg.sizeof_bts)
>                goto errout;
> ---------------------------------------------------------------------
> Intel GmbH
> Dornacher Strasse 1
> 85622 Feldkirchen/Muenchen Germany
> Sitz der Gesellschaft: Feldkirchen bei Muenchen
> Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
> Registergericht: Muenchen HRB 47456 Ust.-IdNr.
> VAT Registration No.: DE129385895
> Citibank Frankfurt (BLZ 502 109 00) 600119052
>
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
>
>
