Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbXJPF0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbXJPF0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 01:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbXJPF0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 01:26:04 -0400
Received: from smtp-out.google.com ([216.239.33.17]:63321 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbXJPF0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 01:26:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=cICXvzuU5TEYsRqFZ/BGLFgFf3VHEL5uBQi0n9cQRneAOEJaOe6COrqidZMKJOvA8
	WhvULp7msVBGPZfaE25ug==
Date: Mon, 15 Oct 2007 22:25:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matt Mackall <mpm@selenic.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 11/11] maps3: make page monitoring /proc file optional
In-Reply-To: <12.290135367@selenic.com>
Message-ID: <alpine.DEB.0.9999.0710152223400.13454@chino.kir.corp.google.com>
References: <12.290135367@selenic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Matt Mackall wrote:

> Index: l/init/Kconfig
> ===================================================================
> --- l.orig/init/Kconfig	2007-10-14 13:35:07.000000000 -0500
> +++ l/init/Kconfig	2007-10-15 17:18:16.000000000 -0500
> @@ -571,6 +571,15 @@ config SLOB
>  
>  endchoice
>  
> +config PROC_PAGE_MONITOR
> + 	default y
> +	bool "Enable /proc page monitoring" if EMBEDDED && PROC_FS && MMU
> + 	help
> +	  Various /proc files exist to monitor process memory utilization:
> +	  /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
> +	  /proc/kpagecount, and /proc/kpageflags. Disabling these
> +          interfaces will reduce the size of the kernel by approximately 4kb.
> +
>  endmenu		# General setup
>  
>  config RT_MUTEXES

It's probably better not to include the text size savings since it will 
most likely be outdated at some time in the future.
