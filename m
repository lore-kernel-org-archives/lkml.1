Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbYANXig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbYANXig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 18:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbYANXi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 18:38:28 -0500
Received: from smtp.ono.com ([62.42.230.12]:64086 "EHLO resmaa06.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751319AbYANXi2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 18:38:28 -0500
Date: Tue, 15 Jan 2008 00:38:18 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Tejun Heo <htejun@gmail.com>,
       "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc7
Message-ID: <20080115003818.0bf10703@werewolf>
In-Reply-To: <478AA56F.9020506@gmail.com>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
	<20080108015012.2e518dd4@werewolf>
	<478429B2.2030002@gmail.com>
	<20080110102505.62097da1@werewolf>
	<47861930.7010708@gmail.com>
	<20080114001914.1e05fdb5@werewolf>
	<478AA56F.9020506@gmail.com>
X-Mailer: Claws Mail 3.2.0cvs34 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2008 08:57:35 +0900, Tejun Heo <htejun@gmail.com> wrote:

> J.A. Magallón wrote:
> > I'm still pending to pysically remove the disks (or at least unplug the
> > cable...), but I have realized a cusious thing: after some errors, the
> > kernel is lowering the disk speed (UDMA/133, then 100, then 33):
> 
> That's the standard error handling behavior.  Timeouts are likely to
> indicate transmission problems so libata puts it into slower gear.
> 
> > Perhaps this gives a clue.
> > Or I just had bad luck and 2 of my 4 disks broke at the same time.
> 
> As I said, the first thing I would try is to connect the drives to a
> separate PSU and re-seating cables as you're seeing problems on two
> drives simultaneously.
> 

I finally found the bad drive (the most obvious one as I would expect,
it was recycled from an older box...).
I tried removing completely the drive from power and controller, and then
running with it powered but not connected. No single error any more on
any of the other 3 drives. I have been updating my distro, rebuilding the
rpm database, moving big files between drives, even all at the same time.
No error.

I can't believe it, but a bad drive was causing timeouts on other drive
_on other controller_, the bad one was attached to the Promise and the
good ones on the ICH5 SATA (both integrated in motherboard).
Or there is a strange interaction in my board (Asus PC-DL), or there is
a nasty bug in the kernel...

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
