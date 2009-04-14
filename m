Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbZDNQrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbZDNQrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbZDNQqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:46:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:47395 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbZDNQqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:46:49 -0400
Subject: Re: [PATCH -tip] x86: cpu/intel_cacheinfo.c fix compilation
 warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <20090414133242.GB27163@elte.hu>
References: <1239712990.3079.17.camel@ht.satnam>
	 <20090414133242.GB27163@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Apr 2009 22:16:21 +0530
Message-Id: <1239727581.2966.17.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 15:32 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > fix:
> >   arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘show_cache_disable’:
> >   arch/x86/kernel/cpu/intel_cacheinfo.c:712: warning: unused variable ‘node’
> >   arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘store_cache_disable’:
> >   arch/x86/kernel/cpu/intel_cacheinfo.c:739: warning: unused variable ‘node’
> 
> you again 'fixed' a warning.
> 
> this made you fail to analyze and miss the real reason for this for 
> example:
> 
> >   arch/x86/kernel/cpu/intel_cacheinfo.c:739: warning: unused variable ‘node’
> 
> > -	int node = cpu_to_node(cpu);
> 
> the local variable is clearly initialized.
> 
> The problem is not with that variable - the problem is most likely 
> with the cpu_to_node() macro not creating a reference to the 'cpu' 
> variable in a compiler-visible way, in the !NUMA case.
> 
> The typical way to solve this is to add a dummy:
> 
> 	(void)(cpu)
> 
> use to the 'cpu' parameter to the macro definition - or, (which is a 
> much better solution), to convert it to an inline function.
> 

OK send patch:
[PATCH -tip] x86: k8.h reference to node in node_to_k8_nb_misc for !CONFIG_K8_NB

Thanks,

--
JSR

