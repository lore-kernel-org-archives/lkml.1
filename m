Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbZFZGyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbZFZGyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 02:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbZFZGyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 02:54:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43964 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbZFZGyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 02:54:22 -0400
Date: Fri, 26 Jun 2009 08:54:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Tejun Heo <tj@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       x86@kernel.org, linux-arch@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, cl@linux-foundation.org
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve lpage NUMA support
Message-ID: <20090626065423.GY6760@one.firstfloor.org>
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <20090625000202.GR6760@one.firstfloor.org> <4A42C131.6040007@zytor.com> <20090625091939.GS6760@one.firstfloor.org> <4A43871F.9030507@zytor.com> <20090625195408.GW6760@one.firstfloor.org> <4A43DAFD.90409@zytor.com> <20090625202642.GX6760@one.firstfloor.org> <4A4418EA.9000705@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4418EA.9000705@kernel.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 09:40:10AM +0900, Tejun Heo wrote:
> Andi Kleen wrote:
> >> I don't know why, but in the configuration I saw each percpu area was
> >> something like 1.8 MB.
> > 
> > That sounds like something that needs to be investigated and fixed then.
> > In a sense per cpu space is precious like stack space and shouldn't 
> > be wasted.
> 
> The large percpu space is most likely from lockdep.

It would be better then to fix lockdep then to add weird hacks for that
elsewhere.

e.g. it could just allocate buffers in a cpu up/down callback and 
only put a pointer to these buffers into percpu.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
