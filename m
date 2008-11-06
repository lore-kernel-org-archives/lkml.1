Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbYKFQd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbYKFQd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 11:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751115AbYKFQdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 11:33:16 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:58272 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYKFQdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 11:33:15 -0500
Date: Thu, 6 Nov 2008 22:02:28 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Peter Staubach <staubach@redhat.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH]: ext4: fix big endian
Message-ID: <20081106163228.GF25194@skywalker>
References: <200811061600.54264.borntraeger@de.ibm.com> <200811061651.49602.borntraeger@de.ibm.com> <49131601.50407@redhat.com> <200811061715.53593.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811061715.53593.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 05:15:53PM +0100, Christian Borntraeger wrote:
> Am Donnerstag, 6. November 2008 schrieb Peter Staubach:
> > >  	/* We allocate both existing and potentially added groups */
> > >  	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
> > > -			    ((sbi->s_es->s_reserved_gdt_blocks +1 ) <<
> > > +			    (le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks + 1) <<
> > >   
> > 
> > I suspect that you want to do the le16_to_cpu() and _then_
> > add the 1.  Otherwise, adding 1 to a different byte order
> > value won't do quite what is expected or hoped for...
> 
> errm. Right.
> Something like this maybe?
> 
> [PATCH]: ext4: fix big endian access for flex groups
> 
> On big endianess plattforms newly created ext4 file systems cannot be mounted
> and show messages like:
> [6923911.715968] EXT4-fs: not enough memory for 522250 flex groups
> [6923911.715973] EXT4-fs: unable to initialize flex_bg meta info!
> 
> We have to access s_reserved_gdb_blocks with le16_to_cpu.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

There is already a patch in the patchqueue that fix this
http://repo.or.cz/w/ext4-patch-queue.git?a=blob;f=convert-to-host-order-in-ext4_fill_flex_info;h=ebe7efb3ee78b6cab4db49391f4a005d78a26f03;hb=HEAD


-aneesh
