Return-Path: <linux-kernel-owner+w=401wt.eu-S1759012AbXIZQiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012AbXIZQiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 12:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbXIZQhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 12:37:53 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:24202 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbXIZQhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 12:37:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ETwQh4m10SUH5PmXP72optI0A3F/WXStmEmd4MbEXnIV5iVM9aVJ4hyFvtz+nSOHrnQDAeJ+o5eE0sosAqlFmCaIHWBtDSPRYPcz4+lStTRT8Z5eHZl77cRJ2XA83mu+JzDPku0O5mo/fsXR7dey5p4UC765wbAeug/SH6yneoI=
Message-ID: <863e9df20709260937v79d555ffn49f3b8ff7aba42cb@mail.gmail.com>
Date: Wed, 26 Sep 2007 22:07:50 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Avishay Traeger" <atraeger@cs.sunysb.edu>
Subject: Re: KPROBES: Instrumenting a function's call site
Cc: prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org
In-Reply-To: <1190758358.30061.13.camel@rockstar.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1190758358.30061.13.camel@rockstar.fsl.cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/07, Avishay Traeger <atraeger@cs.sunysb.edu> wrote:
> So to measure the latency of foo(), I basically want kprobes to do this:
> pre_handler();
> foo();
> post_handler();
>
> The problem is that the latencies that I am getting are consistently low
> (~10,000 cycles).  When I manually instrument the functions, the latency
> is about 20,000,000 cycles.  Clearly something is not right here.

Single-stepping is done with preemption (and on some archs like ARM,
interrupts) disabled. May be that is contributing to such a skew.

> Is this a known issue?  Instead of using the post-handler, I can try to
> add a kprobe to the following instruction with a pre-handler.  I was
> just curious if there was something fundamentally wrong with the
> approach I took, or maybe a bug that you should be made aware of.
>
> Please CC me on any replies (not subscribed to LKML).
>
> Thanks,
> Avishay
>
--
Regards
Abhishek Sagar

-
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
