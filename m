Return-Path: <linux-kernel-owner+w=401wt.eu-S964972AbXAWNKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964972AbXAWNKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 08:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964999AbXAWNKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 08:10:49 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:49637 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964972AbXAWNKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 08:10:48 -0500
X-Sasl-enc: o55rp2oIzhUo3TR/9PMYDla/mqir4Apo/3iOYXoGM1oP 1169557847
Date: Tue, 23 Jan 2007 11:10:40 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tejun Heo <htejun@gmail.com>
Cc: Soeren Sonnenburg <kernel@nn7.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: SATA hotplug from the user side ?
Message-ID: <20070123131040.GB13467@khazad-dum.debian.net>
References: <1168588629.5403.7.camel@localhost> <45A7BFB0.9090308@garzik.org> <1168639639.3707.6.camel@localhost> <45A83C22.6050409@gmail.com> <1168672966.3707.24.camel@localhost> <45AAE52B.2070705@gmail.com> <1169456682.2901.18.camel@localhost> <20070122210312.GD4516@khazad-dum.debian.net> <45B5A9C7.5050700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B5A9C7.5050700@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007, Tejun Heo wrote:
> Henrique de Moraes Holschuh wrote:
> > Does SATA electrical conector keying let the disk firmware unload
> > heads before the user manages to pull it out enough to sever power?
> 
> I don't think so.

Heh, thought as much. (Good) SCSI hotswap bays notice you pulled the disk
release lever and issue an START_STOP_UNIT by themselves to the disk well
before you have time to start pulling the disk out.  I wonder if the SATA
ones do (I kind of doubt that, SATA seems to attract the el-cheapo, el-crapo
crowd of manufacturers).

> > If it does not, the drive will do an emergency head unload, which is
> > not good and will likely reduce the drive's lifetime.
> 
> Probably.

So, that means it should be explained in the docs that you are to stop the
disk first, if you can.

> > Using hdparm -Y before the unplug, or scsiadd -r (on a kernel that
> > has Tejun's new patch to optionally issue an START_STOP_UNIT to the
> > SCSI device enabled) is probably a good idea.  Unless it is a shared
> > SATA port (I don't know if such a thing exists yet) and another box
> > is talking to the disk, etc.
> 
> Agreed.  But it would be *much* better if all these can be taken care of
> by hald and its minions.  Such that the user can just tell the system
> that the hdd is going to be removed and all these dirty tricks are done
> automagically.

Even if hald does this automatically, it would still be a very good idea to
document the proper sequence, IMO...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
