Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbXL2Bzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbXL2Bzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbXL2Bzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:55:48 -0500
Received: from mail.suse.de ([195.135.220.2]:47921 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007AbXL2Bzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:55:47 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 05/10] x86_64: Use generic percpu
Date: Sat, 29 Dec 2007 02:55:39 +0100
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       tglx@linutronix.de, mingo@redhat.com
References: <20071228001046.854702000@sgi.com> <200712281354.52453.ak@suse.de> <47757311.5050503@sgi.com>
In-Reply-To: <47757311.5050503@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712290255.40233.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 December 2007 23:05:05 Mike Travis wrote:
> Andi Kleen wrote:
> > On Friday 28 December 2007 01:10:51 travis@sgi.com wrote:
> >> x86_64 provides an optimized way to determine the local per cpu area
> >> offset through the pda and determines the base by accessing a remote
> >> pda.
> >
> > And? The rationale for this patch seems to be incomplete.
> >
> > As far as I can figure out you're replacing an optimized percpu
> > implementation which a dumber generic one. Which needs
> > at least some description why.
> 
> The specific intent for the next wave of changes coming are to reduce
[...] That should be in the changelog of the patch.

Anyways the difference between the x86 percpu.h and the generic one is
that x86-64 uses a short cut through the PDA to get the current cpu
offset for the current CPU case. The generic one goes through 
smp_processor_id()->array reference instead. 

I would request that this optimization is not being removed
without suitable replacement in the same patchkit.

-Andi
