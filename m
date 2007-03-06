Return-Path: <linux-kernel-owner+w=401wt.eu-S933988AbXCFHv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933988AbXCFHv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 02:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933990AbXCFHv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 02:51:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39649 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933988AbXCFHv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 02:51:26 -0500
Date: Tue, 6 Mar 2007 08:50:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zach@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] paravirt: VDSO page is essential
Message-ID: <20070306075057.GA6495@elte.hu>
References: <20070305120631.GA14105@elte.hu> <1173101297.26165.39.camel@localhost.localdomain> <1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <20070306073511.GA3938@elte.hu> <45ED1B64.9040104@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45ED1B64.9040104@vmware.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Zachary Amsden <zach@vmware.com> wrote:

> > yeah. (plus my patches of course that remove the current 
> > papering-over hackery and restores COMPAT_VDSO.)
> 
> Yes, I don't have a problem with your patch, I just wish I had been 
> cc'd on it. [...]

(i Cc:-ed you to the other ones - i simply forgot and bounced it to you 
a few hours down the line - sorry!)

> [...] Fixing this is rather tricky, but I believe no strange build 
> magic is required, it can be done in kernel init code.  Still building 
> my SUSE 9.0 guest to test.  SUSE 9.0 is one of those that requires 
> COMPAT_VDSO, yes?

yeah, and a handful of other ones. It depends on the glibc version: 
early vdso glibs were buggy and assumed a few things about the vdso, so 
they would segfault on the new-style vdso which is fully relocatable 
(and hence mergable into the vma space, randomizable, etc.).

	Ingo
