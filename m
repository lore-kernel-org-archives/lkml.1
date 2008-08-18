Return-Path: <linux-kernel-owner+w=401wt.eu-S1757179AbYHRSm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbYHRSm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbYHRSms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:42:48 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49990 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbYHRSmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:42:47 -0400
Date: Mon, 18 Aug 2008 12:42:46 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Matt_Domsch@dell.com,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] ata: Add support for Long Logical Sectors and Long Physical Sectors
Message-ID: <20080818184246.GH677@parisc-linux.org>
References: <1217957207-23116-1-git-send-email-matthew@wil.cx> <1217957207-23116-3-git-send-email-matthew@wil.cx> <48A8B211.8030103@pobox.com> <20080818181523.GG677@parisc-linux.org> <20080818190629.22fd618c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818190629.22fd618c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 07:06:29PM +0100, Alan Cox wrote:
> > +	static const char command_sect_size[256] = {
> > +		[ ATA_CMD_CFA_TRANSLATE_SECTOR ] = DEVICE,
> 
> Should be a bit array so we can do a single fast test_bit()
> 
> > +	if (size == UNKNOWN && printk_ratelimit())
> > +		printk("Unknown ata cmd %d, assuming 512 byte sector size\n",
> > +				command);
> 
> or two bits ;)

;-)  How about two 256-bit arrays?

The first is set for "Use device sector size", the second is set for
"Yes, we know about this command, don't warn".  The most common commands
(reads and writes) will hit the first test and never try the second test.

> Rest looks ok. I'll probably send a follow up patch to make most pata
> drivers return "no" to anything but 512 until we can test them with real
> devices.

Why do we need to do that?  Leaving sector_size_supported() unset means
exactly "no to anything but 512".  I'll be quite surprised if we see
PATA drives supporting 4096 or 520 byte sectors anyway.  It seems like
a premium feature.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
