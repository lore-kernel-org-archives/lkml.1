Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbYBEQoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbYBEQoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbYBEQoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:44:00 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:49400 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405AbYBEQn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:43:59 -0500
Date: Wed, 6 Feb 2008 01:43:37 +0900
To: mangoo@wpkg.org
Cc: tomof@acm.org, James.Bottomley@HansenPartnership.com,
       bart.vanassche@gmail.com, vst@vlnb.net, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       scst-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stgt-devel@lists.berlios.de
Cc: fujita.tomonori@lab.ntt.co.jp
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <47A889AB.9090301@wpkg.org>
References: <47A80CB9.9000805@wpkg.org>
	<20080205223740L.tomof@acm.org>
	<47A889AB.9090301@wpkg.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080206014340X.tomof@acm.org>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Feb 2008 17:07:07 +0100
Tomasz Chmielewski <mangoo@wpkg.org> wrote:

> FUJITA Tomonori schrieb:
> > On Tue, 05 Feb 2008 08:14:01 +0100
> > Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> > 
> >> James Bottomley schrieb:
> >>
> >>> These are both features being independently worked on, are they not?
> >>> Even if they weren't, the combination of the size of SCST in kernel plus
> >>> the problem of having to find a migration path for the current STGT
> >>> users still looks to me to involve the greater amount of work.
> >> I don't want to be mean, but does anyone actually use STGT in
> >> production? Seriously?
> >>
> >> In the latest development version of STGT, it's only possible to stop
> >> the tgtd target daemon using KILL / 9 signal - which also means all
> >> iSCSI initiator connections are corrupted when tgtd target daemon is
> >> started again (kernel upgrade, target daemon upgrade, server reboot etc.).
> > 
> > I don't know what "iSCSI initiator connections are corrupted"
> > mean. But if you reboot a server, how can an iSCSI target
> > implementation keep iSCSI tcp connections?
> 
> The problem with tgtd is that you can't start it (configured) in an
> "atomic" way.
> Usually, one will start tgtd and it's configuration in a script (I 
> replaced some parameters with "..." to make it shorter and more readable):

Thanks for the details. So the way to stop the daemon is not related
with your problem.

It's easily fixable. Can you start a new thread about this on
stgt-devel mailing list? When we agree on the interface to start the
daemon, I'll implement it.


> tgtd
> tgtadm --op new ...
> tgtadm --lld iscsi --op new ...

(snip)

> So the only way to start/restart tgtd reliably is to do hacks which are 
> needed with yet another iSCSI kernel implementation (IET): use iptables.
> 
> iptables <block iSCSI traffic>
> tgtd
> sleep 1
> tgtadm --op new ...
> tgtadm --lld iscsi --op new ...
> iptables <unblock iSCSI traffic>
> 
> 
> A bit ugly, isn't it?
> Having to tinker with a firewall in order to start a daemon is by no 
> means a sign of a well-tested and mature project.
> 
> That's why I asked how many people use stgt in a production environment 
> - James was worried about a potential migration path for current users.

I don't know how many people use stgt in a production environment but
I'm not sure that this problem prevents many people from using it in a
production environment.

You want to reboot a server running target devices while initiators
connect to it. Rebooting the target server behind the initiators
seldom works. System adminstorators in my workplace reboot storage
devices once a year and tell us to shut down the initiator machines
that use them before that.
