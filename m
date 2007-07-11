Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbXGKEiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbXGKEiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 00:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXGKEiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 00:38:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:47195 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbXGKEiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 00:38:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=r07Z1hMx20oRYuVVjDvc/DIdCYBHn2QMQiDJmnbdrYC6sby8iX2rleUdvK5eGjhYD2aZ03nWKXyJ77CbWDqn94Or7R1u8jPu1vkyC1ltILblOSA3oOoWsSiCiMAemHOkhgkMbB0TdOncc+i0Arqx0dQudroqm2BiYf+z6qSHJw0=
Date: Wed, 11 Jul 2007 08:37:58 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: =?iso-8859-1?Q?C=E9dric?= Augonnet <cedric.augonnet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 6][PATCH 1/1]Export jbd stats through procfs
Message-ID: <20070711043758.GA5766@martell.zuzino.mipt.ru>
References: <1183275490.4010.134.camel@localhost.localdomain> <20070710193117.a4ef6298.akpm@linux-foundation.org> <f56c1ba00707102021k13a758cbx66cbb6ec8bffac49@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f56c1ba00707102021k13a758cbx66cbb6ec8bffac49@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 11:21:49PM -0400, Cédric Augonnet wrote:
> 2007/7/10, Andrew Morton <akpm@linux-foundation.org>:
> 
> Hi all,
> 
> >> +     size = sizeof(struct transaction_stats_s);
> >> +     s->stats = kmalloc(size, GFP_KERNEL);
> >> +     if (s == NULL) {
	       ^
> >> +             kfree(s);
> >> +             return -EIO;
> >
> >ENOMEM

That, and

	if (s->stats == NULL)
		kfree(s);

> I'm sorry if i missed some point, but i just don't see the use of such
> a kfree here, not sure Andrew meant you should only return ENOMEM
> instead, but why issuing those kfree(NULL), instead of just a if (!s)
> return ENOMEM ?

kfree() is correct, check isn't.

