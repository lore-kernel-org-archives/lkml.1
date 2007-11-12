Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbXKLRAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbXKLRAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 12:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758881AbXKLQ75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 11:59:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45644 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758755AbXKLQ74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 11:59:56 -0500
Date: Mon, 12 Nov 2007 17:59:53 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Pavel Emelyanov <xemul@openvz.org>, Andi Kleen <andi@firstfloor.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH] module loader should not complain about unknown symbol
Message-ID: <20071112165952.GA26064@one.firstfloor.org>
References: <1194877107.5656.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194877107.5656.31.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 02:18:27PM +0000, Jan Glauber wrote:
> If module A depends on module B and module B has not yet finished its
> init() the module loader may print a warning about an unknown symbol.
> 
> This happens if module B is still in state MODULE_STATE_COMING,
> as module A runs into resolve_symbol() for a symbol from module B.
> resolve_symbol() return 0 in that case and causes the warning.

I don't think that patch is a good idea. It points to a kernel problem of 
some sort that needs to be resolved. Making it fail silently is not
an improvement.

Also how else should the user know about "legitimate" (not caused by races)
unresolved symbols? 

-Andi
