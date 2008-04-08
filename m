Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYDHOy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYDHOy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 10:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYDHOyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 10:54:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752527AbYDHOyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:54:11 -0400
Date: Tue, 8 Apr 2008 07:53:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] set_restore_sigmask TIF_SIGPENDING
In-Reply-To: <20080408113519.GA227@tv-sign.ru>
Message-ID: <alpine.LFD.1.00.0804080748320.2886@woody.linux-foundation.org>
References: <20080329001230.D013726FA1D@magilla.localdomain> <20080329001341.7F93826FA1D@magilla.localdomain> <alpine.LFD.1.00.0803281746480.14670@woody.linux-foundation.org> <20080408113519.GA227@tv-sign.ru>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Apr 2008, Oleg Nesterov wrote:
> 
> We only need this flag as an implicit parameter to the arch dependent do_signal()
> which we can't call directly, and thus it must imply TIF_SIGPENDING, and it
> is not valid after do_signal() (should be cleared). This all looks like
> ERESTART_ magic, why should we add something else ?

I think you're right. I didn't look at the actual code-paths, but my gut 
feel says "yes, TIF_RESTORE_SIGMASK should actually have been 
-ERESTARTSIGRESTORE". That sounds like the right thing to do.

		Linus
