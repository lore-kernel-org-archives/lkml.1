Return-Path: <linux-kernel-owner+w=401wt.eu-S932700AbXCPJ0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700AbXCPJ0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 05:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932702AbXCPJ0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 05:26:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47415 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932700AbXCPJ0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 05:26:18 -0400
Date: Fri, 16 Mar 2007 10:24:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops callsites to make them patchable
Message-ID: <20070316092445.GM23174@elte.hu>
References: <20070301232443.195603797@goop.org> <20070301232527.956565107@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301232527.956565107@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Wrap a set of interesting paravirt_ops calls in a wrapper which makes 
> the callsites available for patching.  Unfortunately this is pretty 
> ugly because there's no way to get gcc to generate a function call, 
> but also wrap just the callsite itself with the necessary labels.
> 
> This patch supports functions with 0-4 arguments, and either void or 
> returning a value.  64-bit arguments must be split into a pair of 
> 32-bit arguments (lower word first).  Small structures are returned in 
> registers.

ugh. This is beyond ugly! Why dont we just compile two images, one for 
Xen and one for native, do two passes to get those two images and 
'merge' them into a single vmlinuz (so that we still have a 'single' 
kernel unit to deal with on the distro side). This way we avoid all this 
crazy, limited, fragile patchery business...

	Ingo
