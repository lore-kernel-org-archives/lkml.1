Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbXFYWfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbXFYWfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 18:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbXFYWey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 18:34:54 -0400
Received: from ns1.suse.de ([195.135.220.2]:42288 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112AbXFYWex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 18:34:53 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH] MTRR: Fix race causing set_mtrr to go into infinite loop
Date: Tue, 26 Jun 2007 00:34:41 +0200
User-Agent: KMail/1.9.6
Cc: Loic Prylli <loic@myri.com>, linux-kernel@vger.kernel.org
References: <468035BC.9080008@myri.com> <46803C1D.2040009@redhat.com>
In-Reply-To: <46803C1D.2040009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706260034.41940.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 June 2007 00:05:17 Chuck Ebbert wrote:
> On 06/25/2007 05:38 PM, Loic Prylli wrote:
> 
> [cc: Andi]
> 
> > Processors synchronization in set_mtrr requires the .gate field
> > to be set after .count field is properly initialized. Without an explicit
> > barrier, the compiler was reordering those memory stores. That was sometimes
> > causing a processor (in ipi_handler) to see the .gate change and
> > decrement .count before the latter is set by set_mtrr() (which
> > then hangs in a infinite loop with irqs disabled).

Hmm, perhaps we should just put the smp_wmb into atomic_set().
Near all other atomic operations have memory barriers too. I think
that would be the better fix.

-Andi
