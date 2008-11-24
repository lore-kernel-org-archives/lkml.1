Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbYKXKdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbYKXKdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 05:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYKXKda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 05:33:30 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60541 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbYKXKd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 05:33:29 -0500
Subject: Re: [PATCH 2.6.28-rc5 03/11] kmemleak: Add the memory
	allocation/freeing hooks
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <1227521925.8377.37.camel@pc1117.cambridge.arm.com>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
	 <20081120113045.16607.7462.stgit@pc1117.cambridge.arm.com>
	 <84144f020811201130y2de91d03q7e6557e4086147ad@mail.gmail.com>
	 <1227265627.7015.7.camel@pc1117.cambridge.arm.com>
	 <1227514753.3718.21.camel@penberg-laptop>
	 <1227521925.8377.37.camel@pc1117.cambridge.arm.com>
Date: Mon, 24 Nov 2008 12:35:06 +0200
Message-Id: <1227522906.3718.103.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Mon, 2008-11-24 at 10:18 +0000, Catalin Marinas wrote:
> My understanding is that the ->s_mem value points to the slab itself but
> the same pointer might actually be the beginning of an allocated memory
> block, hence we get at least one reference to this block.

Yes, ->s_mem points to the first object in the slab if CONFIG_DEBUG_SLAB
is disabled.

So if I understood this right, in case the first object in the slab is
leaked (it's allocated but no one references to it), we want to make
sure kmemleak doesn't see the ->s_mem link which would cause a false
negative (i.e. a leak that is not reported).

Did I get it correct this time?

		Pekka

