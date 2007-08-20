Return-Path: <linux-kernel-owner+w=401wt.eu-S1751960AbXHTRts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbXHTRts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 13:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbXHTRtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 13:49:39 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:41845 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbXHTRti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 13:49:38 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: John Stoffel <john@stoffel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Laurent Vivier <Laurent.Vivier@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       virtualization <virtualization@lists.linux-foundation.org>
From: laurent.vivier@bull.net
Subject: =?iso-8859-1?Q?R=E9f=2E_=3A_Re=3A_[PATCH_0=2F4]_Virtual_Machine_Time?=
 Accounting
Date: Mon, 20 Aug 2007 19:54:52 +0200
Message-ID: <OF945F7B1F.FF4B4672-ONC125733D.006266E7-C125733D.00626843@frec.bull.fr>
X-MIMETrack: Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/08/2007 19:54:53
MIME-Version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Laurent Vivier wrote:
> functionnalities:
>
> > - allow to measure time spent by a CPU in a virtual CPU.
> > - allow to display in /proc/state this value by CPU
> > - allow to display in /proc/<pid>/state this value by process
> > - allow KVM to use these 3 previous functionnalities
> >
>
> So, currently time spent in a kvm guest is accumulated as qemu-kvm
> usertime, right?  Given that qemu knows when its running in qemu vs

No, it is accumulated as kvm system time.

> guest context, couldn't it provide the breakdown between user and guest
> time (ditto lguest)?

by doing this at kernel level, we can:
- measure exactly the guest time,
- move this part of system time to user time (as you think it should be
user time),
- have consistency between system, user and guest time,
- report values in /proc/state and /proc/<pid>/state, at system wide level

I'm not sure we can measure the guest time at the qemu user level.

Perhaps Rusty can say what he thinks about this ?

Regards,
Laurent


