Return-Path: <linux-kernel-owner+w=401wt.eu-S1758182AbZA2BEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbZA2BEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 20:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757277AbZA2BDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 20:03:38 -0500
Received: from kroah.org ([198.145.64.141]:35252 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757060AbZA2BDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 20:03:37 -0500
Date: Wed, 28 Jan 2009 16:43:06 -0800
From: Greg KH <greg@kroah.com>
To: kyle@infradead.org
Cc: stable@kernel.org, arjan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH stable] resources: skip sanity check of busy
	resources
Message-ID: <20090129004306.GF23732@kroah.com>
References: <20090127161007.GG5034@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127161007.GG5034@bombadil.infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 11:10:07AM -0500, Kyle McMartin wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> Impact: reduce false positives in iomem_map_sanity_check()
> 
> Some drivers (vesafb) only map/reserve a portion of a resource.
> If then some other driver comes in and maps the whole resource,
> the current code WARN_ON's. This is not the intent of the checks
> in iomem_map_sanity_check(); rather these checks want to
> warn when crossing *hardware* resources only.
> 
> This patch skips BUSY resources as suggested by Linus.
> 
> Note: having two drivers talk to the same hardware at the same
> time is obviously not optimal behavior, but that's a separate story.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> ---
> 
> Bug fix for 2.6.28-stable only (relevant iomem_map_sanity_check hadn't
> been added to 2.6.27.) This resolves a fairly nasty boot time WARN
> in acpi ec seen on a number of systems. (RH #480700)

Thanks for the patch.  Next time, if you could let us know what the git
commit id is for the patch in Linus's tree, it would save me having to
dig to find it :)

thanks,

greg k-h
