Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbZI2Xjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbZI2Xjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 19:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbZI2Xjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 19:39:35 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47216 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbZI2Xje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 19:39:34 -0400
Subject: Re: linux-next: tree build failure
From: Hollis Blanchard <hollisb@us.ibm.com>
To: Jan Beulich <jbeulich@novell.com>
Cc: sfr@canb.auug.org.au, akpm@linux-foundation.org,
       linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
In-Reply-To: <4AC1E15502000078000516B5@vpn.id2.novell.com>
References: <4AC1E15502000078000516B5@vpn.id2.novell.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Tue, 29 Sep 2009 16:39:32 -0700
Message-Id: <1254267572.15622.1621.camel@slab.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-29 at 10:28 +0100, Jan Beulich wrote:
> >>> Hollis Blanchard  09/29/09 2:00 AM >>>
> >First, I think there is a real bug here, and the code should read like
> >this (to match the comment):
> >    /* type has to be known at build time for optimization */
> >-    BUILD_BUG_ON(__builtin_constant_p(type));
> >+    BUILD_BUG_ON(!__builtin_constant_p(type));
> >
> >However, I get the same build error *both* ways, i.e.
> >__builtin_constant_p(type) evaluates to both 0 and 1? Either that, or
> >the new BUILD_BUG_ON() macro isn't working...
> 
> No, at this point of the compilation process it's neither zero nor one,
> it's simply considered non-constant by the compiler at that stage
> (this builtin is used for optimization, not during parsing, and the
> error gets generated when the body of the function gets parsed,
> not when code gets generated from it).

I think I see what you're saying. Do you have a fix to suggest?

-- 
Hollis Blanchard
IBM Linux Technology Center

