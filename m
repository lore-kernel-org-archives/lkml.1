Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbYFALXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbYFALXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 07:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYFALXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 07:23:46 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:42045 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750934AbYFALXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 07:23:46 -0400
Date: Sun, 1 Jun 2008 20:21:37 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Howells <dhowells@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       akpm@linux-foundation.org, mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
Message-ID: <20080601112137.GE25429@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	David Howells <dhowells@redhat.com>,
	Christoph Lameter <clameter@sgi.com>,
	LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
	akpm@linux-foundation.org, mpm@selenic.com
References: <483DBFC3.1070108@cs.helsinki.fi> <29611.1212066517@redhat.com> <Pine.LNX.4.64.0805291620250.5415@sbz-30.cs.helsinki.fi> <20080529211207.GB13663@linux-sh.org> <484256AA.3000709@cs.helsinki.fi> <Pine.LNX.4.64.0806011119420.11749@sbz-30.cs.Helsinki.FI> <20080601082427.GC25429@linux-sh.org> <Pine.LNX.4.64.0806011208480.13090@sbz-30.cs.Helsinki.FI> <20080601102401.GD25429@linux-sh.org> <48427A13.7050704@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48427A13.7050704@cs.helsinki.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 01:29:39PM +0300, Pekka Enberg wrote:
> On Sun, Jun 01, 2008 at 12:13:02PM +0300, Pekka J Enberg wrote:
> >>I mean, assuming the BUG_ON bits are bogus, then we should always pass 
> >>the pointer to the allocator. I audited most of the callers and they all 
> >>seem to be really just using kmalloc() for allocation anyway.
> >>
> >>What do you think?
> 
> Paul Mundt wrote:
> >Isn't this what my original patch did? ;-)
> 
> Oh, almost, you had this bit in ksize() of SLAB:
> 
> +	page = virt_to_head_page(objp);
> +	if (unlikely(!PageSlab(page)))
> +		return PAGE_SIZE << compound_order(page);
> 
> Did you actually need it for something?
> 
Not that I recall, it was just for consistency with SLUB. I'll have to
re-test though, as I'm not sure if it was necessary or not.
