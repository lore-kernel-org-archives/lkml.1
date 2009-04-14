Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbZDNQxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbZDNQxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbZDNQwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:52:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41729 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbZDNQwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:52:53 -0400
Date: Tue, 14 Apr 2009 18:52:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Mark Langsdorf <mark.langsdorf@amd.com>
Subject: Re: [PATCH -tip] x86: k8.h reference to node in node_to_k8_nb_misc
	for !CONFIG_K8_NB
Message-ID: <20090414165241.GB2089@elte.hu>
References: <1239727500.2966.16.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1239727500.2966.16.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Add reference to node in node_to_k8_nb_misc for !CONFIG_K8_NB to make compiler happy.
> 
> So fixes compiler warnings:
>   arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘show_cache_disable’:
>   arch/x86/kernel/cpu/intel_cacheinfo.c:712: warning: unused variable ‘node’
>   arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘store_cache_disable’:
>   arch/x86/kernel/cpu/intel_cacheinfo.c:739: warning: unused variable ‘node’
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/include/asm/k8.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
> index c23b3d1..c81e4ee 100644
> --- a/arch/x86/include/asm/k8.h
> +++ b/arch/x86/include/asm/k8.h
> @@ -16,7 +16,7 @@ extern int k8_scan_nodes(unsigned long start, unsigned long end);
>  #define node_to_k8_nb_misc(node) \
>  	(node < num_k8_northbridges) ? k8_northbridges[node] : NULL
>  #else
> -#define node_to_k8_nb_misc(node) NULL
> +#define node_to_k8_nb_misc(node) (node) ? NULL : NULL
>  #endif

Ugh, that's very ugly. I gave you a proper solution:

>> The typical way to solve this is to add a dummy:
>> 
>> 	(void)(cpu)
>> 
>> use to the 'cpu' parameter to the macro definition - or, 
>> (which is a much better solution), to convert it to an 
>> inline function.

	Ingo
