Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbZDXXCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbZDXXCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 19:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZDXXCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 19:02:31 -0400
Received: from smtp-out.google.com ([216.239.45.13]:21520 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZDXXCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 19:02:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=GWSkFkHQ5oTJLNOqlgHhhNn7SeznODDHODfE1CkZS/jJIMeZJynHh/ITeqBNPh9Em
	EaFSOYB8Y21SLMyqKS4aQ==
Date: Fri, 24 Apr 2009 16:02:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Catalin Marinas <catalin.marinas@arm.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/14] kmemleak: Enable the building of the memory leak
 detector
In-Reply-To: <20090424164205.4476.9856.stgit@pc1117.cambridge.arm.com>
Message-ID: <alpine.DEB.2.00.0904241600400.8194@chino.kir.corp.google.com>
References: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com> <20090424164205.4476.9856.stgit@pc1117.cambridge.arm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009, Catalin Marinas wrote:

> This patch adds the Kconfig.debug and Makefile entries needed for
> building kmemleak into the kernel.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  lib/Kconfig.debug |   22 ++++++++++++++++++++++
>  mm/Makefile       |    1 +
>  2 files changed, 23 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index c6e854f..6c9d21f 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -336,6 +336,28 @@ config SLUB_STATS
>  	  out which slabs are relevant to a particular load.
>  	  Try running: slabinfo -DA
>  
> +config DEBUG_KMEMLEAK
> +	bool "Kernel memory leak detector"
> +	default n
> +	depends on EXPERIMENTAL && (X86 || ARM) && !MEMORY_HOTPLUG

This should include DEBUG_KERNEL.
