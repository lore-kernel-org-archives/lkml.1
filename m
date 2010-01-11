Return-Path: <linux-kernel-owner+w=401wt.eu-S1751489Ab0AKWYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab0AKWYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 17:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944Ab0AKWYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 17:24:37 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63295 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab0AKWYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 17:24:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HBrMMnnwBGpSboYJbUGC1a3diHrVtSLXnfohJqem2KphxO43WqtypFuOtMV5DBWuOH
         VsyvIhJme9zh4vZsGuMBXgKvXW9lbIFRvYGX/TX/ruy/Pcd+HqdFyEXo/FvjpACPkvvW
         FQWTGCge5HX7PLdaRV3It0nFfMnY18Cgg//v0=
Subject: Re: RFC: [PATCH V2 0/9 Integration of SmartMedia/xD into mtd
 subsystem
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>, Alex Dubov <oakad@yahoo.com>
In-Reply-To: <20100109002600.GA3258@logfs.org>
References: <1262963092.12577.14.camel@maxim-laptop>
	 <20100108160404.GE31872@logfs.org> <1262972429.20060.4.camel@maxim-laptop>
	 <20100109002600.GA3258@logfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jan 2010 00:24:31 +0200
Message-ID: <1263248671.24201.7.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-09 at 01:26 +0100, Jörn Engel wrote: 
> On Fri, 8 January 2010 19:40:29 +0200, Maxim Levitsky wrote:
> > 
> > Btw, your cards aren't Type M, right?
> > However I use here a Type M card, and its likely to include an FTL
> > inside, thus, it might explain the low speeds I get there partially...
> 
> No, mine were the old ones before marketing invented the two types.
> 
> Jörn
> 

I finally located the source of slowdown.
It appears to be caused by too large caching I did (5 erase blocks).
If I cache one block, write speed nears 1 MB/s.
As a bonus that makes the FTL much simplified.

Another small flaw that currently exists in my FTL is that it ignores
the underlying badblock support from mtd driver and requeres it to
expose the two bad block bytes in the oob layout, I think I can avoid
that after all.

Other that that, everything is just perfect.

I post updated patchset soon.

Best regards,
Maxim Levitsky

