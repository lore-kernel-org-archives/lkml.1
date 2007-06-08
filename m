Return-Path: <linux-kernel-owner+w=401wt.eu-S933756AbXFHOqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756AbXFHOqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbXFHOq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:46:28 -0400
Received: from holomorphy.com ([66.93.40.71]:47899 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbXFHOq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:46:28 -0400
Date: Fri, 8 Jun 2007 07:47:37 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, ak@suse.de, akpm@linux-foundation.org,
       lkml@rtr.ca
Subject: Re: divorce CONFIG_X86_PAE from CONFIG_HIGHMEM64G
Message-ID: <20070608144737.GZ6909@holomorphy.com>
References: <200706080807.l5887qJH017346@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706080807.l5887qJH017346@harpo.it.uu.se>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 10:07:52AM +0200, Mikael Pettersson wrote:
> Is this really needed? I can see why VMSPLIT_{2,3}G_OPT would
> depend on !HIGHMEM, but why would they depend on !X86_PAE?

The only reason they depend on !HIGHMEM is because handling for
1GB-unaligned splits is unimplemented for PAE, which formerly only
occurred in conjunction with HIGHMEM64G. That said, they were oriented
toward avoiding highmem on laptops, hence the broader !HIGHMEM
constraint. The entire point of the patch is to add an option to use
PAE without highmem for the purposes of NX and secondarily expanded
swapspace, at which point CONFIG_VMSPLIT_[23]G_OPT need some other way
besides !HIGHMEM to exclude PAE, such as specifying !X86_PAE directly.


-- wli
