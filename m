Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbZAFIzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbZAFIzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 03:55:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750906AbZAFIyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 03:54:51 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:33311 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZAFIyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 03:54:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=regVbll18ZXSQ1XWLiNF2h1PMtdEY/OgrjI/XOqZXy8epZp05BBB2FmSmjW1X0zRru
         NsUZWR/c3P7sMbtrRGib4yMMNHv4tbymbmBm1PExCfgrPScl44Y8hiLOEomU1iNVpJ8K
         g4pT5LK+CmE9QUw1JYx2lpeP97yJ/NERHZbVg=
Date: Tue, 6 Jan 2009 08:54:42 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090106085442.GA9513@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224152841.GB13113@1wt.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24-12-2008 16:28, Willy Tarreau wrote:
> Hi Jens,
> 
> I'm facing a data corruption problem with splice() between two
> non-blocking TCP sockets on 2.6.27.10. I could finally write a
> simpler proof of concept, and capture a snapshot of the issue
> with the associated strace result.
...
> I found an analysis [1] for a potential corruption problem between two
> sockets, but I noticed there were no responses and I did not fully
> understand the report anyway.
> 
> What can I do to help debug the problem ? I'm really willing to help
> getting this fixed, and I also have at least one user who definitely
> wants splice() to work because the recv/send model currently limits
> haproxy to 3 Gbps on his machines, while I have no problem reaching
> 10 Gbps with splice().
...
> ----
> [1] http://lkml.org/lkml/2008/2/26/210

Great story! Alas I don't understand this fully either, but it seems
Changli Gao was concerned with sendpage sending this "as pages", so
when NETIF_F_SG flag is available. Did you try this without SG btw?

Thanks,
Jarek P.
