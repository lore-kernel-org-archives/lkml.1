Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbYELXTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbYELXTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 19:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbYELXTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 19:19:01 -0400
Received: from mars.karoo.kcom.com ([212.50.160.54]:58665 "EHLO
	mars.karool.kcom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753384AbYELXS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 19:18:57 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 May 2008 19:18:57 EDT
X-IronPort-AV: E=Sophos;i="4.27,475,1204502400"; 
   d="scan'208";a="327493657"
Date: Tue, 13 May 2008 00:12:32 +0100
From: Martin Habets <errandir_news@mph.eclipse.co.uk>
To: David Miller <davem@davemloft.net>
Cc: jlieskov@redhat.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: sparc: Fix mremap VA span checking.
Message-ID: <20080512231231.GA8373@palantir8>
Mail-Followup-To: David Miller <davem@davemloft.net>, jlieskov@redhat.com,
	sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1210590913.10883.9.camel@dhcp-lab-164.englab.brq.redhat.com> <20080512.042453.238263459.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512.042453.238263459.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 04:24:53AM -0700, David Miller wrote:
> From: Jan Lieskovsky <jlieskov@redhat.com>
> Date: Mon, 12 May 2008 13:15:12 +0200
> 
> >  I have investigated the code for MREMAP_FIXED in
> > sparc_mremap in arch/sparc/kernel/sys_sparc.c, for sys64_mremap
> > in arch/sparc64/kernel/sys_sparc.c and 
> > for sys32_mremap in arch/sparc64/kernel/sys_sparc32.c
> > and there are similar conditional range checks ->
> > attaching the patches against 2.6.25.3.
> 
> Thanks for the report, I'll take a look at this after getting
> some sleep as it's late hear.
> 
> My first impression is that it might make sense to put an
> arch_mmap_check() call at the appropriate spots instead of duplicating
> this check so many times.

sparc32 already has an sparc_mmap_check() in sys_sparc that does this,
and sparc64 has sparc64_mmap_check().
Calling that should do the trick.

-- 
Martin
