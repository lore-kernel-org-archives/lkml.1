Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbYKXKoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbYKXKoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 05:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbYKXKn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 05:43:58 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:38423 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704AbYKXKn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 05:43:57 -0500
Subject: Re: [PATCH 2.6.28-rc5 03/11] kmemleak: Add the memory
	allocation/freeing hooks
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <1227522906.3718.103.camel@penberg-laptop>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
	 <20081120113045.16607.7462.stgit@pc1117.cambridge.arm.com>
	 <84144f020811201130y2de91d03q7e6557e4086147ad@mail.gmail.com>
	 <1227265627.7015.7.camel@pc1117.cambridge.arm.com>
	 <1227514753.3718.21.camel@penberg-laptop>
	 <1227521925.8377.37.camel@pc1117.cambridge.arm.com>
	 <1227522906.3718.103.camel@penberg-laptop>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 24 Nov 2008 10:43:43 +0000
Message-Id: <1227523423.8377.39.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Nov 2008 10:43:44.0425 (UTC) FILETIME=[85E84990:01C94E21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 12:35 +0200, Pekka Enberg wrote:
> On Mon, 2008-11-24 at 10:18 +0000, Catalin Marinas wrote:
> > My understanding is that the ->s_mem value points to the slab itself but
> > the same pointer might actually be the beginning of an allocated memory
> > block, hence we get at least one reference to this block.
> 
> Yes, ->s_mem points to the first object in the slab if CONFIG_DEBUG_SLAB
> is disabled.
> 
> So if I understood this right, in case the first object in the slab is
> leaked (it's allocated but no one references to it), we want to make
> sure kmemleak doesn't see the ->s_mem link which would cause a false
> negative (i.e. a leak that is not reported).
> 
> Did I get it correct this time?

Yes.

-- 
Catalin

