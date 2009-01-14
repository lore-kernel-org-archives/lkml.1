Return-Path: <linux-kernel-owner+w=401wt.eu-S1760979AbZANAeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979AbZANAeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756941AbZANAeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:34:09 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:53826 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbZANAeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:34:08 -0500
Date: Wed, 14 Jan 2009 00:33:23 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: David Miller <davem@davemloft.net>
cc: kosaki.motohiro@jp.fujitsu.com, Jesper.Nilsson@axis.com, tj@kernel.org,
       gregkh@suse.de, stern@rowland.harvard.edu, jens.axboe@oracle.com,
       hinko.kocevar@cetrtapot.si, linux-kernel@vger.kernel.org
Subject: Re: lib/klist.c: bit 0 in pointer can't be used as flag
In-Reply-To: <20090113.144521.97357573.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0901140026240.3808@blonde.anvils>
References: <20090113.131030.207355839.davem@davemloft.net>
 <20090113221235.GD19262@axis.com> <2f11576a0901131440w7fd3290uc9664aaf7aa89b08@mail.gmail.com>
 <20090113.144521.97357573.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009, David Miller wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Wed, 14 Jan 2009 07:40:19 +0900
> 
> > > It may be that we've worked around the other spots, although I haven't
> > > seen anything like that, we might just have been lucky until now.
> > >
> > > Can you recall another place where this trick is used?
> > 
> > rmap.
> > Don't CRIS use mmu?
> 
> I'm beginning to suspect the issue is only with objects
> in the kernel image itself.  Dynamically allocated memory
> is properly aligned and therefore the "low bit status bits
> in pointer" trick works.

Yes: I don't think we fully realized that when adding the
__attribute__((aligned(sizeof(long)))) to struct address_space
(so the PAGE_MAPPING_ANON bit didn't mess up on CRIS), but the
only instance which actually gave a problem was the peculiar
struct swapper_space declared in mm/swap_state.c.

Hugh
