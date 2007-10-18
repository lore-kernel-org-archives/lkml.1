Return-Path: <linux-kernel-owner+w=401wt.eu-S1763415AbXJRV5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763415AbXJRV5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 17:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbXJRV44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 17:56:56 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:50882 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979AbXJRV4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 17:56:55 -0400
Date: Thu, 18 Oct 2007 23:58:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Bernhard Walle <bwalle@suse.de>,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       vgoyal@in.ibm.com
Subject: Re: [patch 1/3] Add BSS to resource tree
Message-ID: <20071018215827.GB23708@uranus.ravnborg.org>
References: <20071018111535.356215664@strauss.suse.de> <20071018111535.883533731@strauss.suse.de> <20071018142642.5b3f6ba4.akpm@linux-foundation.org> <20071018214836.GA3459@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018214836.GA3459@bingen.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 11:48:37PM +0200, Andi Kleen wrote:
> > > +extern char _text[], _end[], _etext[], _edata[], _bss[];
> > 
> > These should be in a header file.
> 
> Normally the "no externs in .c" rule doesn't apply to assembler or linker 
> script defined labels. That's because the point of the header file is to 
> type check them, but there is nothing to type check here.

For linker generated symbols we have sections.h for this purpose.
The above symbols are all available if we do an:
#include <asm/sections.h>

This is the right fix in this case.

	Sam
