Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbYIAL2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbYIAL2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbYIAL2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:28:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:41537 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYIAL2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:28:04 -0400
Subject: Re: [PATCH] UBIFS: fill f_fsid
From: David Woodhouse <dwmw2@infradead.org>
To: dedekind@infradead.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
In-Reply-To: <1220267810.4036.24.camel@sauron>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
	 <1220194366-12731-13-git-send-email-dedekind@infradead.org>
	 <1220262187.2982.58.camel@pmac.infradead.org>
	 <1220267810.4036.24.camel@sauron>
Content-Type: text/plain
Date: Mon, 01 Sep 2008 12:28:00 +0100
Message-Id: <1220268480.2982.68.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-01 at 14:16 +0300, Artem Bityutskiy wrote:
> On Mon, 2008-09-01 at 10:43 +0100, David Woodhouse wrote:
> > > UBIFS stores 16-bit UUID in the superblock, and it is a good
> > > idea to return part of it in 'f_fsid' filed of kstatfs structure.
> > 
> > I think you mean a 16-byte UUID, not 16-bit?
> 
> Oh, right.
> 
> > 
> > > +	memcpy(&buf->f_fsid, c->uuid, sizeof(__kernel_fsid_t));
> > 
> > For btrfs I xor the first 64 bits with the second 64 bits, and put
> > _that_ into f_fsid. You're just putting the first 64 bits in and
> > ignoring the second 64 bits. Neither is really _better_ than the other;
> > you just alter the circumstances in which you get collisions. But I
> > suppose we might as well be consistent about how we do it?
> 
> Well, xor-ing should not make the random UUID more random, but for
> consistency purposes sure, I may use xor as well.
> 
> > Alternatively, there's space in the struct statfs to export a couple
> > more uint32_ts, and thus the _whole_ of the uuid. Perhaps we should do
> > that?
> 
> You mean f_spare? I do not think any application would use it so I doubt
> it is good idea to use it.

Well, it wouldn't be called f_spare any more, and applications would
know that it contains the rest of the UUID if it's non-zero.

I'd fix nfsd to fix it immediately (like as I just fixed nfsd to use the
first 64 bits of f_fsid when it's non-zero).

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



