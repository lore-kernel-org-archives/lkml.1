Return-Path: <linux-kernel-owner+w=401wt.eu-S940152AbXGaAw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940152AbXGaAw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 20:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756823AbXGaAwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 20:52:49 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:19332 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937482AbXGaAws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 20:52:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=TKoxTagNh0w2Q7o+M98Pux+HsVfdOVo5IvhB8Uixe3ECiWeI2ARIWsof+o1feh6q7R8yitkeGvTgYy2el/rY+FeiC1idlz/HHBSoVVnmeLR1rv8GQS7o3c2Nf0A+KRNYgdtRC1FNv1704k3zPI+JO5Ko/rHxW02ivnUH+JRaW3Y=
Message-ID: <46AE86C7.3060702@googlemail.com>
Date: Tue, 31 Jul 2007 02:48:07 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Joe Korty <joe.korty@ccur.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       jason.baietto@ccur.com
Subject: Re: [PATCH] expand /proc/interrupts to include missing vectors, v2
References: <20070726180522.GA1486@tsunami.ccur.com> <46A8EE78.4040702@zytor.com> <1185816797.3170.1.camel@sven.thebigcorporation.com> <20070730123206.abeab890.akpm@linux-foundation.org> <20070731001718.GA14295@tsunami.ccur.com>
In-Reply-To: <20070731001718.GA14295@tsunami.ccur.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Korty wrote:
> +#ifdef CONFIG_SMP
> +		seq_printf(p, "RES: ");
> +		for_each_online_cpu(j)
> +			seq_printf(p, "%10u ",
> +				per_cpu(irq_stat,j).irq_resched_counts);
> +		seq_printf(p, "  Rescheduling interrupts\n");
> +#endif
> +#ifdef CONFIG_SMP
> +		seq_printf(p, "CAL: ");
> +		for_each_online_cpu(j)
> +			seq_printf(p, "%10u ",
> +				per_cpu(irq_stat,j).irq_call_counts);
> +		seq_printf(p, "  function call interrupts\n");
> +#endif
> +#ifdef CONFIG_SMP
> +		seq_printf(p, "TLB: ");
> +		for_each_online_cpu(j)
> +			seq_printf(p, "%10u ",
> +				per_cpu(irq_stat,j).irq_tlb_counts);
> +		seq_printf(p, "  TLB shootdowns\n");
> +#endif


How about :

#ifdef CONFIG_SMP
		seq_printf(p, "RES: ");
		for_each_online_cpu(j)
			seq_printf(p, "%10u ",
				per_cpu(irq_stat,j).irq_resched_counts);
		seq_printf(p, "  Rescheduling interrupts\n");

		seq_printf(p, "CAL: ");
		for_each_online_cpu(j)
			seq_printf(p, "%10u ",
				per_cpu(irq_stat,j).irq_call_counts);
		seq_printf(p, "  function call interrupts\n");

		seq_printf(p, "TLB: ");
		for_each_online_cpu(j)
			seq_printf(p, "%10u ",
				per_cpu(irq_stat,j).irq_tlb_counts);
		seq_printf(p, "  TLB shootdowns\n");
#endif


should to the same.


Regards,

Gabriel C
