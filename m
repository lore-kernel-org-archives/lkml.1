Return-Path: <linux-kernel-owner+w=401wt.eu-S1766753AbXEBQyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766753AbXEBQyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766755AbXEBQyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:54:09 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:65468 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766753AbXEBQyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:54:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=p503SkI74gzKzzBE1QVVD95MyV4kVfepTaCQhSq83sIViWlOplabKb5IYwqjBenIq+byYLSYap9qfYFdW+XGYZHZ4l9TgMdXmAYA+aN/PT/UddNYPRuKi75SGGv0wPrQzDinEZOaQng6TxBiGpLLLb/ysgCJ3AcEni+2R4GroKc=
Message-ID: <12c511ca0705020954q1230ae85o9ab7ca609fd07507@mail.gmail.com>
Date: Wed, 2 May 2007 09:54:04 -0700
From: "Tony Luck" <tony.luck@intel.com>
To: "Daniel J Blueman" <daniel.blueman@gmail.com>
Subject: Re: Kernel Scalability
Cc: "Rajib Majumder" <rajibm2005@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <6278d2220705020843l718b3272k5d6ebf8b827d0806@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220705020843l718b3272k5d6ebf8b827d0806@mail.gmail.com>
X-Google-Sender-Auth: bf344136d606dec7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
>
> There are 128-processor IA64 systems which run recent 2.6 kernels out
> there; the per-processor counters, RCU and page-fault scalability work
> has been instrumental to the necessary scaling for decent resource
> usage on these.

128 cpu is a bit dated ... there are 512 and 1024 cpu systems being
used in production environments.  The highest reported count stands
at 4096 ... but that was only a prototype system, not a production
machine ... a small number of patches were needed to boot (e.g.
with 10 kernel daemons per cpu, a default kernel hits the maximum
number of process ids limit!).

The question of how well it scales is very workload dependent.  Most
of those high cpu count systems are running scientific workloads that
crunch numbers in user mode for 7.5 million years before making a
single syscall to print that the answer is 42. Obviously scaling of
such applications is near linear.

But your original question was about 4-8 cpus with 2.4/2.6 ... you
will almost certainly be a lot happier with a recent 2.6 kernel. A
great deal of work has been done to make it scale well.  But
there are still some dark corners that haven't been cleaned up
so you will have to run your target application and make your
own measurments on scaling.  If you find that it doesn't scale
well, then we'd like to hear about it here.

-Tony
