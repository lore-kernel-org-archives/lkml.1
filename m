Return-Path: <linux-kernel-owner+w=401wt.eu-S2992826AbXDDKRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992826AbXDDKRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 06:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992823AbXDDKRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 06:17:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992829AbXDDKRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 06:17:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070404040231.A110CDDEB8@ozlabs.org> 
References: <20070404040231.A110CDDEB8@ozlabs.org> 
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Linux Memory Management <linux-mm@kvack.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/14] get_unmapped_area handles MAP_FIXED on ramfs (nommu) 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 04 Apr 2007 11:16:58 +0100
Message-ID: <23091.1175681818@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> -	if (!(flags & MAP_SHARED))
> +	/* Deal with MAP_FIXED differently ? Forbid it ? Need help from some nommu
> +	 * folks there... --BenH.
> +	 */
> +	if ((flags & MAP_FIXED) || !(flags & MAP_SHARED))

MAP_FIXED on NOMMU?  Surely you jest...

See the first if-statement in validate_mmap_request().

If anything, you should be adding BUG_ON(flags & MAP_FIXED).

David
