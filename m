Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbYITALB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbYITALB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 20:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbYITAKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 20:10:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:27132 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbYITAKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 20:10:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GVScEAdSgsCkL1uSLCCllUgjn+B6BBxVhAlpb+YMOAzcaVVW4uuUlHoiqRm3mdHigR
         iU4IMi/buysl1Y9LwNF10LbI6lxXU+vghAlAniMT0eGRBJL6/a1kYd09lJ3Ee9MnO3JB
         /f5qdMyzSdTHxr+pCMcw7w4JpXH8DS8Autk0w=
Message-ID: <86802c440809191710o155fa870j9f1d9443896046fe@mail.gmail.com>
Date: Fri, 19 Sep 2008 17:10:42 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: sparse_irq: userspace ABI breakage in -tip tree
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <20080919155321.1181638a@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080919155321.1181638a@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 3:53 PM, Arjan van de Ven <arjan@infradead.org> wrote:
>
> commit 70426a06a58561c401e64c5767d71a011d4b978b
> Author: Yinghai Lu <yhlu.kernel@gmail.com>
> Date:   Tue Aug 19 20:50:27 2008 -0700
>
>    x86: make 32 bit to use sparse_irq
>
> @@ -285,7 +303,7 @@ int show_interrupts(struct seq_file *p, void *v)
>                action = desc->action;
>                if (!action && !any_count)
>                        goto skip;
> -               seq_printf(p, "%3d: ",i);
> +               seq_printf(p, "%#x: ",i);
>  #ifndef CONFIG_SMP
>                seq_printf(p, "%10u ", kstat_irqs(i));
>  #else
>
>
> this is a userspace ABI breakage; you're changing /proc/interrupts from
> decimal to hex! This file is used by both humans and computer programs,
> and the humans will get confused, but the computer programs will break.
> Not a good idea to put into mainline.

change back to decimal could help?

>
> (I'm not so convinced of sparse_irq as a whole to be honest, but that's
> a different story)

anything need to be addressed?

YH
