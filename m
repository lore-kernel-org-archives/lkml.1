Return-Path: <linux-kernel-owner+w=401wt.eu-S934496AbZAOXTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934496AbZAOXTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763621AbZAOXTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:19:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46123
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1763906AbZAOXTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:19:14 -0500
Date: Thu, 15 Jan 2009 15:19:14 -0800 (PST)
Message-Id: <20090115.151914.84641343.davem@davemloft.net>
To: w@1wt.eu
Cc: jarkao2@gmail.com, herbert@gondor.apana.org.au, zbr@ioremap.net,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090115230331.GB1123@1wt.eu>
References: <20090114085308.GB4234@ff.dom.local>
	<20090114.012919.117682429.davem@davemloft.net>
	<20090115230331.GB1123@1wt.eu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>
Date: Fri, 16 Jan 2009 00:03:31 +0100

> please don't merge it as-is. I've just tried it and got an OOM
> in __alloc_pages_internal after a few seconds of data transfer.
> 
> I'm leaving the patch below for comments, maybe someone will spot
> something ? Don't we need at least one kfree() somewhere to match
> alloc_pages() ?

What is needed is a put_page().

But that should be happening as a result of the splice callback.
