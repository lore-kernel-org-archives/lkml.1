Return-Path: <linux-kernel-owner+w=401wt.eu-S1757110AbYE2SEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbYE2SEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbYE2SEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:04:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752498AbYE2SEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:04:21 -0400
Date: Thu, 29 May 2008 11:04:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: RESEND: [PATCH] libata-sff: Fix oops reported in kerneloops.org
 for pnp devices with no ctl
In-Reply-To: <483EEBE5.5030708@garzik.org>
Message-ID: <alpine.LFD.1.10.0805291102370.2958@woody.linux-foundation.org>
References: <20080529161453.24735.805.stgit@core> <alpine.LFD.1.10.0805290950230.2958@woody.linux-foundation.org> <483EEBE5.5030708@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 May 2008, Jeff Garzik wrote:
> > 
> > It may be that you meant to make it an "else if" case, ie if there was no
> > IO-read, then you do a ndelay(400) as a last desperate case, but that's not
> > how your ata_sdd_sync() is actually written.
> 
> The double-ndelay is definitely wrong, but we do need one.  Technically it
> should -only- be a 400ns delay, but we also have a register read in there to
> make sure any posted writes are flushed.

Well, but the "read + delay" is already in ata_sdd_pause(). 

So it's "ata_sdd_sync()" that I think is bogus. Based on its name alone, 
it shouldn't have a delay in it (except, as mentioned, possibly for the 
fallback case where no port can be used for reading).

		Linus
