Return-Path: <linux-kernel-owner+w=401wt.eu-S1751557AbZHRFGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbZHRFGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 01:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZHRFGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 01:06:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbZHRFGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 01:06:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
X-Fcc: ~/Mail/linus
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Helge Deller <deller@gmx.de>,
       "linux-parisc" <linux-parisc@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: kernel segv with 2.6.31-rc6 ?
In-Reply-To: Rusty Russell's message of  Tuesday, 18 August 2009 12:48:52 +0930 <200908181248.52572.rusty@rustcorp.com.au>
References: <4A89CC4D.5040801@gmx.de>
	<1250549376.7858.96.camel@mulgrave.site>
	<200908181248.52572.rusty@rustcorp.com.au>
X-Shopping-List: (1) Odious honey ink
   (2) Diagnostic incoherent contributions
   (3) Androgynous sandwiches
Message-Id: <20090818050637.4C3E74730F@magilla.sf.frob.com>
Date: Mon, 17 Aug 2009 22:06:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd be happy to fail to load it.  There might be sysfs issues with it too.

That sounds reasonable to me.  And I'd be happy to at least look a little
and maybe give some advice to anybody who finds themself building such a
(free) module, doesn't know why or how it got that way, and wants to ask.

> No, the real problem is that it ignores failure.  I'd much rather fail
> the module load than various features mysteriously MIA.

In that regard, I just made add_notes_attrs() follow the model of
add_sect_attrs(), which (gracefully) ignores all its failures.  I don't
know what the thought behind that was.  My only guess was that since this
is all CONFIG_KALLSYMS-only features, that someone thought turning on
CONFIG_KALLSYMS should not add new ways to lose that weren't there before,
only new ways to lose the new features that weren't there before either.
Having these other alloc/sysfs failures cause the module load to fail would
certainly be fine with me.


Thanks,
Roland
