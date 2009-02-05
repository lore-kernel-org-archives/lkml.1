Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbZBEIAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbZBEIAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 03:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbZBEIAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 03:00:24 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:43420 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbZBEIAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 03:00:23 -0500
Date: Thu, 5 Feb 2009 09:00:16 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: mel@csn.ul.ie, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: HOLES_IN_ZONE...
Message-ID: <20090205090016.6197d588@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090204.222651.26527737.davem@davemloft.net>
References: <20090204.222651.26527737.davem@davemloft.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Feb 2009 22:26:51 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> I also noticed that when S390 got virtual memmap support, it acquired
> the HOLES_IN_ZONE setting as well, in this commit:
> 
> commit f4eb07c17df2e6cf9bd58bfcd9cc9e05e9489d07
> Author: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date:   Fri Dec 8 15:56:07 2006 +0100
> 
>     [S390] Virtual memmap for s390.
> 
> This is confusing.  Is HOLES_IN_ZONE only required when virtual mmap
> is being used?  If so, why is that?  This is a very poorly documented
> flag, and I'm saying this after pouring over every commit referencing
> it.

I should have split that into two commits back then. When writing the
vmemmap code for s390 I realized that we never guaranteed that zones
start on a MAX_ORDER boundary or have a size that is a multiple of
MAX_ORDER. So I just added HOLES_IN_ZONE.

> Later this HOLES_IN_ZONE requirement was removed on s390 by commit:
> 
> commit 9f4b0ba81f158df459fa2cfc98ab1475c090f29c
> Author: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date:   Sat Jan 26 14:11:02 2008 +0100
> 
>     [S390] Get rid of HOLES_IN_ZONE requirement.

This just made sure that all zones start on a MAX_ORDER boundary and
just leaves memory that doesn't fit unused. So the requirement for
HOLES_IN_ZONE went away.

Later I reduced MAX_ORDER to 9 on s390, so we don't leave large
portions of memory unused.
