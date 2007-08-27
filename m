Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbXH0NOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbXH0NOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 09:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbXH0NOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 09:14:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:36219 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbXH0NON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 09:14:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P38/wDVKtJmYvrkYMj49C0krOvMsuKVebfyzvLeRS2WiHUVXViaQ5rBz/Dgz9Jir8qo18qtGB1UvE5Jca9DShRyvD8c2ac7XX6yfyudU8vGJj3MUvEQC48sbMXsoMpkwXoFyKsx9+wwCv4Rsl41SUa3I3dY014VcL4IZC4lDFbI=
Message-ID: <c70ff3ad0708270614t6f17b38nfbdf84ace69b8d78@mail.gmail.com>
Date: Mon, 27 Aug 2007 16:14:13 +0300
From: "saeed bishara" <saeed.bishara@gmail.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [md-accel PATCH 16/19] dmaengine: driver for the iop32x, iop33x, and iop13xx raid engines
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de,
       akpm@linux-foundation.org, davem@davemloft.net,
       christopher.leech@intel.com, shannon.nelson@intel.com,
       herbert@gondor.apana.org.au, jeff@garzik.org
In-Reply-To: <c70ff3ad0708270611x5598fa9dlc3afa5f6fabd6563@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
	 <20070627015155.18962.88413.stgit@dwillia2-linux.ch.intel.com>
	 <c70ff3ad0708270611x5598fa9dlc3afa5f6fabd6563@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,
I think you have a bug in this function, the list_splice_init adds the
new slots in the head of the chain_node, but you get the
old_chain_tail (latest descriptor) from the tail of the chain!!

 > +static dma_cookie_t
 > +iop_adma_tx_submit(struct dma_async_tx_descriptor *tx)
 > +{
 > +
 > +       old_chain_tail = list_entry(iop_chan->chain.prev,
 > +               struct iop_adma_desc_slot, chain_node);
 > +       list_splice_init(&sw_desc->group_list, &old_chain_tail->chain_node);
 > +
 > +       /* fix up the hardware chain */
 > +       iop_desc_set_next_desc(old_chain_tail, grp_start->phys);
 > +
