Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbZIMUUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbZIMUUw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 16:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbZIMUUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 16:20:51 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:54931 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZIMUUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 16:20:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hHDGqrPIdAiBNe4XCx1VcsiiwBmxs+4y2iPMrGm39SQJULde3EBLKXrxv6N/jThZmi
         VImhUeGF41rMlEH24nnwv2oJJP+0KH8SUeAxDv7sHMcnfY/4XffaSxyqTJIg9QnH5Ldc
         QS2Yg0Bii+yGJloJrmz1YJ8TbwKS+mJFVDN5g=
MIME-Version: 1.0
In-Reply-To: <20090911185600.9641f38b.sfr@canb.auug.org.au>
References: <20090911185600.9641f38b.sfr@canb.auug.org.au>
Date: Sun, 13 Sep 2009 22:20:54 +0200
X-Google-Sender-Auth: bcd4907478aa8ce3
Message-ID: <10f740e80909131320j1b4f6552qf809fbf5049375d3@mail.gmail.com>
Subject: Re: linux-next: tip tree build warning
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 10:56, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Today's linux-next build (powerpc allnoconfig) produced this warning:
>
> kernel/sched.c:122: warning: 'double_rq_lock' declared 'static' but never defined
>
> Introduced by commit 18a3885fc1ffa92c2212ff0afdf033403d5b0fa0 ("sched:
> Remove reciprocal for cpu_power").  This is a build with CONFIG_SMP
> undefined.

Yep. same here.

It's even more fishy:
  - double_rq_lock() is useded inside #ifdef CONFIG_PREEMPT
  - double_rq_lock() is defined inside #ifdef CONFIG_SMP
  - double_rq_lock() is used inside #ifdef CONFIG_HOTPLUG_CPU

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
