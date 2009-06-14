Return-Path: <linux-kernel-owner+w=401wt.eu-S1763735AbZFNUm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763735AbZFNUm1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759560AbZFNUmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:42:19 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:38230 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbZFNUmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:42:19 -0400
Date: Sun, 14 Jun 2009 22:44:37 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: kbuild-devel@lists.sourceforge.net,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: scripts/kallsyms: extending region checking for Blackfin memory regions
Message-ID: <20090614204437.GC3187@uranus.ravnborg.org>
References: <8bd0f97a0906081623h4dc26492kd70c2e07091730d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0906081623h4dc26492kd70c2e07091730d@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 07:23:16PM -0400, Mike Frysinger wrote:
> intro: the current Blackfin memory architecture is (1) no virtualized
> memory and (2) distinctly harvard.  that means we cannot create a
> linear map of start/end text sections.  we end up with distinct
> regions like so:
> 00001000 T __stext
> 000dc4c0 T __etext
> feb00000 A __etext_l2
> feb00010 A __stext_l2
> ffa00000 T __stext_l1
> ffa0160c T __etext_l1
> this is because external memory starts at address 0 while on-chip
> regions have different discontiguous hardcoded addresses (L1
> instruction in this case starts at 0xffa00000 while L2 starts at
> 0xfeb00000).
> 
> the current kallsyms is written to search for the special stext/etext
> symbols only which means the resulting kallsyms output knows nothing
> of the Blackfin symbols living in these on-chip regions.  we've
> written two patches to fix this: the first one is straight forward and
> simply copies & pastes the existing hardcoded regions.  the second
> creates an array of text regions which makes it much easier to extend
> in the future for other people (and can be squashed into the first
> one).
> 
> doesnt matter to me which method is picked :)

I added both as I liked the generalization.
I had to rearrange the "Signed-off-by" in the first patch
as this patch came in vai you and not Robin.

	Sam
