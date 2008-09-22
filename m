Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbYIVJwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbYIVJwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 05:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYIVJvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 05:51:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:62538 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbYIVJvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 05:51:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kcZj5OMZPfiIZa4dIl2z1o3RLMULe2MivQq7L2VZbF3a9YPmN6jLH33snYwSrX8m73
         Re5P4U5NW4gEnsu16eHdJM0FgiKVUMoPP2hpQnhPsrTQua6FQFrWu60e9xmNfLAD7qum
         x9bNLWKFUrxPTDkMcqNVu5QAnNtjayWannySE=
Date: Mon, 22 Sep 2008 13:51:48 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: do_boot_cpu - add check if we have ESR register
Message-ID: <20080922095148.GD7663@localhost>
References: <20080922093603.GC7663@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922093603.GC7663@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Mon, Sep 22, 2008 at 01:36:03PM +0400]
| We should touch ESR register if only we have one.
| Check its presence first.
| 
| Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| CC: Yinghai Lu <yhlu.kernel@gmail.com>
| ---
| 
| Index: linux-2.6.git/arch/x86/kernel/smpboot.c
| ===================================================================
| --- linux-2.6.git.orig/arch/x86/kernel/smpboot.c	2008-09-18 19:17:16.000000000 +0400
| +++ linux-2.6.git/arch/x86/kernel/smpboot.c	2008-09-22 13:30:36.000000000 +0400
| @@ -893,8 +893,10 @@ do_rest:
|  		/*
|  		 * Be paranoid about clearing APIC errors.
|  	 	*/
| -		apic_write(APIC_ESR, 0);
| -		apic_read(APIC_ESR);
| +		if (APIC_INTEGRATED(apic_version[phys_apicid])) {
| +			apic_write(APIC_ESR, 0);
| +			apic_read(APIC_ESR);
| +		}
|  	}
|  
|  	/*

Actually it's resend of the patch. On previous attempt
Yinghai was proposed to choose:

> one apic_version or boot_cpu_apic_version could be enough

but I think it should be different patch which does cleaning
up variables usage. So for now I think _this_ patch is enough
since idea is to prevent of touching nonexistant register rather
code cleaning (whci could be done later).

Yinghai?

		- Cyrill -
