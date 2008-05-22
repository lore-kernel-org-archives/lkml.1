Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbYEVPGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbYEVPGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 11:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYEVPFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 11:05:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752349AbYEVPFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 11:05:50 -0400
Date: Thu, 22 May 2008 08:04:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Engelhardt <jengelh@medozas.de>
cc: Takashi Iwai <tiwai@suse.de>, Rene Herman <rene.herman@keyaccess.nl>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org, perex@perex.cz
Subject: Re: Moving sound/* to drivers/ ?
In-Reply-To: <alpine.LNX.1.10.0805221052050.971@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LFD.1.10.0805220758000.3081@woody.linux-foundation.org>
References: <s5hzlqjz74d.wl%tiwai@suse.de> <4834B252.1080700@garzik.org> <4834B5E2.3040301@keyaccess.nl> <s5hy7623fqs.wl%tiwai@suse.de> <alpine.LNX.1.10.0805221052050.971@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 22 May 2008, Jan Engelhardt wrote:
> 
> I am in favor of keeping /sound around with the
> non-hardware-dependent code, much like /block does with regard to
> /drivers/block.

I'd personally *much* rather have just one subdirectory.

I realize that block/ and drivers/block/ (and net/ vs drivers/net/) has 
come up several times as an example that isn't that way, BUT:

 - that's actually the odd man out. It's more common to do it the other 
   way (and examples have already been given: drivers/usb/core, just plain 
   drivers/base, drivers/scsi/ (where it's all mixed up and a lot of 
   low-level drivers are in subdirectories of their own), etc etc.

 - perhaps more importantly, it's totally different from 'sound' in that 
   the block/ and drivers/block/ maintainership is actually *separate*.

   The same is actually true of net/ and drivers/net/ too. It so happens 
   that within the last few months, drivers/net/ gets merged through the 
   same maintainer as net/, but they really end up being maintained 
   separately other than that.

So the block/ and net/ layers have very much a higher level of separation 
from their drivers. sound has always been very much _maintained_ as a 
block, even if it then internally may be separate pieces. Partly this is 
from historical reasons, I'm sure, but it's true none-the-less.

So from an outside view, having a single subdirectory makes sense, because 
that's how it has always been maintained.

So I'd personally much rather see just one drivers/sound/ than have this 
split up.

		Linus
