Return-Path: <linux-kernel-owner+w=401wt.eu-S932322AbXCGL4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbXCGL4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 06:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932403AbXCGL4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 06:56:51 -0500
Received: from ozlabs.org ([203.10.76.45]:59184 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932322AbXCGL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 06:56:50 -0500
Subject: Re: [PATCH 8/8] Convert PDA into the percpu section
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@suse.de>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1173227582.4644.74.camel@localhost.localdomain>
References: <1173184747.4644.23.camel@localhost.localdomain>
	 <1173185592.4644.28.camel@localhost.localdomain>
	 <1173185666.4644.30.camel@localhost.localdomain>
	 <1173185734.4644.32.camel@localhost.localdomain>
	 <1173185827.4644.34.camel@localhost.localdomain>
	 <1173185909.4644.36.camel@localhost.localdomain>
	 <1173186021.4644.38.camel@localhost.localdomain>
	 <1173186107.4644.41.camel@localhost.localdomain>
	 <1173186214.4644.44.camel@localhost.localdomain>
	 <20070306193445.GI22829@bingen.suse.de>
	 <1173227582.4644.74.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 22:55:50 +1100
Message-Id: <1173268550.32234.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 11:33 +1100, Rusty Russell wrote:
> On Tue, 2007-03-06 at 20:34 +0100, Andi Kleen wrote:
> > Do you have text size comparisons before/after and possible lmbench? 
> 
> No, but I'll run them this evening.  Last time the size reduction was
> slight, and there was no measurable performance improvement in
> microbenchmarks.

Here are the size results, for a start:


UP:
Before:
size vmlinux
   text    data     bss     dec     hex filename
3094881  243110  221184 3559175  364f07 vmlinux

After:
size vmlinux 
   text    data     bss     dec     hex filename
3093409  243142  221184 3557735  364967 vmlinux

SMP:
Before:
size vmlinux
   text    data     bss     dec     hex filename
3222269  318770  237568 3778607  39a82f vmlinux

After:
size vmlinux
   text    data     bss     dec     hex filename
3221421  314674  237568 3773663  3994df vmlinux

(The data size changes are moving from pda -> percpu, and on SMP
removing the page-aligned PDA).

So, a slight win.  lmbench tomorrow...

Rusty.

