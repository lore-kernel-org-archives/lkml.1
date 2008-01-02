Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbYABM04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbYABM04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 07:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYABM0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 07:26:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:52413 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbYABM0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 07:26:45 -0500
Date: Wed, 2 Jan 2008 13:26:10 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: Theodore Tso <tytso@mit.edu>, 7eggert@gmx.de, viro@zeniv.linux.org.uk,
       davem@davemloft.net, jengelh@computergmbh.de, devzero@web.de,
       linux-kernel@vger.kernel.org, bunk@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Force UNIX domain sockets to be built in
In-Reply-To: <E1JA0mT-0008U2-00@gondolin.me.apana.org.au>
Message-ID: <alpine.LSU.0.999.0801021308260.2414@be1.lrz>
References: <E1JA0mT-0008U2-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1++uJD59AhYAWB2XBZ9LzIgcqcBbGy7ygI4L8b
 QMcG+r+uo7/91Vop7QHk2Wv2/12fODnFQ7y15Fhj4wntWPxmQU
 DsVZxesTSPlWTYu7pPTWQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2008, Herbert Xu wrote:
> Theodore Tso <tytso@mit.edu> wrote:

> > The question is whether the size of the Unix domain sockets support is
> > worth the complexity of yet another config option that we expose to
> > the user.  For the embedded world, OK, maybe they want to save 14k of
> > non-swappable memory.  But for the non-embedded world, given the 117k
> > mandatory memory usage of sysfs, or the 124k memory usage of the core
> > networking stack, never mind the 3 megabytes of memory used by objects
> > in the kernel subdirectory, it's not clear that it's worth worrying
> > over 14k of memory, especially when many Unix programs assume
> > that Unix Domain Sockets are present.
> 
> That would make sense if we were proposing to get rid of the CONFIG_UNIX
> question altogether for !CONFIG_EMBEDDED.

Exactly this is what my patch does: The question is not to be displayed 
unless EMBEDDED, and the default is changed to y.

>  However, the proposal here is
> merely to eliminate the modular option but the CONFIG_UNIX prompt itself
> will remain even without CONFIG_EMBEDDED.
> 
> This I think is quite pointless.

That's what another patch would do. I decided that s/tristate/bool/ is 
something completely different from adding the default and hiding the 
option, and that I'd avoid this discussion by not eliminating UNIX=m.

-- 
Top 100 things you don't want the sysadmin to say:
96. That's SOOOOO bizarre.
