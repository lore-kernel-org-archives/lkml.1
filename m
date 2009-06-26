Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbZFZEex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbZFZEex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 00:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbZFZEep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 00:34:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:47796 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbZFZEeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 00:34:44 -0400
From: "NeilBrown" <neilb@suse.de>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Date: Fri, 26 Jun 2009 14:34:37 +1000 (EST)
Message-ID: <f236aae1aa8ea7c4f3700dbca2f3ae14.squirrel@neil.brown.name>
In-Reply-To: <20090626125331.89c689f2.sfr@canb.auug.org.au>
References: <20090626125331.89c689f2.sfr@canb.auug.org.au>
Subject: Re: linux-next: block tree build failure
Cc: "Jens Axboe" <jens.axboe@oracle.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, June 26, 2009 12:53 pm, Stephen Rothwell wrote:
> Hi Jens,
>
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
>
> block/blk-core.c: In function '__make_request':
> block/blk-core.c:1179: error: expected ';' before 'return'
>
> Caused by commit 6cf2a6c8d01514e86a8d38e4eeed402378b635dc ("Restore
> barrier support for md and probably other virtual devices") which I have
> reverted for today.

Arg, that's my fault - sorry.

+               bio_endio(bio, -EOPNOTSUPP)
+                       return 0;

should of course be

+               bio_endio(bio, -EOPNOTSUPP);
+               return 0;

NeilBrown

