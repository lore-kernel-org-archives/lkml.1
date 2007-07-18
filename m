Return-Path: <linux-kernel-owner+w=401wt.eu-S932225AbXGRPYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225AbXGRPYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 11:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758001AbXGRPYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 11:24:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52946 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758182AbXGRPYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 11:24:30 -0400
Date: Wed, 18 Jul 2007 17:24:29 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Greg KH <greg@kroah.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "Ed L. Cashin" <ecashin@coraid.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stacked ifs (was Re: [PATCH 02/12] handle multiple
 network paths to AoE device)
In-Reply-To: <20070717000151.GA5982@kroah.com>
Message-ID: <Pine.LNX.4.64.0707181721410.5385@fbirervta.pbzchgretzou.qr>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
 <60bd316bfa72fb225cefad39569999e583f4f72e.1182883861.git.ecashin@coraid.com>
 <20070702212949.5a1a1a31.akpm@linux-foundation.org> <20070716221744.GM18477@coraid.com>
 <20070716153155.8a63c15d.akpm@linux-foundation.org> <20070717000151.GA5982@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 16 2007 17:01, Greg KH wrote:
>> 
>> > > ugh.  Do this:
>> > > 
>> > > 	do {
>> > > 		if (t == d->htgt)
>> > > 			continue;
>> > > 		if (!(*t)->ifp->nd)
>> > > 			continue;
>> > > 		if ((*t)->nout >= (*t)->maxout)
>> > > 			continue;
>> > > 			
>> > > 		<stuff>
>> > > 	} while (++t ...)
>> > 
>> > Do you think the "stacked ifs" in the first version above could be
>> > accepted as a convenient extension to the K&R-based conventions in
>> > Documentation/CodingStyle?
>> 
>> Maybe.  I don't recall seeing any kernel code which uses that convention:
>> everyone uses &&.  So personally I'd prefer to see kernel code stick to the
>> one convention, given that there is not, afacit, any significant advantage
>> to the alternative one.
>
>I agree, let's stick with the convention we already have and use
>instead.

Yup. Either the "do this" (see above) or the "&&" variant, though, the latter
can become quite nested or long.

[ In fact, if you have
  void function(struct something *arg)
  {
  	if (arg != NULL) {
  		lots_of_code;
  	}
  }
  it is perhaps better to write as
  {
  	if (arg == NULL)
  		return;
  	lots_of_code;
  }
  since that reduces the indent by at least one. ]


	Jan
-- 
