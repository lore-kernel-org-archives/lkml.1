Return-Path: <linux-kernel-owner+w=401wt.eu-S1760605AbXJLRwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605AbXJLRwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758604AbXJLRwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:52:15 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:50380 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876AbXJLRwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:52:14 -0400
Date: Fri, 12 Oct 2007 18:52:10 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Franck Bui-Huu <vagabon.xyz@gmail.com>, linux-arch@vger.kernel.org,
       linux-mips@linux-mips.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Discardable strings for init and exit sections
Message-ID: <20071012175209.GA1110@linux-mips.org>
References: <Pine.LNX.4.64N.0710121711120.21684@blysk.ds.pg.gda.pl> <20071012171938.GB6476@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012171938.GB6476@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 07:19:38PM +0200, Adrian Bunk wrote:

> I have an objection against this approach:
> 
> Our __*init*/__*exit* annotations are already a constant source of bugs, 
> and adding more pifalls (e.g. forgotten removal of _i()/_e() when a 
> function is no longer __*init*/__*exit*) doesn't sound like a good plan.
> 
> Shouldn't it be possible to automatically determine where to put the 
> strings? I don't know enough gcc/ld voodoo for being able to tell 
> whether it is currently possible, and if yes how, but doing it 
> automatically sounds like the only solution that wouldn't result in an
> unmaintainable mess.

gcc tends to place data such as strings or jump tables generated from
switches not into a place were it would be easily discardable.  The
latter is the reason that on MIPS we can't discard __exit functions
at all - a switch table in .rodata might be referencing discarded code
in .exit.text which makes ld fail.  When I discussed this with some gcc
people a while ago nobody really had a good suggestion to solve this.

  Ralf
