Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbYLSKpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbYLSKpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 05:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYLSKpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 05:45:03 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:35569 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752506AbYLSKpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 05:45:01 -0500
Subject: Re: [PATCH 03/15] kmemleak: Add the slab memory allocation/freeing
	hooks
From: Catalin Marinas <catalin.marinas@arm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0812181541140.19680@quilx.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182710.30323.57396.stgit@pc1117.cambridge.arm.com>
	 <494184AA.8090509@cs.helsinki.fi>
	 <1229092065.15045.35.camel@pc1117.cambridge.arm.com>
	 <1229597162.1047.48.camel@penberg-laptop>
	 <1229618308.16418.50.camel@pc1117.cambridge.arm.com>
	 <Pine.LNX.4.64.0812181048160.12300@quilx.com>
	 <1229619764.16418.54.camel@pc1117.cambridge.arm.com>
	 <Pine.LNX.4.64.0812181334590.17255@quilx.com>
	 <84144f020812181206o3d85fbd3t6b30346d7cf76d9d@mail.gmail.com>
	 <Pine.LNX.4.64.0812181541140.19680@quilx.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 19 Dec 2008 10:44:49 +0000
Message-Id: <1229683489.23599.3.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Dec 2008 10:44:50.0849 (UTC) FILETIME=[D1D38910:01C961C6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-18 at 15:41 -0600, Christoph Lameter wrote:
> On Thu, 18 Dec 2008, Pekka Enberg wrote:
> 
> > For kmemleak, that's a problem. Unless we explicitly annotate the
> > caches, it will scan them and think that there's a pointer to a leaked
> > object (i.e. false negative). Catalin already took care of the per-CPU
> > caches but AFAICT we still need to take care of the per-node caches
> > and the shared caches.
> 
> Why doesnt kmemleak simply use the counter as a boundary and only access
> those pointers that are valid?

Since the valid pointers in these caches only point to freed objects
(which aren't tracked by kmemleak), it's better for kmemleak not to scan
such structures at all. I added a kmemleak_no_scan() annotation for
this.

Thanks for clarification.

-- 
Catalin

