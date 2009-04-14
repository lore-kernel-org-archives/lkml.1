Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbZDNRCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbZDNRCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbZDNRBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:01:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:50885 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbZDNRBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:01:52 -0400
Subject: Re: [PATCH -tip] x86: cpu_debug.c prepare report if files are
 inappropriate or CPU is not supported
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090414165052.GA2089@elte.hu>
References: <1239725240.2966.4.camel@ht.satnam>
	 <20090414165052.GA2089@elte.hu>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 22:31:21 +0530
Message-Id: <1239728481.2966.21.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 18:50 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > +		if (!per_cpu(cpu_modelflag, cpu))
> 
> hm, on a second look - the whole cpu_model / cpu_modelflag 
> business in arch/x86/kernel/cpu/cpu_debug.c looks 
> over-complicated and broken. You encode it into a 
> 'modelflag':
> 
>                 per_cpu(cpu_model, cpu) = ((cpui->x86_vendor << 16) |
>                                            (cpui->x86 << 8) |
>                                            (cpui->x86_model));
> 
> just to decode it later on:
> 
>         flag = per_cpu(cpu_model, cpu);
> 
>         switch (flag >> 16) {
> 
> That does not make much sense. Please use a proper 
> boot_cpu_data.x86_vendor switch() statement, ok?
> 

I am using flags for each cpu, in case there are different CPU in the
sockets:

struct cpuinfo_x86 *cpui;
cpui = &cpu_data(cpu);

Do you still think that boot_cpu_data.x86_vendor is better option in
case for multiple CPUs.

--
JSR

