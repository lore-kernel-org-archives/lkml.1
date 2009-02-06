Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbZBFP5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbZBFP5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbZBFP5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:57:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60787 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZBFP5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:57:09 -0500
Date: Fri, 6 Feb 2009 16:56:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>, hskinnemoen@atmel.com,
       cooloney@kernel.org, ralf@linux-mips.org, dhowells@redhat.com,
       matthew@wil.cx, chris@zankel.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull -tip] headers_check fixes for other architectures
Message-ID: <20090206155624.GR18368@elte.hu>
References: <alpine.LFD.2.00.0902051101040.3247@localhost.localdomain> <20090205191907.GA27422@elte.hu> <1233886017.3463.26.camel@localhost.localdomain> <20090206022025.GA8317@elte.hu> <1233929922.3209.6.camel@localhost.localdomain> <20090206142134.GA13758@n2100.arm.linux.org.uk> <1233930860.3209.13.camel@localhost.localdomain> <20090206145119.GB13758@n2100.arm.linux.org.uk> <1233932407.3209.18.camel@localhost.localdomain> <20090206151027.GC13758@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206151027.GC13758@n2100.arm.linux.org.uk>
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


* Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> Taking this further, if you're including linux/types.h into another
> header file, you're including it because you want some C type from
> that or an included file.  Use of that type is also not ASM friendly,
> so the use is going to have to be excluded by ifndef in that header.

There's a ton of header files that can be included in assembly code and 
which also contain C declarations and definitions. This is achieved by 
adding a:

 #ifndef __ASSEMBLY__
 #endif

Blocks around the C code. Especially for smallish or single-purpose files 
this is often a cleaner method than splitting the file.

There's more than 40 such headers on x86 alone.

	Ingo
