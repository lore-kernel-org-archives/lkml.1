Return-Path: <linux-kernel-owner+w=401wt.eu-S1751060AbZHSBbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751060AbZHSBbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 21:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbZHSBbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 21:31:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbZHSBbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 21:31:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
X-Fcc: ~/Mail/linus
Cc: Rusty Russell <rusty@rustcorp.com.au>, Helge Deller <deller@gmx.de>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kernel segv with 2.6.31-rc6 ?
In-Reply-To: James Bottomley's message of  Tuesday, 18 August 2009 18:54:21 -0600 <1250643261.18426.8.camel@mulgrave.site>
References: <4A89CC4D.5040801@gmx.de>
	<1250549376.7858.96.camel@mulgrave.site>
	<200908181248.52572.rusty@rustcorp.com.au>
	<20090818050637.4C3E74730F@magilla.sf.frob.com>
	<1250640565.15079.3.camel@mulgrave.site>
	<20090819001424.4C1144730F@magilla.sf.frob.com>
	<1250643261.18426.8.camel@mulgrave.site>
X-Zippy-Says: Awright, which one of you hid my PENIS ENVY?
Message-Id: <20090819013124.7539E4730F@magilla.sf.frob.com>
Date: Tue, 18 Aug 2009 18:31:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, I think we do; the module loader is a runtime linker, after
> all.  [...]

Indeed you do.  I've just read some of the parts of ld that normally
address this issue for HPPA.  They don't run for ld -r.  So this is just
another fine example of the lunacy of the ET_REL .ko madness that would be
naturally avoided by a sensible tweaked ET_DYN scheme.  But that battle was
lost way, way back in the long, long ago, so long ago they were probably
even still making HPPA machines then.

> Now, of course, if the final linker could be persuaded to sprinkle
> needed stubs through the text section and all we have to do is GOT
> relocations, we don't need all the jiggery-pokery ... but I'm told this
> can't be done.

Not with ld -r as it is today.  That's what ld does for you in proper final
links.  It looks to me like you might be able to enable some special mode
("finalish link" for -r) with a hack to HPPA ld to apply this stub-creation
logic based on the assumption that the symbols in the relocs will be
resolved to themselves, and barf on you if they're used for SHN_UNDEF symbols.
But nobody cares enough to fiddle with ld.


Thanks,
Roland
