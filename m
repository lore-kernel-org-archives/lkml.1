Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbYE0ItO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbYE0ItO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 04:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756721AbYE0Is6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 04:48:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:55659 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054AbYE0Is5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 04:48:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W513ZWeq0s4xauqc0Nu/5ZDOSiPxm4W0iQGaASPKGke3yIy8qt2wGmdCJoMmBjHK7ksZQItaJjfI+4wKPLHw5usC5GKCxDcWyKyzk1dMUlOEePIQVw+Us2Lz0Jrc2mWVndxVMdmA0VSPgJO7b7GMome7+qNSVq7mxKF51fefOXg=
Message-ID: <3877989d0805270148h1b9e7972w880e380c2c4c9b09@mail.gmail.com>
Date: Tue, 27 May 2008 16:48:54 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a race
Cc: "Petr Tesarik" <ptesarik@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
In-Reply-To: <20080527061209.9A24426FAA6@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
	 <3877989d0805222042p176da844k384ea512b1cfb0da@mail.gmail.com>
	 <20080523041940.39E8726FA24@magilla.localdomain>
	 <3877989d0805222224n77ce36b6wdf15c4bab330a0f8@mail.gmail.com>
	 <20080526001527.81E1126FA9E@magilla.localdomain>
	 <3877989d0805251830w70f19e4cu46fbc32148217749@mail.gmail.com>
	 <3877989d0805262031i29db16bcjfa31652afc746b49@mail.gmail.com>
	 <20080527040454.053C526FA9E@magilla.localdomain>
	 <3877989d0805262249yab130cbyfc5f5e54065cec5c@mail.gmail.com>
	 <20080527061209.9A24426FAA6@magilla.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You still need to follow the path inside
> ia64_ptrace_stop() to see how any of this is possible.

I tend to believe singal "deliver" in ptrace_notify path is impossible..
Given the fact that if not block SIGTRAP, the test case just works on
ia64, I still believe some signals have been consumed without letting
debugger know.. but it is just my guess, We still need to investigate
how it happened..I assume you should know how the test case failed. PS
shows the test case hangs in process 6553 which seem to be impossible
... Please help me understand what kind of situation could cause it
happen. That would be very helpful.

root      6516  0.0  0.0 57344 5184 ttyS1    Ss+  19:33   0:00 -bash
root      6551  0.0  0.0  4992 2560 ttyS1    T    19:33   0:00  \_
strace -f ./test1
root      6552  0.0  0.0  4416 1792 ttyS1    T    19:33   0:00      \_ ./test1
root      6553  0.0  0.0 56832 4288 ttyS1    T    19:33   0:01
 \_ /bin/bash ./test2.sh

Thanks,
Luming
