Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbYCNQuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbYCNQuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 12:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757410AbYCNQuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 12:50:25 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:26109 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019AbYCNQuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 12:50:24 -0400
Date: Thu, 13 Mar 2008 17:49:19 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Chandru <chandru@in.ibm.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, jdmason@kudzu.us
Subject: Re: [RFC] [Patch] calgary iommu: Use the first kernel's tce tables
	in kdump
Message-ID: <20080313154919.GE7114@il.ibm.com>
References: <20071009210623.GK4335@rhun.haifa.ibm.com> <20071010053057.GA24434@in.ibm.com> <20071014054110.GB4399@rhun.haifa.ibm.com> <20071015062919.GA4598@in.ibm.com> <476F4064.8010601@in.ibm.com> <47D5359D.5000909@in.ibm.com> <20080311132921.GA10828@redhat.com> <47D76561.8050805@in.ibm.com> <20080312095820.GG10790@tyrion.haifa.ibm.com> <20080312180806.GB13549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312180806.GB13549@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 02:08:06PM -0400, Vivek Goyal wrote:

> Agree. Ignoring all the DMA errors in kdump kernel does not sound
> very good.
> 
> On a side note, typically how much time does it take to for DMA
> operations to finish. Can we wait for a random amount of time in
> second kernel, hoping all the DMA operations are complete, and then
> setup a new table?
> 
> This can be atleast a stop gap solution till we come up with a good
> solution?

The problem as I understand it is that when we boot into the kdump
kernel we have left-over devices from the old kernel which are active
and initiating DMA's. This is fine as long as Calgayr is also active
(with the old kernel's mappings). Once we initialize Calgary (in the
kdump) kernel with the new mappings, however, it starts trapping all
those DMA's. We can't wait for them to stop, because that will only
happen when the device is re-initialized (or otherwise quiesced).

Cheers,
Muli
