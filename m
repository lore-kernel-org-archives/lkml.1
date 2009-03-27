Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbZC0OYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbZC0OYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZC0OYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:24:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46718 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZC0OYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:24:13 -0400
Date: Fri, 27 Mar 2009 10:24:01 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix __ucmpdi2 compile bug on 32 bit builds
Message-ID: <20090327142401.GA29999@bombadil.infradead.org>
References: <20090327134252.0f24773b@osiris.boeblingen.de.ibm.com> <20090328011626.5d6f94f4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090328011626.5d6f94f4.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 01:16:26AM +1100, Stephen Rothwell wrote:
> > -		switch (em->block_start) {
> > -		case EXTENT_MAP_LAST_BYTE:
> > +		if (em->block_start == EXTENT_MAP_LAST_BYTE) {
> 
> I might be a good idea to put a comment there about why this isn't a
> switch statement so that someone doesn't "clean up" this code in the
> future.
> 

nrrrgh. Remind me why we can't just add the libgcc helpers?

Unless we plan on growing some more of these, surely we can just reduce
it to a u32 for the switch...

regards, Kyle
