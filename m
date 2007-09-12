Return-Path: <linux-kernel-owner+w=401wt.eu-S1765752AbXILL4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765752AbXILL4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933778AbXILLz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:55:59 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:64814 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933775AbXILLz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:55:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NkEbySNgyIZSSN63TzUD8u3v8+pcXE5Dx0u6gPV/zgC3YdqThsokHEDAYx8gSByMn6n2O8LOEn40brdfKwaK6ng4Xn1PIw6gCIRVsm42g09ls2j7sv13d4CWCqDo4z0nkLp+YMWCDrphCwf+JFD5sQM/z+16ixvIUeKGbbo5gPI=
Message-ID: <416aa1ad0709120455l341f1079g9187c13798d310c1@mail.gmail.com>
Date: Wed, 12 Sep 2007 17:25:57 +0530
From: "kalash nainwal" <kalash.nainwal@gmail.com>
To: "Venkat Subbiah" <venkats@cranite.com>
Subject: Re: irq load balancing
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <3641F7C576757E49AE23AD0D820D72C4232DEA@mailnode1.cranite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3641F7C576757E49AE23AD0D820D72C4232DEA@mailnode1.cranite.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/07, Venkat Subbiah <venkats@cranite.com> wrote:
> Most of the load in my system is triggered by a single ethernet IRQ. Essentially the IRQ schedules a tasklet and most of the work is done in the taskelet which is scheduled in the IRQ. From what I read looks like the tasklet would be executed on the same CPU on which it was scheduled. So this means even in an SMP system it will be one processor which is overloaded.
>
> So will using the user space IRQ loadbalancer really help? What I am doubtful about is that the user space load balance comes along and changes the affinity once in a while. But really what I need is every interrupt to go to a different CPU in a round robin fashion.
>
> Looks like the APIC  can distribute IRQ's dynamically? Is this supported in the kernel and any config or proc interface to turn this on/off.
>

/proc/irq/<irq#>/smp_affinity. But this is not generally suggested for
performance reasons (cache issues etc).

>
> Thx,
> Venkat
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
