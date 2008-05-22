Return-Path: <linux-kernel-owner+w=401wt.eu-S933902AbYEVJzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933902AbYEVJzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 05:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbYEVJzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 05:55:22 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:57294 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933899AbYEVJzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 05:55:13 -0400
Message-ID: <48354394.9040205@keyaccess.nl>
Date: Thu, 22 May 2008 11:57:40 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       alsa-devel@alsa-project.org, perex@perex.cz
Subject: Re: Moving sound/* to drivers/ ?
References: <s5hzlqjz74d.wl%tiwai@suse.de>	<4834B252.1080700@garzik.org>	<4834B5E2.3040301@keyaccess.nl> <s5hy7623fqs.wl%tiwai@suse.de>
In-Reply-To: <s5hy7623fqs.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-05-08 10:27, Takashi Iwai wrote:

> At Thu, 22 May 2008 01:53:06 +0200,
> Rene Herman wrote:

>> Well, not _huge_ but ALSA is very much structured like that; large 
>> middle layer with "miniport" drivers (I do by the way expect this was 
>> also Takashi plan originally due to him using sound/* and not just 
>> "sound/"; that is, I took the * to be shorthand for isa, pci, usb and so on)
> 
> Well, no, I originally thought moving all $LINUX/sound to
> $LINUX/drivers/sound.

Oh okay, misinterpreted that.

>> This "net model" of sound/ and drivers/sound/ would be cleanest I feel.
> 
> I think it's a question of the balance.  The net stuff is huge, 10
> times more codes than the sound core.

Indeed, but then again, block/ is 3 times as small. Don't actually know 
what the rationale was for that one but I'd expect some of the same 
reasons for that split to apply here.

Yes, there's more non driver work under drivers already but this might 
be something to try to minimise. Drivers are really sort of special in 
their nicely defined and limited impact and statistics such as the 
percentage of updates that are in drivers are used in that way.

> An argument for keeping the sound core in /sound is that this is used
> not only by sound drivers but also by some video drivers.

Mm, right. In a sense the snd-pcsp thing might be an argument even. 
There really wants to be one driver for the PC speaker which doesn't 
want to live in (drivers/)sound/ due to it being generic hardware but 
which does want to use sound/ to pretend it is.

In that sense, the sound core is shared infrastructure...

Rene.
