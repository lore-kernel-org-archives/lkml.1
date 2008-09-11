Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbYIKXg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbYIKXg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 19:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbYIKXgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 19:36:18 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37435 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754502AbYIKXgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 19:36:17 -0400
X-Sasl-enc: p0qSb4FoXaVNEHZJon0evz0Vjj+juCYYx5KSx4YpGZT/ 1221176174
Date: Thu, 11 Sep 2008 20:36:07 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tejun Heo <tj@kernel.org>
Cc: Shem Multinymous <multinymous@gmail.com>,
       Elias Oltmanns <eo@nebensachen.de>, Thomas Renninger <trenn@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Laptop shock detection and harddisk protection
Message-ID: <20080911233607.GD18331@khazad-dum.debian.net>
References: <48C7FCEE.8060404@kernel.org> <41840b750809110908o54a61f55w7b1b9793abf55634@mail.gmail.com> <48C948A6.3080404@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C948A6.3080404@kernel.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008, Tejun Heo wrote:
> > Using the input device interface for the accelerometer (as done by
> > tp_smapi's hdaps + latest hdapsd) greatly reduces the number of
> > accelerometer-related timer interrupts on tickless kernels, as
> > measured by powertop. With syscall polling you have the kernal polling
> > the hardware at ~50Hz and then the userspace hdapsd polling the kernel
> > at ~50Hz. When they're out of phase so you can get up to 100
> > interrupts/sec. With an input device you're always at 50Hz. The phase
> > difference also induces a small extra delay in the shock handling
> > response.
> 
> That reduction comes because input device supports poll and
> sysfs_notify_event() does about the same thing.  The uesrland daemon
> can just poll on a node and read data nodes when poll event on the
> node triggeres.

If you guys are going to bother with the accelerometer interface (which is
a completely separate issue from the "queue-freeze-and-park-heads" APIs and
sysfs interface), you better be aware that there IS an accelerometer class
in the works, that cathers for directly-attached devices.

I'd look there first.  And a generic sysfs interface for accelerometers IS a
reasonably hard problem, so I would have it well separate from the disk-park
side of things and while it gets sorted out, I'd leave it for userspace to
deal with the issue (it is not like there is much userspace to worry about
right now, just hdapsd which is only interested on the hdaps accel
interface.  Everyone else can do it in-kernel, because their firmware
already does the imminent-fall detection).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
