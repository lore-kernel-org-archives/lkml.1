Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbYE2SOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbYE2SOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756702AbYE2SOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:14:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52853 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756549AbYE2SOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:14:01 -0400
Message-ID: <483EF25F.7080005@garzik.org>
Date: Thu, 29 May 2008 14:13:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: RESEND: [PATCH] libata-sff: Fix oops reported in kerneloops.org
 for pnp devices with no ctl
References: <20080529161453.24735.805.stgit@core> <alpine.LFD.1.10.0805290950230.2958@woody.linux-foundation.org> <483EEBE5.5030708@garzik.org> <alpine.LFD.1.10.0805291102370.2958@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805291102370.2958@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 29 May 2008, Jeff Garzik wrote:
>>> It may be that you meant to make it an "else if" case, ie if there was no
>>> IO-read, then you do a ndelay(400) as a last desperate case, but that's not
>>> how your ata_sdd_sync() is actually written.
>> The double-ndelay is definitely wrong, but we do need one.  Technically it
>> should -only- be a 400ns delay, but we also have a register read in there to
>> make sure any posted writes are flushed.
> 
> Well, but the "read + delay" is already in ata_sdd_pause(). 

Right, that's what I meant by double-ndelay.


> So it's "ata_sdd_sync()" that I think is bogus. Based on its name alone, 
> it shouldn't have a delay in it (except, as mentioned, possibly for the 
> fallback case where no port can be used for reading).

Agreed,

	Jeff



