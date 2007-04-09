Return-Path: <linux-kernel-owner+w=401wt.eu-S1751052AbXDIWBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751052AbXDIWBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 18:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbXDIWBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 18:01:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44312 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751052AbXDIWBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 18:01:22 -0400
Date: Mon, 9 Apr 2007 15:01:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mm@kvack.org, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 3/4] Quicklist support for x86_64
In-Reply-To: <20070409142852.40da5add.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704091500060.2761@schroedinger.engr.sgi.com>
References: <20070409182509.8559.33823.sendpatchset@schroedinger.engr.sgi.com>
 <20070409182520.8559.33529.sendpatchset@schroedinger.engr.sgi.com>
 <20070409142852.40da5add.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2007, Andrew Morton wrote:

> On Mon,  9 Apr 2007 11:25:20 -0700 (PDT)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> > -static inline pgd_t *pgd_alloc(struct mm_struct *mm)
> > +static inline void pgd_ctor(void *x)
> > +static inline void pgd_dtor(void *x)
> 
> Seems dumb to inline these - they're only ever called indirectly, aren't
> they?

Yes.. In most cases they are not called at all because NULL is passed. 
Then the function call can be removed by the compiler from the in line 
functions.

> This means (I think) that the compiler will need to generate an out-of-line
> copy of these within each compilation unit which passes the address of these
> functions into some other function.

The function is constant. Constant propagation will lead to the function 
being included in the inline function.
