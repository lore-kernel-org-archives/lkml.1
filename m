Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbYIAL2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbYIAL2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbYIAL2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:28:25 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52043 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758662AbYIAL2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:28:24 -0400
X-Sasl-enc: Wi6VPH37Wz9oCG+yYpoNgsmomUz/upWB+SwPZI/at744 1220268502
Date: Mon, 1 Sep 2008 08:28:16 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tomas Carnecky <tom@dbservice.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Steven King <sfking@fdwdc.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       ibm-acpi-devel@lists.sourceforge.net
Subject: Re: 2.6.26.[1-3] + x61 tablet + x6ultrabase: no resume after
	undocking
Message-ID: <20080901112816.GA21970@khazad-dum.debian.net>
References: <200808301535.22419.sfking@fdwdc.com> <1220239048.24775.152.camel@rzhang-dt> <48BBC8FC.1020809@dbservice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BBC8FC.1020809@dbservice.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Sep 2008, Tomas Carnecky wrote:
> There is one question though that was never answered: Is there any
> interaction needed from the userspace when docking/undocking? Something

Yes.  umount filesystems on any device in the dock, and issue the "power off
dock" command (i.e. tell the kernel to *eject* the dock).  This is *very*
important, although the ThinkPad firmware/hardware will _try_ to protect the
electronics if you just pull the laptop off the dock while it is still
powered (but it might just not be able to do it, so Don't Do That!).

Anyway, if your dock led is going off before you remove the laptop from the
dock, you're doing everything correctly as far as the hardware is concerned.

And the kernel will scream bloody murder if you remove a device with live
filesystems in it, so it should be trivial to check if that part is being
taken care of by your userspace as well.  Not that something like this would
be an excuse to fail to suspend/resume after being undocked, mind you.

> That behavior is consistent with my earlier experience, that is: If the
> notebook was _ever_ running in the docking station, it won't resume
> outside of it. No matter whether I start it outside the dock and then
> put it into the dock, or start it up in the dock - once the notebook has
> been docked, suspend/resume outside of the dock won't work anymore.
> My wild uneducated guess is that the kernel doesn't remove/disable some
> devices when undocking (the bay device?) and when it tries to resume
> without them present it will hang.

Your uneducated guess might well be right, there are a lot of patches for
dock that are not in mainline yet.  You clearly are experiencing some sort
of Linux bug, that much is pretty clear to me.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
