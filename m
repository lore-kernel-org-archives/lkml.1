Return-Path: <linux-kernel-owner+w=401wt.eu-S1764151AbXF1C5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764151AbXF1C5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 22:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760060AbXF1C5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 22:57:44 -0400
Received: from mail.fieldses.org ([66.93.2.214]:57923 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759235AbXF1C5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 22:57:43 -0400
Date: Wed, 27 Jun 2007 22:57:39 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 007 of 8] knfsd: nfsd4: vary maximum delegation limit based on RAM size
Message-ID: <20070628025739.GD20605@fieldses.org>
References: <20070621142604.727.patches@notabene> <1070621043112.1144@suse.de> <20070625205244.bbf0976a.akpm@linux-foundation.org> <20070628021551.GB20605@fieldses.org> <20070627193613.746dfbf3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627193613.746dfbf3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 07:36:13PM -0700, Andrew Morton wrote:
> How's this?

Makes sense to me, thanks.  I guess fs/nsfd/nfssvc:nfsd_create_serv()
should be similarly modified?  It calculates the size of per-nfsd-thread
buffers used to hold requests, which will eventually be allocated with
an alloc_page(GFP_KERNEL), and it bases the calculation on the same
.totalram field from struct sysinfo.

--b.
