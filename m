Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbYFXKmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbYFXKmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 06:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbYFXKmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 06:42:31 -0400
Received: from sh.osrg.net ([192.16.179.4]:53502 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbYFXKma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 06:42:30 -0400
Date: Tue, 24 Jun 2008 19:41:42 +0900
To: stern@rowland.harvard.edu
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org,
       antonio.lin@alcormicro.com, david.vrabel@csr.com
Subject: Re: Scatter-gather list constraints
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <Pine.LNX.4.44L0.0806211727330.24335-100000@netrider.rowland.org>
References: <485D1C67.7050907@firstfloor.org>
	<Pine.LNX.4.44L0.0806211727330.24335-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080624194119H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jun 2008 17:50:13 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> > >> I don't think the block layer knows about such kinds of restrictions.
> > > 
> > > Evidently not.  Is it feasible to add such knowledge to the block
> > > layer?
> > 
> > You would need to ask Jens, but I would assume he would ask:
> > - Is it common?
> 
> This is the only situation I know about.  But of course it will become 
> more and more common as wireless USB devices spread into use.
> 
> > - Is it performance critical?
> 
> For people using wireless USB drives, yes.
> 
> > and presumably the answer to both would be "no" ?
> 
> In theory this could be fixed at the host controller level, by making 
> packets span S-G elements.  But this would be a very large and 
> difficult change.  Altering the block layer should be a lot easier (he 
> said, secure in his blind ignorance).  For example, the DMA alignment 
> restriction could be made to apply to the _end_ of each S-G element as 
> well as the _beginning_, except for the last element in the list.

I don't think that the block layer has the DMA alignment concept in FS
I/O path. And I think that you need kinda the DMA padding instead the
DMA alignment though again The block layer doesn't have the DMA
padding concept in FS I/O path. And the DMA padding applies to only
the last SG element.

I guess that it's pretty hard to implement such a strange restriction
in the block layer cleanly.

The iSER driver has a strange restriction too. I think that as iSER
does, bouncing is a better option, though adding some generic
mechanism to reserve buffer in the block layer might be nice, I
gueess.
