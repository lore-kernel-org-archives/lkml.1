Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbXA0JF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbXA0JF7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 04:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbXA0JF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 04:05:59 -0500
Received: from mis011-2.exch011.intermedia.net ([64.78.21.129]:44804 "EHLO
	mis011-2.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752231AbXA0JF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 04:05:58 -0500
Message-ID: <45BB15F1.6020600@qumranet.com>
Date: Sat, 27 Jan 2007 11:05:53 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: caglar@pardus.org.tr
CC: lkml <linux-kernel@vger.kernel.org>, kvm-devel@lists.sourceforge.net
Subject: Re: [PATCH] KVM: 'asm' operand has impossible constraints
References: <200701260140.47760.caglar@pardus.org.tr>
In-Reply-To: <200701260140.47760.caglar@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Jan 2007 09:05:57.0296 (UTC) FILETIME=[5B4C3300:01C741F2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

S.Çağlar Onur wrote:
> Hi;
>
> -rc6 fails with latest gcc 4.2 snapshot as following;
>
> CC [M]  drivers/kvm/svm.o
> drivers/kvm/svm.c:206: warning: 'inject_db' defined but not used
> drivers/kvm/svm.c: In function 'svm_vcpu_run':
> drivers/kvm/kvm.h:560: error: 'asm' operand has impossible constraints
> make[2]: *** [drivers/kvm/svm.o] Error 1
> make[1]: *** [drivers/kvm] Error 2
> make: *** [drivers] Error 2
>
> And according to this thread http://lkml.org/lkml/2006/11/11/129, solution is 
> converting g to rm, patch follows
>
>   

The patch looks correct, but I don't understand the gcc error message.  
Are we sure this isn't a gcc 4.2 bug?

"g" appears to be equivalent to "rmi", if "i" is impossible, gcc is free 
to use "r" or "m", no?


> Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
>
> Index: linux-2.6/drivers/kvm/kvm.h
> ===================================================================
> --- linux-2.6.orig/drivers/kvm/kvm.h	2007-01-26 01:38:35.000000000 +0200
> +++ linux-2.6/drivers/kvm/kvm.h	2007-01-26 01:37:48.000000000 +0200
> @@ -557,7 +557,7 @@
>  #ifndef load_ldt
>  static inline void load_ldt(u16 sel)
>  {
> -	asm ("lldt %0" : : "g"(sel));
> +	asm ("lldt %0" : : "rm"(sel));
>  }
>  #endif
>
>
>   


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

