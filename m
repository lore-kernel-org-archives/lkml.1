Return-Path: <linux-kernel-owner+w=401wt.eu-S965641AbXCPQ7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965641AbXCPQ7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965622AbXCPQ7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:59:55 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46979 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965641AbXCPQ7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:59:54 -0400
Date: Fri, 16 Mar 2007 09:57:39 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Adrian Bunk <bunk@stusta.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 20/26] Xen-paravirt_ops: Core Xen implementation
Message-ID: <20070316165739.GL10574@sequoia.sous-sol.org>
References: <20070301232443.195603797@goop.org> <20070301232528.812011702@goop.org> <20070316091411.GF23174@elte.hu> <20070316163338.GI10574@sequoia.sous-sol.org> <45FAC969.6070006@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FAC969.6070006@goop.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Chris Wright wrote:
> > That's been fixed, the two are built as seperate objects now.
> 
> Actually, we tried it but it causes bad kernel images with some
> binutils, so it has to be included for now.

Ah, missed that.

> >>> @@ -437,9 +437,9 @@ static unsigned long native_store_tr(voi
> >>>  
> >>>  static void native_load_tls(struct thread_struct *t, unsigned int cpu)
> >>>  {
> >>> -#define C(i) get_cpu_gdt_table(cpu)[GDT_ENTRY_TLS_MIN + i] = t->tls_array[i]
> >>> -	C(0); C(1); C(2);
> >>> -#undef C
> >>> +	get_cpu_gdt_table(cpu)[GDT_ENTRY_TLS_MIN + 0] = t->tls_array[0];
> >>> +	get_cpu_gdt_table(cpu)[GDT_ENTRY_TLS_MIN + 1] = t->tls_array[1];
> >>> +	get_cpu_gdt_table(cpu)[GDT_ENTRY_TLS_MIN + 2] = t->tls_array[2];
> >>>  }
> >>>       
> >> this is a cleanup unrelated to the purpose of the patch.
> >>     
> >
> > Sure, will split out.
> >   
> 
> Already done in Rusty's cleanup patch.

Hmm, not here, I'll fix it up.

thanks,
-chris
