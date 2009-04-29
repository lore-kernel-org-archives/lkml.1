Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbZD2Dx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbZD2Dx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 23:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZD2Dxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 23:53:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:34640 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbZD2Dxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 23:53:48 -0400
Subject: Re: [git-pull -tip] x86: cpu_debug patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20090428172828.GA15392@elte.hu>
References: <1240190145.3106.90.camel@ht.satnam>
	 <1240191359.3106.93.camel@ht.satnam> <1240217428.3083.2.camel@ht.satnam>
	 <20090420111619.GE6670@elte.hu> <1240933437.3074.4.camel@ht.satnam>
	 <20090428172828.GA15392@elte.hu>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 09:22:56 +0530
Message-Id: <1240977176.3028.0.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 19:28 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > @@ -850,10 +903,10 @@ static int cpu_init_cpu(void)
> >  		cpui = &cpu_data(cpu);
> >  		if (!cpu_has(cpui, X86_FEATURE_MSR))
> >  			continue;
> > -		per_cpu(cpu_model, cpu) = ((cpui->x86_vendor << 16) |
> > -					   (cpui->x86 << 8) |
> > -					   (cpui->x86_model));
> > -		per_cpu(cpu_modelflag, cpu) = get_cpu_modelflag(cpu);
> > +		per_cpu(cpu_modelflag, cpu) = get_cpu_flag(cpui);
> > +		if (!per_cpu(cpu_modelflag, cpu))
> > +			send_report(per_cpu(cpu_priv_count, cpu), cpui);
> 
> This means that if the CPU is not enumerated in the model table 
> explicitly, we'll fall back to some really minimal output, right?
> 

Yes.
--
JSR

