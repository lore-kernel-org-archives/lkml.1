Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbYACEu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbYACEu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 23:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbYACEuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 23:50:15 -0500
Received: from lixom.net ([66.141.50.11]:57497 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393AbYACEuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 23:50:14 -0500
Date: Wed, 2 Jan 2008 22:58:39 -0600
From: Olof Johansson <olof@lixom.net>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] move WARN_ON() out of line
Message-ID: <20080103045838.GA25642@lixom.net>
References: <477C32DA.5060905@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477C32DA.5060905@linux.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 01:56:58AM +0100, Arjan van de Ven wrote:
> Subject: move WARN_ON() out of line
> From: Arjan van de Ven <arjan@linux.intel.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Andrew Morton <akpm@linux-foundation.org>
>
> A quick grep shows that there are currently 1145 instances of WARN_ON
> in the kernel. Currently, WARN_ON is pretty much entirely inlined,
> which makes it hard to enhance it without growing the size of the kernel
> (and getting Andrew unhappy).
>
> This patch moves WARN_ON() out of line entirely. I've considered keeping
> the test inline and moving only the slowpath out of line, but I decided
> against that: an out of line test reduces the pressure on the CPUs
> branch predictor logic and gives smaller code, while a function call
> to a fixed location is quite fast. Likewise I've considered doing something
> similar to BUG() (eg use a trapping instruction) but that's not really
> better (it needs the test inline again and recovering from an invalid
> instruction isn't quite fun).

Hi Arjan,

I've got a couple of patches in -mm at the moment that introduces __WARN()
and uses that (and lets architectures override __WARN, since for example
powerpc does use trapping instructions similarly to BUG()).

The two patches in question are:

bugh-remove-have_arch_bug--have_arch_warn.patch
powerpc-switch-to-generic-warn_on-bug_on.patch

Care to do this incrementally on top of that instead? I.e. call
do_warn_on() from the asm-generic/bug.h __WARN() instead.


-Olof

