Return-Path: <linux-kernel-owner+w=401wt.eu-S965021AbXIGGuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965021AbXIGGuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 02:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932737AbXIGGtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 02:49:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36364 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932736AbXIGGty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 02:49:54 -0400
Date: Fri, 7 Sep 2007 08:49:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 3/8] Immediate Values - Kconfig menu in EMBEDDED
Message-ID: <20070907064908.GG31880@one.firstfloor.org>
References: <20070906200228.086651361@polymtl.ca> <20070906200314.692565803@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070906200314.692565803@polymtl.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +config IMMEDIATE
> +	default y if !DISABLE_IMMEDIATE

It's still unclear to me why DISABLE_IMMEDIATE is needed. It would
be better to make it just the default.

> +config DISABLE_IMMEDIATE
> +	default y if EMBEDDED
> +	bool "Disable immediate values" if EMBEDDED
> +	depends on X86_32 || PPC || PPC64
> +	help
> +	  Disable code patching based immediate values for embedded systems. It
> +	  consumes slightly more memory and requires to modify the instruction
> +	  stream each time a variable is updated. 

>         Should really be disabled for
> +	  embedded systems with read-only text.

There are no such on x86 at least  And for other architectures like
PPC it would be better to have a high level CONFIG_READ_ONLY_TEXT
then that does the necessary changes internally.  But I'm not sure it's even 
supporting r/o text.

-Andi
