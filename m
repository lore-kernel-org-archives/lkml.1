Return-Path: <linux-kernel-owner+w=401wt.eu-S1759472AbZC0Oii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbZC0Oii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758927AbZC0OiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:38:16 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:39505 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758687AbZC0OiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:38:15 -0400
Subject: Re: [PATCH] btrfs: fix __ucmpdi2 compile bug on 32 bit builds
From: Chris Mason <chris.mason@oracle.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20090327142401.GA29999@bombadil.infradead.org>
References: <20090327134252.0f24773b@osiris.boeblingen.de.ibm.com>
	 <20090328011626.5d6f94f4.sfr@canb.auug.org.au>
	 <20090327142401.GA29999@bombadil.infradead.org>
Content-Type: text/plain
Date: Fri, 27 Mar 2009 10:37:44 -0400
Message-Id: <1238164664.27455.8.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.49CCE4BC.0166:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 10:24 -0400, Kyle McMartin wrote:
> On Sat, Mar 28, 2009 at 01:16:26AM +1100, Stephen Rothwell wrote:
> > > -		switch (em->block_start) {
> > > -		case EXTENT_MAP_LAST_BYTE:
> > > +		if (em->block_start == EXTENT_MAP_LAST_BYTE) {
> > 
> > I might be a good idea to put a comment there about why this isn't a
> > switch statement so that someone doesn't "clean up" this code in the
> > future.
> > 
> 
> nrrrgh. Remind me why we can't just add the libgcc helpers?
>
> Unless we plan on growing some more of these, surely we can just reduce
> it to a u32 for the switch...

EXTENT_MAP_LAST_BYTE is something like (u64)-5

This if/else setup is fine, I'll take the patch.

-chris


