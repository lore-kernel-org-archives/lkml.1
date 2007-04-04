Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbXDDXOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbXDDXOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 19:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXDDXOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 19:14:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:39146 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbXDDXOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 19:14:22 -0400
Subject: Re: [PATCH 12/14] get_unmapped_area handles MAP_FIXED in /dev/mem
	(nommu)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Linux Memory Management <linux-mm@kvack.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <23349.1175682669@redhat.com>
References: <20070404040232.2FEF6DDEBA@ozlabs.org>
	 <23349.1175682669@redhat.com>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 09:14:12 +1000
Message-Id: <1175728452.30879.81.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 11:31 +0100, David Howells wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > +	if (flags & MAP_FIXED)
> > +		if ((addr >> PAGE_SHIFT) != pgoff)
> > +			return (unsigned long) -EINVAL;
> 
> Again... in NOMMU-mode there is no MAP_FIXED - it's rejected before we get
> this far.
> 
> > -	return pgoff;
> > +	return pgoff << PAGE_SHIFT;
> 
> That, however, does appear to be a genuine bugfix.

I'll separate it from the rest of the patches

Ben.


