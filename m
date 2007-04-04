Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbXDDXOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbXDDXOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 19:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbXDDXOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 19:14:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:39139 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbXDDXOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 19:14:07 -0400
Subject: Re: [PATCH 11/14] get_unmapped_area handles MAP_FIXED on ramfs
	(nommu)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Linux Memory Management <linux-mm@kvack.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <23091.1175681818@redhat.com>
References: <20070404040231.A110CDDEB8@ozlabs.org>
	 <23091.1175681818@redhat.com>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 09:13:52 +1000
Message-Id: <1175728433.30879.79.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 11:16 +0100, David Howells wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > -	if (!(flags & MAP_SHARED))
> > +	/* Deal with MAP_FIXED differently ? Forbid it ? Need help from some nommu
> > +	 * folks there... --BenH.
> > +	 */
> > +	if ((flags & MAP_FIXED) || !(flags & MAP_SHARED))
> 
> MAP_FIXED on NOMMU?  Surely you jest...

Heh, see the comment, I was actually wondering about it :-)

> See the first if-statement in validate_mmap_request().
> 
> If anything, you should be adding BUG_ON(flags & MAP_FIXED).

Yeah, I missed that bit. That will simplify the problem.

Thanks,
Ben.


