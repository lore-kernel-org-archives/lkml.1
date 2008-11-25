Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbYKYK3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbYKYK3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYKYK3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:29:11 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36487 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbYKYK3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:29:10 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [2.6.28-rc6] oprofile: "opcontrol --start" output two warnings
Cc: kosaki.motohiro@jp.fujitsu.com, Robert Richter <robert.richter@amd.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <87ljv8ce2j.fsf@basil.nowhere.org>
References: <20081125121212.26C3.KOSAKI.MOTOHIRO@jp.fujitsu.com> <87ljv8ce2j.fsf@basil.nowhere.org>
Message-Id: <20081125192316.26E5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 25 Nov 2008 19:29:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Thank you for good comment.

> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:
> >
> > Index: b/arch/x86/oprofile/op_model_p4.c
> > ===================================================================
> > --- a/arch/x86/oprofile/op_model_p4.c	2008-11-24 06:20:04.000000000 +0900
> > +++ b/arch/x86/oprofile/op_model_p4.c	2008-11-24 06:29:09.000000000 +0900
> > @@ -399,6 +399,8 @@ static void p4_fill_in_addresses(struct 
> >  	unsigned int i;
> >  	unsigned int addr, cccraddr, stag;
> >  
> > +	get_cpu();
> 
> The whole thing seems broken anyways because the only caller of
> fill_in_addresses only assigns to CPU 0 and fill_in_addresses only
> runs on some CPU. So I guess the stagger handling could be just
> removed because it's useless.

hm,
if so, I think get_stagger() is a bit strange.
it depend on caller cpu. then if PREEMPT=Y, it return radom result.

I'm not sure about oprofile design.
but if you are right, I think p4_fill_in_addresses shoudn't use smp_processor_id().

Am I missing any point?


	static unsigned int get_stagger(void)
	{
	#ifdef CONFIG_SMP
	        int cpu = smp_processor_id();
	        return (cpu != first_cpu(per_cpu(cpu_sibling_map, cpu)));
	#endif
	        return 0;
	}



