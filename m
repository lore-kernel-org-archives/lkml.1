Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbZI3PYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbZI3PYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbZI3PYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:24:24 -0400
Received: from adelie.canonical.com ([91.189.90.139]:48583 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbZI3PYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:24:23 -0400
Date: Wed, 30 Sep 2009 16:24:26 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] checkpatch: fix hang in relative indent checking
Message-ID: <20090930152426.GC2957@shadowen.org>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 07:14:48PM -0700, Daniel Walker wrote:
> I ran this command on v2.6.31 ,
> 
> ./scripts/checkpatch.pl --file net/decnet/dn_fib.c
> 
> which resulted in checkpatch hanging without any output.
> 
> The lines that cause the hang are,
> 
> #define for_nexthops(fi) { int nhsel; const struct dn_fib_nh *nh;\
>         for(nhsel = 0, nh = (fi)->fib_nh; nhsel < (fi)->fib_nhs; nh++, nhsel++)
> 
> The hang happend in the relative indent checking code. Checkpatch has the
> following comment around the relative indent checking block,
> 
> # Also ignore a loop construct at the end of a
> # preprocessor statement.
> 
> Since the line it's hanging on exactly fits the comment it shouldn't even be
> checking this line. To resolve this I just prevent the checking like the
> comment says should happen.

Ok, this actually seems to have already been fixed in the version Andrew
already has.  Specifically it was fixed by the change in:

    checkpatch: indent checks -- stop when we run out of continuation lines

I assume this is happening with v0.28?  Could you retest that one with
the version at the URL below for me to confirm.

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-0.29

Thanks for the patch.

-apw
