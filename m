Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbZIPGzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbZIPGzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 02:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbZIPGzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 02:55:09 -0400
Received: from smtp-out.google.com ([216.239.33.17]:38459 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZIPGzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 02:55:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=EIjMh9dv0idvcy5BCnGTGUYuy16gf+2o6A0yOzBkdt17082z6EuduPMEHdkMPU6sH
	K9UNIxgmE2UnT4kEi254A==
Date: Tue, 15 Sep 2009 23:55:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, heiko.carstens@de.ibm.com, mingo@elte.hu,
       npiggin@suse.de, sachinp@in.ibm.com
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and
 S390
In-Reply-To: <1253083059.5478.1.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.00.0909152351510.13366@chino.kir.corp.google.com>
References: <1253083059.5478.1.camel@penberg-laptop>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, Pekka Enberg wrote:

> The SLQB allocator is known to be broken on certain PowerPC and S390
> configurations. Disable the allocator in Kconfig for those architectures
> until the issues are resolved.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Sachin Sant <sachinp@in.ibm.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  init/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index c0d8a47..aaeddeb 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1033,6 +1033,7 @@ config SLUB
>  
>  config SLQB
>  	bool "SLQB (Queued allocator)"
> +	depends on !PPC && !S390
>  	help
>  	  SLQB is a proposed new slab allocator.
>  

I think this should be (!PPC && !S390) || EXPERIMENTAL so that it can 
still be enabled for debugging and development.

Is this in preparation for slqb inclusion as a non-default slab allocator 
in 2.6.32?  2.6.33?
