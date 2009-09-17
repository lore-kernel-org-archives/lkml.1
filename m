Return-Path: <linux-kernel-owner+w=401wt.eu-S1751678AbZIQK3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbZIQK3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 06:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbZIQK3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 06:29:23 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33811 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbZIQK3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 06:29:22 -0400
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, heiko.carstens@de.ibm.com, mingo@elte.hu,
       npiggin@suse.de, sachinp@in.ibm.com
In-Reply-To: <20090917100841.GF13002@csn.ul.ie>
References: <1253083059.5478.1.camel@penberg-laptop>
	 <20090917100841.GF13002@csn.ul.ie>
Date: Thu, 17 Sep 2009 13:29:24 +0300
Message-Id: <1253183365.4975.20.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Wed, Sep 16, 2009 at 09:37:39AM +0300, Pekka Enberg wrote:
> > The SLQB allocator is known to be broken on certain PowerPC and S390
> > configurations. Disable the allocator in Kconfig for those architectures
> > until the issues are resolved. 
> 
> Can the issues be summarised?

It's a boot time crash during module load:

http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg33092.html

AFAICT, it's related to a memoryless node 0. Nick suggested it could be
a latent bug in the kernel that's triggered by SLQB.

On Thu, 2009-09-17 at 11:08 +0100, Mel Gorman wrote:
> The danger is if SLQB is being silently disabled, it'll never be noticed
> or debugged :/

Maybe, but that's not an excuse to push something that's known to break.

The other alternative is to skip this release cycle but I'm not sure
what we'd gain with that. Nick already stated in private that he'll try
to arrange for some time with ppc machines to debug the thing and we
hope to be able to fix it by 2.6.32 final.

Btw, the code is in slqb/core branch of slab.git in case someone wants
to take a stab at fixing the bug.

			Pekka

