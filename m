Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbXISCcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbXISCcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 22:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbXISCcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 22:32:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41629 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbXISCcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 22:32:39 -0400
Date: Wed, 19 Sep 2007 08:05:32 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
cc: Jan Kara <jack@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: iso9660 vs udf
In-Reply-To: <20070919004657.GB11444@mette>
Message-ID: <alpine.LFD.0.999.0709190736140.28653@enigma.security.iitk.ac.in>
References: <20070915214926.GA31416@mette> <20070918144734.GB13304@atrey.karlin.mff.cuni.cz>
 <alpine.LFD.0.999.0709190534490.26241@enigma.security.iitk.ac.in>
 <20070919004657.GB11444@mette>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andries,


On Wed, 19 Sep 2007, Andries E. Brouwer wrote:
> 
> On Wed, Sep 19, 2007 at 05:48:28AM +0530, Satyam Sharma wrote:
> 
> > > > On the other hand, this filesystem announces itself as UDF
> > > > ("CD-RTOS" "CD-BRIDGE" "CDUDF File System - Adaptec Inc"),
> > > > perhaps the kernel code should be more robust.
> > 
> > Could you send the complete dmesg log, and what you mean with filesystem/
> > kernel (incorrectly?) announcing it as UDF here ... I agree with Jan,
> > this sounds like an issue with mount(8) to me.
> 
> You already got the relevant part of the dmesg log. Slightly more below.

> Failed mount:
> UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume 'Wisk1956-82', timestamp 2006/03/07 16:26 (1078)
> udf: udf_read_inode(ino 547) failed !bh
> UDF-fs: Error in udf_iget, block=1, partition=1

Ok, like said, this comes from udf_fill_super(), but which shouldn't
have been called for this CD in the first place -- i.e. mount(8) shouldn't
have tried to mount a non-UDF filesystem as UDF (unless explicitly asked
as such). I was actually asking for the logs explaining why you thought
the _kernel_ incorrectly "announced" it as an UDF filesystem.

Hmm ... those "CD-RTOS", "CD-BRIDGE" and "CDUDF File System - Adaptec Inc"
bits are not dmesg output, are they? Looks like "hwinfo --cdrom" or
"isoinfo" or some such.

> I think the filesystem can be treated both as iso9660 and as udf,
> at least that is what I seem to recall CD-BRIDGE means.  Thus,
> if the kernel cannot mount it as udf, I think it is a kernel flaw.
> Given that kernel flaw, and the fact that mounting as iso9660 works,
> mount(8) could work around the kernel problem by guessing iso9660.
> But maybe we should first try to fix the kernel.

I don't think that is what CD-BRIDGE means -- so no kernel flaw :-)
What happened here is simply that in the absence of a "-t" option,
mount(8) defaulted (probably due to incorrect heuristics?) to UDF for
some reason, thereby obviously failing. I don't know who maintains
mount(8) / util-linux package, or do distributions have their own
maintainers these days (?)


Satyam
