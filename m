Return-Path: <linux-kernel-owner+w=401wt.eu-S932798AbYEGIXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798AbYEGIXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 04:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbYEGIXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 04:23:18 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:18293 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbYEGIXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 04:23:15 -0400
Date: Wed, 7 May 2008 10:23:10 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: benh@kernel.crashing.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, tony@bakeyournoodle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
 drivers/video/aty/radeon_base.c
Message-ID: <20080507102310.57b4ccfb@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1210134804.21644.202.camel@pasglop>
References: <20080424043400.GS20457@bakeyournoodle.com>
	<20080506143936.6357e578.akpm@linux-foundation.org>
	<20080506.144301.233784820.davem@davemloft.net>
	<1210121683.21644.194.camel@pasglop>
	<20080506182006.4b4a3968.akpm@linux-foundation.org>
	<1210134804.21644.202.camel@pasglop>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 14:33:24 +1000,
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> You haven't read me properly. I'm not advocating completely ignoring
> those errors. In fact, I'm all about keeping must check on things like
> allocations. However, in cases like sysfs_create_file() like many
> similar things where failure will -not- prevent proper operations of the
> driver or subsystem, 

But they are often an indication that we messed up earlier (e. g. try
to add something twice)...

> mostly only compromise the user ABI, 

Which is bad enough in itself. Most people will want to avoid a
crippled ABI.

> I believe it's
> a _LOT_ more efficient to put -one- printk in the function itself,
> rather than all callers
> 
> > Now you come along and cherrypick a few callsites where you'd rather not
> > bother checking and assert that the entire effort was wrong-headed.  Well
> > sorry, no, it wasn't.  Sure, there's a little bit of undesirable fallout
> > but the whole thing had.  to.  be.  done.
> 
> Of course the whole effort was not wrong headed. I'm really only
> complaining about all those stupid sysfs_create_file() and maybe a
> handful of similar ones.

Hm, just took a look at the code:

- for "entry already exists", sysfs will already spit a warning.
- for "argh, we can't get a dirent", sysfs won't say anything.

The first one is the one we really want to yell about, since we've
messed up somewhere. The second one is not as likely, maybe we want to
warn about it when we activate debug options?

Which of the current __must_check functions do you think should have
the __must_check removed?
