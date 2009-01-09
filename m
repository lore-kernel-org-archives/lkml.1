Return-Path: <linux-kernel-owner+w=401wt.eu-S1757715AbZAIVzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbZAIVzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbZAIVza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:55:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbZAIVz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:55:29 -0500
Date: Fri, 9 Jan 2009 13:54:23 -0800
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-devel@lists.sourceforge.net,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Jay Fenlason <fenlason@redhat.com>
Subject: Re: [PATCH post 2.6.28] firewire: core: fix sleep in atomic
	context due to driver core change
Message-ID: <20090109215423.GA7869@suse.de>
References: <496798FE.8030900@s5r6.in-berlin.de> <tkrat.34f28fe71f678057@s5r6.in-berlin.de> <20090109211718.48a7a4a6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109211718.48a7a4a6@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 09:17:18PM +0000, Alan Cox wrote:
> On Fri, 9 Jan 2009 20:49:37 +0100 (CET)
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> 
> > Due to commit 2831fe6f9cc4e16c103504ee09a47a084297c0f3, "driver core:
> > create a private portion of struct device", device_initialize() can no
> > longer be called from atomic contexts.
> 
> I don't see why this is neccessary or appropriate - the original commit
> needs to be pulled and the private area allocation rethought.

Ugh, I think you're right.  I'll revert this (and all of the patches in
the series that were needed to get this working properly), and redo the
patch set, first making device_initialize() able to fail, and auditing
all callers to make sure it's not being called in atomic context.

At first glance, I think it's only firewire that is doing this in atomic
context, so Stefan, I wouldn't mind seeing your patch go in as-is just
to make things simpler overall.

I'll go make up the patchset and send them to Linus...

thanks,

greg k-h
