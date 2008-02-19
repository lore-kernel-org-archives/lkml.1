Return-Path: <linux-kernel-owner+w=401wt.eu-S1762269AbYBSJ2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269AbYBSJ2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:28:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYBSJ2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:28:45 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49045 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbYBSJ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:28:44 -0500
Date: Tue, 19 Feb 2008 10:28:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>, Roel Kluin <12o3l@tiscali.nl>,
       geoffrey.levand@am.sony.com, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Fix Unlikely(x) == y
Message-ID: <20080219092846.GB6485@one.firstfloor.org>
References: <47B70A61.9030306@tiscali.nl> <20080216094226.1e8eede1@laptopd505.fenrus.org> <p731w7axrat.fsf@bingen.suse.de> <200802191333.53607.nickpiggin@yahoo.com.au> <20080219055806.GA8404@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219055806.GA8404@1wt.eu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sometimes, for performance critical paths, I would like gcc to be dumb and
> follow *my* code and not its hard-coded probabilities. 

If you really want that, simple: just disable optimization @)

> Maybe one thing we would need would be the ability to assign probabilities
> to each branch based on what we expect, so that gcc could build a better
> tree keeping most frequently used code tight.

Just use profile feedback then for user space. I don't think it's a good
idea for kernel code though because it leads to unreproducible binaries
which would wreck the development model.

> Hmm I've just noticed -fno-guess-branch-probability in the man, I never tried
> it.

Or -fno-reorder-blocks

-Andi

