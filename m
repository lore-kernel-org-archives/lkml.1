Return-Path: <linux-kernel-owner+w=401wt.eu-S964860AbXBUWKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964860AbXBUWKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964978AbXBUWKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:10:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36765 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965010AbXBUWKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:10:19 -0500
From: Andi Kleen <ak@suse.de>
To: virtualization@lists.osdl.org
Subject: Re: [patch 17/24] Xen-paravirt_ops: avoid having a bad selector in %gs during context switch
Date: Wed, 21 Feb 2007 23:10:02 +0100
User-Agent: KMail/1.9.5
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Chris Wright <chrisw@sous-sol.org>,
       xen-devel@lists.xensource.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070221205254.169835700@goop.org> <20070221205323.770169136@goop.org>
In-Reply-To: <20070221205323.770169136@goop.org>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702212310.02218.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>  	/*
> +	 * Temporary hack: zero gs now that we've saved it so that Xen
> +	 * doesn't try to reload the old value after changing the GDT
> +	 * during the context switch.  This can go away once Xen has
> +	 * been taught to only reload %gs when it absolutely must.
> +	 */
> +	loadsegment(gs, 0);

Sorry, but i don't really want that unconditionally in the context switch.
Adding a paravirt ops for it would be also ugly. Can Xen be fixed?

-Andi
