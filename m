Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbZBBRxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbZBBRxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 12:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZBBRxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 12:53:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:22437 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbZBBRxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 12:53:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Amqx95UXXZL6pGSTR6sUEc5jmyzcJ+R92q4oheqVIVgQFGTtKDFENFPvh+k4L4TaAI
         F4hZK9COTcNJGIetuGAHfhi904ltW6AYu99h3bihaMXHKXOYHpq56YIqUC0HJhph5AwX
         h9LzYq6WbH4xBv5m8Wci7BtAV18QyvfXo6Q8s=
Date: Mon, 2 Feb 2009 20:53:12 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org
Subject: Re: [git-pull -tip] fix headers_check warnings
Message-ID: <20090202175312.GB7479@localhost>
References: <1233593765.3244.14.camel@localhost.localdomain> <20090202172159.GA7479@localhost> <1233595855.28370.1.camel@localhost.localdomain> <4987321A.1020404@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4987321A.1020404@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Mon, Feb 02, 2009 at 09:49:14AM -0800]
| Jaswinder Singh Rajput wrote:
| >>
| >> Hi Jaswinder,
| >>
| >> it seems we have a clash here :) I thought this part
| >> was just dropped out
| >>
| >> 	http://lkml.org/lkml/2009/1/14/461
| >>
| >> and Peter had been applying it on tip:x86/header-fixes
| >>
| >> 	http://lkml.org/lkml/2009/1/14/549
| >>
| >> but maybe it's just lost...
| > 
| > No, you cannot remove sys_arch_prctl otherwise you will get sparse
| > warning like this:
| > 
| >   CHECK   arch/x86/kernel/process_64.c
| > arch/x86/kernel/process_64.c:833:6: warning: symbol 'sys_arch_prctl' was not declared. Should it be static?
| > 
| 
| Perhaps we can just move this prototype to <asm/syscalls.h>.
| 
| 	-hpa
| 
| -- 
| H. Peter Anvin, Intel Open Source Technology Center
| I work for Intel.  I don't speak on their behalf.
| 

Hmm...

For internal use we refer to do_arch_prctl and
sys_arch_prctl supposed to be syscall wrapper.

Yes, Peter, you're right! It seems this call
was missed there.

		-Cyrill-
