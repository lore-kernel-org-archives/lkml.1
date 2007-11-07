Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbXKGRjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbXKGRjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbXKGRjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:39:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53905 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbXKGRjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:39:42 -0500
Date: Wed, 7 Nov 2007 17:39:39 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
       James.Bottomley@SteelEye.com, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: PATCH [2/8] scsi: megaraid_sas - add module param fast_load
Message-ID: <20071107173939.GD25560@infradead.org>
References: <20071030173645.GA16455@infradead.org> <9738BCBE884FDB42801FAD8A7769C26501CA1BB0@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26501CA1BB0@NAMAIL1.ad.lsil.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 12:04:31PM -0700, Yang, Bo wrote:
> I see that scsi_scan_host_selected is in scsi_priv.h and currently is
> not used by any other driver. The scsi_priv.h is not part of the include
> dir (/include/scsi). One of the major Linux distro's don't even include
> this file in /usr/src/kernels. Also it looks like at this time this
> function may not be available (not exported?) for driver modules to use.
> Even if I include scsi_priv.h I get "unknown symbol" for this function
> while loading.

Yes, it would have to be exported and moved to a public header.

> May be in the long run we can solve all these issues to call
> scsi_scan_host_selected. However, the current implementation works fine
> and has been tested by LSI and others. This implementation doesn't break
> any protocol nor does it adversely affect any driver functionality.

Your implementation adds state to scanning that could easily break and
makes the driver complex for things that don't belong into a driver,
so there's a clear NACK for this from me.
