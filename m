Return-Path: <linux-kernel-owner+w=401wt.eu-S1764201AbXF1DLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764201AbXF1DLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 23:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759293AbXF1DLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 23:11:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56425 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759348AbXF1DK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 23:10:59 -0400
Date: Wed, 27 Jun 2007 20:10:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: NeilBrown <neilb@suse.de>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 007 of 8] knfsd: nfsd4: vary maximum delegation limit
 based on RAM size
Message-Id: <20070627201035.dbbb84e7.akpm@linux-foundation.org>
In-Reply-To: <20070628025739.GD20605@fieldses.org>
References: <20070621142604.727.patches@notabene>
	<1070621043112.1144@suse.de>
	<20070625205244.bbf0976a.akpm@linux-foundation.org>
	<20070628021551.GB20605@fieldses.org>
	<20070627193613.746dfbf3.akpm@linux-foundation.org>
	<20070628025739.GD20605@fieldses.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 22:57:39 -0400 "J. Bruce Fields" <bfields@fieldses.org> wrote:

> On Wed, Jun 27, 2007 at 07:36:13PM -0700, Andrew Morton wrote:
> > How's this?
> 
> Makes sense to me, thanks.  I guess fs/nsfd/nfssvc:nfsd_create_serv()
> should be similarly modified?  It calculates the size of per-nfsd-thread
> buffers used to hold requests, which will eventually be allocated with
> an alloc_page(GFP_KERNEL), and it bases the calculation on the same
> .totalram field from struct sysinfo.

Yup, it'd be better to use nr_free_buffer_pages() there too.
