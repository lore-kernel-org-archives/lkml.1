Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbXKGKkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbXKGKkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 05:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbXKGKkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 05:40:46 -0500
Received: from lazybastard.de ([212.112.238.170]:55353 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbXKGKkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 05:40:45 -0500
Date: Wed, 7 Nov 2007 11:35:55 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andreas Schwab <schwab@suse.de>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Christoph Lameter <clameter@sgi.com>, akpm@linux-foundatin.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@skynet.ie>
Subject: Re: [patch 14/23] inodes: Support generic defragmentation
Message-ID: <20071107103554.GF7374@lazybastard.org>
References: <20071107011130.382244340@sgi.com> <20071107011229.893091119@sgi.com> <20071107101748.GC7374@lazybastard.org> <je8x5aibry.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <je8x5aibry.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 November 2007 11:35:13 +0100, Andreas Schwab wrote:
> >
> > The fact that all pointers get changed makes me a bit uneasy:
> > 	struct foo_inode v[20];
> > 	...
> > 	fs_get_inodes(..., v, ...);
> > 	...
> > 	v[0].foo_field = bar;
> > 	
> > No warning, but spectacular fireworks.
> 
> You'l get a warning that struct foo_inode * is incompatible with void **.
- 	struct foo_inode v[20];
+ 	struct foo_inode *v[20];

Looks like my example needs a patch as well.  Anyway, the function is
used in a way that makes this a non-issue.

Jörn

-- 
You cannot suppose that Moliere ever troubled himself to be original in the
matter of ideas. You cannot suppose that the stories he tells in his plays
have never been told before. They were culled, as you very well know.
-- Andre-Louis Moreau in Scarabouche
