Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbXIPLPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbXIPLPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 07:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbXIPLPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 07:15:43 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47066 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbXIPLPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 07:15:43 -0400
Date: Sun, 16 Sep 2007 13:17:08 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Matej Laitl <strohel@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] menuconfig: distinguish between selected-by-another options and comments
Message-ID: <20070916111708.GA7362@uranus.ravnborg.org>
References: <200709152004.11930.strohel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709152004.11930.strohel@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 08:04:10PM +0200, Matej Laitl wrote:
> menuconfig currently represents options implied by another option ('select'
> directive in Kconfig) by prefixing them with '---'. Unfortunately the same
> notation is used for comments.
> 
> This patch changes notation of selected-by-another items by introducing 2 new
> representations for implied options:
> {*} or {M} for options selected by another modularized one, thus builtin or
> module capable,
> -*- or -M- for options that cannot be at the moment changed by user.

With this patch we can now distingush between comments and menulines
that the user cannot cahnge.
As one of the major issues with kconfig is the evil select handling
it would have been much preferred to distingush between lines
that are selected-by and lines that cannot be changed for other
reasons.
The block menu is a good example where we do not sue select. It is marked
'---' because it is default y if EMBEDDED is not selected.

So the intention is clear and your changed interface (sym_get_min_val())
look OK.
But can you take a look at distingushing between non-selectable options
due to dependency issues and seleted-by symbols.

	Sam
