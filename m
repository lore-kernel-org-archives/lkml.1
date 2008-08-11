Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbYHKTCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbYHKTCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYHKTB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:01:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:26655 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbYHKTB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:01:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qVgIM3TNUQCS2dFYRw1TF3gd2vSVyFomQ2bdK233xR0XHUXvI5MG7q359FWmQ3Chqe
         eBomKXr5w6KTambQ08qW2Hu9aBWU1kk3hFNlpdKZ+ok02AUSWVNNPy/twonowdennILf
         syuhetlbaf0rDnvQMannps+XW2qTToZnmGeTs=
Date: Mon, 11 Aug 2008 23:01:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Andrew Morton <akpm@osdl.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: kill arch/x86/kernel/mpparse.c debugging printk.
Message-ID: <20080811190156.GD18969@lenovo>
References: <20080811122038.GA10082@elte.hu> <48A05E79.4030304@keyaccess.nl> <48A05EB1.3050508@keyaccess.nl> <20080811164508.GA18969@lenovo> <48A074D1.4070803@keyaccess.nl> <20080811174147.GO4524@elte.hu> <48A07FC1.5040806@keyaccess.nl> <20080811183300.GB9627@elte.hu> <20080811184257.GB18969@lenovo> <20080811184903.GB12788@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811184903.GB12788@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Mon, Aug 11, 2008 at 08:49:03PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > |   early_param conversions - and i think highlighting that as 
| > |   separate commits might give someone ideas to improve the 
| > |   early_param() facility, if they see the fix patterns.
| > 
| > Ingo - I think the problem with early_param is not NULL itself but 
| > rather - what is the right way to deal with boot params? I mean we 
| > could pass empty string (not NULL) in case of argument absence _but_ 
| > would it be the right way? If you remember when I sent first series 
| > for early_param checking (and actually there are number of same issue 
| > exists for example in s390 arch) - I was asking community what is the 
| > best way - since I'm not that strong in interface engineering - i 
| > prefer fix the bugs :)
| 
| what would be the downside of passing in empty strings? I cannot see any 
| serious one. The upside is that the conversion is more mechanic and 
| safer as well.
| 
| Maybe the return code inversion could be / should be fixed as well, that 
| seems like an unnecessary change as well:
| 
|   -       return 1;
|   +       return 0;
|    }
|   -__setup("apic=", apic_set_verbosity);
|   +early_param("apic", apic_set_verbosity);
| 
| Why do early-params have a different return convention from 
| usual-params? It's just an unnecessary barrier against conversion to 
| early params.
| 
| 	Ingo
| 

Actually - I don't know why is checking for 0. It's defined in
init/main.c:do_early_param -

	if (p->setup_func(val) != 0)
		printk(KERN_WARNING
		       "Malformed early option '%s'\n", param);

if we change it there - the lot of kernel code should be patched then.
I don't think it will be approved (even by being mechanical change) :) 

To pass empty string - I think it's possible. I think I'll check it
tomorrow evening (have no time now). Or maybe someone else could
grep kernel tree to check if there only strcmp and conversion to
numeric values only (which shouldn't lead to any new bugs I hope :)

		- Cyrill -
