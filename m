Return-Path: <linux-kernel-owner+w=401wt.eu-S1751363AbZHSAOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbZHSAOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 20:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbZHSAOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 20:14:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZHSAOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 20:14:33 -0400
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
In-Reply-To: James Bottomley's message of  Tuesday, 18 August 2009 19:09:24 -0500 <1250640565.15079.3.camel@mulgrave.site>
References: <4A89CC4D.5040801@gmx.de>
	<1250549376.7858.96.camel@mulgrave.site>
	<200908181248.52572.rusty@rustcorp.com.au>
	<20090818050637.4C3E74730F@magilla.sf.frob.com>
	<1250640565.15079.3.camel@mulgrave.site>
Emacs: it's like swatting a fly with a supernova.
Message-Id: <20090819001424.4C1144730F@magilla.sf.frob.com>
Date: Tue, 18 Aug 2009 17:14:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, for parisc, its not reasonable.  It's expected that our modules
> have multiple text sections (we have to use -ffunction-sections to
> generate them in order that the PCREL17 jump stubs can be interleaved).

I don't think you need what you think you need.  Having lots of sections in
your .o's when you compile is fine.  These should be combined by the linker
script that creates the .ko, however.  Unless I am missing something, there
is no purpose to this section distinction at insmod time--it's only
important for the relative layout of the parts of the .ko's text, which
winds up contiguous whether laid out that way at ld -r (.ko creation) time
or at insmod time.

> Even with the duplicate name, though, the module should be perfectly
> loadable.

But its /sys/module/foo/sections/ virtual directory becomes useless,
as a single name space can no longer describe what sections it has.
So perhaps it is then proper for add_sect_attrs() to punt on it.
But that reduces the functionality you get from CONFIG_KALLSYMS.


Thanks,
Roland
