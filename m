Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbXFZEdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbXFZEdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 00:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbXFZEc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 00:32:58 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:47870 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbXFZEc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 00:32:57 -0400
Date: Tue, 26 Jun 2007 06:34:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, christopher.leech@intel.com,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] IOATDMA: fix section mismatches
Message-ID: <20070626043402.GA18269@uranus.ravnborg.org>
References: <20070625145147.c34cbfca.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625145147.c34cbfca.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 02:51:47PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Rename struct pci_driver data so that false section mismatch
> warnings won't be produced.
> 
> Sam, ISTM that depending on variable names is the weakest & worst part of
> modpost section checking.  Should __init_refok work here?  I got build
> errors when I tried to use it, probably because the struct pci_driver
> probe and remove methods are not marked "__init_refok".

Relying on naming is obviously a bad thing but without doing so
we would have tons of warnings from drivers/

__init_refok is for functions. For this case __initdata_refok
could have worked but to be consistent the renaming is much
better.

	Sam
