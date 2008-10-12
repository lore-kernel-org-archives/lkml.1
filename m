Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbYJLOfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbYJLOfb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 10:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbYJLOfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 10:35:22 -0400
Received: from lazybastard.de ([212.112.238.170]:39414 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbYJLOfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 10:35:22 -0400
Date: Sun, 12 Oct 2008 16:35:10 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Chris Snook <csnook@redhat.com>
Cc: Stefan Monnier <monnier@iro.umontreal.ca>, linux-kernel@vger.kernel.org
Subject: Re: Filesystem for block devices using flash storage?
Message-ID: <20081012143505.GA15799@logfs.org>
References: <jwvvdw33v5p.fsf-monnier+gmane.linux.kernel@gnu.org> <48ED1D62.8080100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48ED1D62.8080100@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 October 2008 16:51:46 -0400, Chris Snook wrote:
> Stefan Monnier wrote:
> 
> Writes to magnetic disks are functionally atomic at the sector level.  With 
> SSDs, writing requires an erase followed by rewriting the sectors that 
> aren't changing.  This means that an ill-timed power loss can corrupt an 
> entire erase block, which could be up to 256k on some MLC flash.  Unless 

What makes you think that?  The standard mode of operation in El Cheapo
devices is to write to a new eraseblock first, then delete the old one.
An ill-timed power loss results in either the old or the new block being
valid as a whole.  This has been the standard ever since you could buy
4MB compactflash cards. 

> logfs tries to solve the write amplification problem by forcing all write 
> activity to be sequential.  I'm not sure how mature it is.

Still under development.  What exactly do you mean by the write
amplification problem?

> >Or is there some hope for SSDs to provide access to the MTD layer in the
> >not too distant future?
> 
> I hope not.  The proper fix is to have the devices report their physical 
> topology via SCSI/ATA commands.  This allows dumb software to function 
> correctly, albeit inefficiently, and allows smart software to optimize 
> itself. This technique also helps with RAID arrays, large-sector disks, etc.

Having access to the actual flash would provide a large number of
benefits.  It just isn't a safe default choice at the moment.

> I suspect that in the long run, the problem will go away.  Erase blocks are 
> a relic of the days when flash was used primarily for low-power, 
> read-mostly applications.  As the SSD market heats up, the flash vendors 
> will move to smaller erase blocks, possibly as small as the sector size.  

Do you have any information to back this claim?  AFAICT smaller erase
blocks would require more chip area per bit, making devices more
expensive.  If anything, I can see a trend towards bigger erase blocks.

Jörn

-- 
ticks = jiffies;
while (ticks == jiffies);
ticks = jiffies;
-- /usr/src/linux/init/main.c
