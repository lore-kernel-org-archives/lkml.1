Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbXHBMFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbXHBMFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757171AbXHBMF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:05:26 -0400
Received: from mail.suse.de ([195.135.220.2]:34108 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756990AbXHBMFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:05:25 -0400
Date: Thu, 2 Aug 2007 14:05:24 +0200
From: Jan Blunck <jblunck@suse.de>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Josef Sipek <jsipek@fsl.cs.sunysb.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>, hch@infradead.org
Subject: Re: [RFC 12/26] ext2 white-out support
Message-ID: <20070802120524.GY5101@hasse.suse.de>
References: <1185997941.18007.30.camel@kleikamp.austin.ibm.com> <200708012206.l71M6ai6028268@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708012206.l71M6ai6028268@agora.fsl.cs.sunysb.edu>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, Erez Zadok wrote:

> There are three other reasons why Unionfs and our users like to have
> multiple writable branches:
> 

...

>    And yes, it does make our implementation more complex.

And error-prone and unflexible wrt to changes. When XIP was introduced,
unionfs crashed all over this changes. I don't know if this has changed
yet. Not speaking of other issues like calling back into VFS (stack usage),
locking problems and so on.

> 3. Some people use Unionfs in the scenario described in point #2 above, as a
>    poor man's space- and load- distribution system.  Some of our users like
>    the idea of controlling how much storage space they give each branch, and
>    how much it might grow, and even how much CPU or I/O load might be placed
>    on each of the lower filesystems which serve a given branch.  That way
>    they worry less about the top-layer's space filling up more quickly than
>    expected.  Now Unionfs was never designed to be a load-balancing f/s (we
>    have RAIF for that, see <http://www.filesystems.org/project-raif.html>),
>    but users seems to always find creative ways to [ab]use one's software in
>    ways one never thought of. :-)

And this has nothing to do with unioning ...

> BTW, does Union Mounts copyup on meta-data changes (e.g., chmod, chgrp,
> etc.)?

No. But it was proposed during on of the last postings.
