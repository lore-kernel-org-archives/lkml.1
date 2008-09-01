Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbYIACIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbYIACIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 22:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbYIACIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 22:08:31 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41710 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752054AbYIACIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 22:08:30 -0400
X-Sasl-enc: BOdRDOzJQvqb5OBYmn25NoKHdje8+mErlRdnh6LO3tYh 1220234906
Date: Sun, 31 Aug 2008 23:08:21 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] libata: Implement disk shock protection support
Message-ID: <20080901020821.GA12532@khazad-dum.debian.net>
References: <87wshzplvk.fsf@denkblock.local> <87ej45mlp3.fsf@denkblock.local> <48BA969C.4060207@gmail.com> <200808311632.04584.bzolnier@gmail.com> <87wshxkt9c.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wshxkt9c.fsf@denkblock.local>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Aug 2008, Elias Oltmanns wrote:
> Admittedly, I don't know very much about it myself but I seem to
> remember that there are other vendors now shipping similar technology.

Apple, HP.

> Even in the Thinkpad case I don't *know* that all relevant models have
> HD and optical drives on seperate ports although I'm willing to believe
> it if somebody tells me so.

All the models I know of have them on separate ports/channels.

> Anyway, I've added Henrique to the Cc: list since he knows far more
> about Thinkpads than I do and possibly about other notebooks too.

I know Apple does it, and they need exactly the same queue freeze + ATA
unload immediate to have APS working.  But they will want both a kernel
interface (just using the firmware) and the userspace interface (to use
something better than whatever is in Apple's firmware).

> There is a lot to be said for the per-port solution as far as libata is
> concerned. For the sake of consistency I tried to mimic the same
> behaviour in ide but I agree that it makes things more complex there.

Frankly?  I doubt anybody really cares about the old ide driver for this
particular functionality.

How many systems have an accelerometer, are portable enough to need APS, and
have a SATA or PATA bridge that is not better driven by libata instead of
ide?

> > Which also brings again the question whether it is really the best to
> > use user-space solution instead of kernel thread?

Choice is good here.  A really good imminent-shock predictor needs to do
some fairly decent ammount of digital signal processing (in 2d or 3d,
depending on the sensor).  That stuff is a lot easier to do if you have
floating point math available to you, for example.  That means userspace.

And some firmware can tell you "please do APS NOW!", so, for those you want
a kernel interface.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
