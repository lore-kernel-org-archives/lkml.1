Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYGELzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYGELzI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 07:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYGELy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 07:54:56 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:39042 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbYGELy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 07:54:56 -0400
Date: Sat, 5 Jul 2008 13:54:51 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 02/20] lib: generic show_mem()
Message-ID: <20080705115451.GC5454@osiris.boeblingen.de.ibm.com>
References: <20080704160737.750988999@saeurebad.de> <20080704161452.730548249@saeurebad.de> <20080705083445.GA5454@osiris.boeblingen.de.ibm.com> <87hcb44lie.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hcb44lie.fsf@saeurebad.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Umh.. I think your 4th patch set was the way to go. This set is not
> > bisectable anymore and those architectures which you didn't convert
> > to the generic implementation won't build anymore. show_mem is present
> > twice there...
> 
> hannes@skyscraper:/tmp/test$ gcc -o prog prog.c lib1.a lib2.a && ./prog
> lib1
> hannes@skyscraper:/tmp/test$ gcc -o prog prog.c lib2.a lib1.a && ./prog
> lib2
> 
> Both lib1 and lib2 define foo() which prog calls.
> 
> I tested this with x86 and it built before and after removal of the
> x86-specific show_mem() (and it did the right thing as the arch code has
> higher priority than lib code).
> 
> But why is it no more bisectable?  You have one point where your kernel
> uses the arch-specific show_mem() and in the next commit, you use the
> generic version.  If something breaks, you can compare the old arch
> version with the generic version.

My fault. It works.
