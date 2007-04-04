Return-Path: <linux-kernel-owner+w=401wt.eu-S2992835AbXDDKbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992835AbXDDKbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 06:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992838AbXDDKbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 06:31:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992834AbXDDKbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 06:31:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070404040232.2FEF6DDEBA@ozlabs.org> 
References: <20070404040232.2FEF6DDEBA@ozlabs.org> 
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Linux Memory Management <linux-mm@kvack.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/14] get_unmapped_area handles MAP_FIXED in /dev/mem (nommu) 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 04 Apr 2007 11:31:09 +0100
Message-ID: <23349.1175682669@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> +	if (flags & MAP_FIXED)
> +		if ((addr >> PAGE_SHIFT) != pgoff)
> +			return (unsigned long) -EINVAL;

Again... in NOMMU-mode there is no MAP_FIXED - it's rejected before we get
this far.

> -	return pgoff;
> +	return pgoff << PAGE_SHIFT;

That, however, does appear to be a genuine bugfix.

David
