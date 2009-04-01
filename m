Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbZDAB5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbZDAB5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZDAB5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:57:21 -0400
Received: from outbound-mail-14.bluehost.com ([69.89.18.114]:35789 "HELO
	outbound-mail-14.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752597AbZDAB5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:57:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=tUREBbmI7754wwX253J74hroYa+GyeoXVUGgQL8EcL72yVJfqt7jbMqD/2/Eq+0Lh5gpUbYaX9LwvZDvh4aakbz+logI4aFGI090QNRjWd9WqgIC+zim7XciymAlnYNy;
Date: Tue, 31 Mar 2009 18:57:12 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: suresh.b.siddha@intel.com
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>, lkml <linux-kernel@vger.kernel.org>,
       airlied@gmail.com
Subject: Re: PAGE_CACHE_WC strikes again
Message-ID: <20090331185712.482877d6@hobbes>
In-Reply-To: <1238549424.27006.7757.camel@localhost.localdomain>
References: <1238544647.8369.682.camel@gaiman.anholt.net>
	<20090331171431.69ad044f@hobbes>
	<7E82351C108FA840AB1866AC776AEC4657F48B3E@orsmsx505.amr.corp.intel.com>
	<1238547790.27006.7743.camel@localhost.localdomain>
	<20090331181251.46cf95b1@hobbes>
	<1238549424.27006.7757.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 17:30:24 -0800
Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Tue, 2009-03-31 at 18:12 -0700, Jesse Barnes wrote:
> > Right, the drm driver code went in before we had
> > pgprot_writecombine. Now that it's available we should definitely
> > use it.  I'm not sure about the set_memory_* routines though; we
> > create io mappings in i915_dma.c at init time, and I thought we
> > took care of things in i915_gem.c but we may need updates there.
> 
> Jesse, yes i915_gem.c seems to be doing the right thing.
> 
> What about various fault handlers in drm_vm.c like
> drm_do_vm_shm_fault() etc. None of these fault handlers require
> special attributes like wc/uc etc?

Those are legacy.  I don't think they need anything changed...  Dave
could correct me though.

-- 
Jesse Barnes, Intel Open Source Technology Center
