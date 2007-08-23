Return-Path: <linux-kernel-owner+w=401wt.eu-S1762056AbXHWMHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762056AbXHWMHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 08:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757305AbXHWMHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 08:07:44 -0400
Received: from ns.suse.de ([195.135.220.2]:44387 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757595AbXHWMHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 08:07:43 -0400
Date: Thu, 23 Aug 2007 14:07:42 +0200
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-rc3-mm1
Message-ID: <20070823120742.GR8058@bingen.suse.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC6FB2.1010801@csn.ul.ie> <20070822111029.46db0ab7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822111029.46db0ab7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 11:10:29AM -0700, Andrew Morton wrote:
> x86_64-mm-less-stack-alignment.patch has
> 
> cflags-y += $(call cc-option,-mpreferred-stack-boundary=3)
> 
> So we _should_ have detected that gcc didn't like =3, so it
> should not have been used.

The flag actually needs a recent gcc 4.3 snapshot (it's
a new feature the gcc developers added especially for the
kernel :), so if this didn't work it would fail on the vast 
majority of systems.

Somehow it doesn't? At least here it compiles fine.

I notice the final comma is missing, Mel does it work
when you change the line to 

cflags-y += $(call cc-option,-mpreferred-stack-boundary=3,)  

If not please run
gcc -O2 -mpreferred-stack-boundary=2 -S -xc /dev/null -o x.o 
echo $?

What does the echo output?

-Andi

