Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbXGKEml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbXGKEml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 00:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXGKEmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 00:42:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58060 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752000AbXGKEma convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 00:42:30 -0400
Date: Tue, 10 Jul 2007 21:42:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?IkPpZHJpYyBBdWdvbm5ldCI=?= 
	<cedric.augonnet@gmail.com>
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 6][PATCH 1/1]Export jbd stats through procfs
Message-Id: <20070710214221.26539eb6.akpm@linux-foundation.org>
In-Reply-To: <f56c1ba00707102021k13a758cbx66cbb6ec8bffac49@mail.gmail.com>
References: <1183275490.4010.134.camel@localhost.localdomain>
	<20070710193117.a4ef6298.akpm@linux-foundation.org>
	<f56c1ba00707102021k13a758cbx66cbb6ec8bffac49@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 23:21:49 -0400 "Cédric Augonnet" <cedric.augonnet@gmail.com> wrote:

> 2007/7/10, Andrew Morton <akpm@linux-foundation.org>:
> 
> Hi all,
> 
> > > +     size = sizeof(struct transaction_stats_s);
> > > +     s->stats = kmalloc(size, GFP_KERNEL);
> > > +     if (s == NULL) {
> > > +             kfree(s);
> > > +             return -EIO;
> >
> > ENOMEM
> 
> I'm sorry if i missed some point, but i just don't see the use of such
> a kfree here, not sure Andrew meant you should only return ENOMEM
> instead, but why issuing those kfree(NULL), instead of just a if (!s)
> return ENOMEM ?
> 

You found a bug.  It was meant to be

	if (s->stats == NULL)


