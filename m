Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbXIZUmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbXIZUmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbXIZUmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:42:43 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:64742 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbXIZUmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:42:42 -0400
Date: Wed, 26 Sep 2007 15:41:56 -0500
From: Scott Wood <scottwood@freescale.com>
To: Rune Torgersen <runet@innovsys.com>
Cc: Dan Malek <dan@embeddedalley.com>, linuxppc-embedded@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH4/4] [POWERPC] Fix cpm_uart driver
Message-ID: <20070926204156.GA15217@loki.buserror.net>
References: <46F6C9DC.90008@scram.de> <46F8101E.1050000@freescale.com> <DCEAAC0833DD314AB0B58112AD99B93B0368C44B@ismail.innsys.innovsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DCEAAC0833DD314AB0B58112AD99B93B0368C44B@ismail.innsys.innovsys.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 03:32:29PM -0500, Rune Torgersen wrote:
> > From: Scott Wood
> > Maybe that's how it was, but the current code initializes it (more or
> > less) directly with IMAP_ADDR, which also gets fed into ioremap.
> > 
> > One of the two has got to be wrong.
> 
> arch/ppc maps the immr area 1:1 into kernel memory, so ioremap and
> physical are the same.
> See arch/ppc/syslib/m8260_setup.c, line 208 (function m8260_map_io)

We were talking about 8xx, not 82xx -- is it always identity mapped there?

If so, then why bother with the ioremap in immr_map_size() in
arch/ppc/8xx_io/commproc.c?  And why compare the result from ioremap() with
a raw identity-mapped address?

-Scott
