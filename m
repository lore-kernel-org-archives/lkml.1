Return-Path: <linux-kernel-owner+w=401wt.eu-S1752371AbYKWWxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbYKWWxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 17:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750887AbYKWWxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 17:53:09 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49205 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbYKWWxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 17:53:08 -0500
Subject: Re: about TRIM/DISCARD support and barriers
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Tejun Heo <teheo@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Dongjun Shin <djshin90@gmail.com>,
       chris.mason@oracle.com
In-Reply-To: <1227447584.4901.405.camel@macbook.infradead.org>
References: <4928E010.4090801@kernel.org> <4929023C.2060302@suse.de>
	 <20081123123514.GI5707@parisc-linux.org>
	 <1227447584.4901.405.camel@macbook.infradead.org>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 07:52:56 +0900
Message-Id: <1227480776.25499.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-11-23 at 13:39 +0000, David Woodhouse wrote:
> > We don't attempt to put non-contiguous ranges into a single TRIM yet.
> 
> We don't even merge contiguous ranges -- I still need to fix the
> elevators to stop writes crossing writes,

I don't think we want to do that ... it's legal if the write isn't a
barrier and it will inhibit merging.  That may be just fine for a SSD,
but it's not for spinning media since they get better performance out of
merged writes.

>  before we can stop discards
> from also being barriers. (Discards are just writes, for the purpose of
> that conversation).

Perhaps they shouldn't be ... they have different characteristics.  For
instance, a discard may cross a read or write that has no sectors in
common with it; a discard may be merged as a non contiguous range
(assuming the drive supports multiple ranges), etc.

I think it might be better to give it its own type for the elevators.

James


