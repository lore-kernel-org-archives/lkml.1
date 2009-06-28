Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbZF1Pu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbZF1Pu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 11:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbZF1PuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 11:50:19 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:33964 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbZF1PuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 11:50:19 -0400
Date: Sun, 28 Jun 2009 19:50:13 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, max@stro.at,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: Re: [PATCH] alpha: fix percpu build breakage
Message-ID: <20090628155011.GA12726@jurassic.park.msu.ru>
References: <20090625090842.GA17936@stro.at> <20090625115423.6a31b49c.akpm@linux-foundation.org> <4A4419AA.2040400@kernel.org> <20090626124705.GA25147@jurassic.park.msu.ru> <20090626115746.09314757.akpm@linux-foundation.org> <20090626122152.e124254b.akpm@linux-foundation.org> <4A46BE34.7040806@kernel.org> <20090628113940.GA11836@jurassic.park.msu.ru> <4A47603D.40205@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A47603D.40205@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 09:21:17PM +0900, Tejun Heo wrote:
> Oh... the newest incarnation looks like the following.
> 
> #if defined(ARCH_NEEDS_WEAK_PER_CPU) || defined(CONFIG_DEBUG_FORCE_WEAK_PER_CPU)
> #define DECLARE_PER_CPU_SECTION(type, name, sec)			\
> 	extern __PCPU_DUMMY_ATTRS char __pcpu_scope_##name;		\
> 	extern __PCPU_ATTRS(sec) __weak __typeof__(type) per_cpu__##name
> 
> #define DEFINE_PER_CPU_SECTION(type, name, sec)				\
> 	__PCPU_DUMMY_ATTRS char __pcpu_scope_##name;			\
> 	__PCPU_DUMMY_ATTRS char __pcpu_unique_##name;			\
> 	__PCPU_ATTRS(sec) __weak __typeof__(type) per_cpu__##name
> #else
> #define DECLARE_PER_CPU_SECTION(type, name, sec)			\
> 	extern __PCPU_ATTRS(sec) __typeof__(type) per_cpu__##name
> 
> #define DEFINE_PER_CPU_SECTION(type, name, sec)				\
> 	__PCPU_ATTRS(sec) __typeof__(type) per_cpu__##name
> #endif
> 
> So, I can simply drop __weak from the declaration like the following.
> Looks good?

Yeah, thanks, Tejun.

Ivan.
