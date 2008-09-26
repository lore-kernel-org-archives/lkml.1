Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbYIZUCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbYIZUCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 16:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbYIZUCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 16:02:34 -0400
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:44229 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbYIZUCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 16:02:33 -0400
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Sep 2008 16:02:32 EDT
Date: Fri, 26 Sep 2008 22:55:24 +0300 (EEST)
From: Kai Makisara <Kai.Makisara@kolumbus.fi>
X-X-Sender: makisara@kai.makisara.local
To: Lin Tan <tammy000@gmail.com>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH git latest] drivers/scsi: fixing wrong comment before
 new_buffer_tape()
In-Reply-To: <20080926170624.GA19223@carmen.cs.uiuc.edu>
Message-ID: <alpine.LNX.1.10.0809262234520.25887@kai.makisara.local>
References: <20080925174948.GA14180@carmen.cs.uiuc.edu> <20080926111300.1dd34009@lxorguk.ukuu.org.uk> <7fcc02550809260905oa17880fi80c94eaacb33dba3@mail.gmail.com> <20080926170937.2983fc29@lxorguk.ukuu.org.uk> <1222446056.3971.19.camel@localhost.localdomain>
 <20080926170624.GA19223@carmen.cs.uiuc.edu>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am talking only about st.c but most of this probably applies also to 
osst.c.

On Fri, 26 Sep 2008, Lin Tan wrote:

> > > > > Looks true to me for the current versions of the code. In fact it is only
> > > > > ever called from the initialisation function that I can see so chunks of
> > > > > the code could simply go away as well as bits of the comment. Ditto the

It is true that the function is currently called only from initialisation. 
It was called from other contexts earlier and the extra code is leftover 
from that time.

> > > > > one in drivers/scsi/st.c
> > > > >
> > > > > Acked-by: Alan Cox <alan@redhat.com>
> > > > >
> > > > 
> > > > I am sorry I didn't quite understand. You mean it is true that caller
> > > > must hold os_scsi_tapes_lock?
> > > 
> > > Sorry - I mean what you claim is true - that the comment is incorrect.
> > 
> > So, I think I'm missing a piece of this:  There's no patch in this
> > thread (I presume it's lurking somewhere on lkml).  Could someone repost
> > the proposed patch and copy the tape maintainer: Kai Makisara
> > <Kai.Makisara@kolumbus.fi> to get his input?
> > 
I saw the patch but my mail client does not include attachments as text in 
reply ;-(

Anyway, the comment is there because new_tape_buffer() may sleep and 
st_dev_arr_lock is a spinlock. I have been under the impression that code 
inside a spinlock must not sleep.

When called from initialisation, new_tape_buffer() _currently_ used 
GFP_ATOMIC. I am not sure that this is necessary but as long as I don't 
know, I don't want to change it. The comment protects callers even if 
someone knows that it is safe to use GFP_KERNEL from initialisation.

I don't see why new_tape_buffer() needs to be inside the lock. It just 
allocates an initialises a structure.

If someone wants to remove the comment from st.c, I don't mind. But please 
make sure that what you write to the commit is correct.

Kai

