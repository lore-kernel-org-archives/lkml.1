Return-Path: <linux-kernel-owner+w=401wt.eu-S1758724AbYCNS30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724AbYCNS30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 14:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758012AbYCNS3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 14:29:08 -0400
Received: from postel.suug.ch ([194.88.212.233]:54245 "EHLO postel.suug.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757911AbYCNS3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 14:29:07 -0400
Date: Fri, 14 Mar 2008 19:29:27 +0100
From: Thomas Graf <tgraf@suug.ch>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: Audit vs netlink interaction problem
Message-ID: <20080314182927.GQ20815@postel.suug.ch>
References: <47DAA660.90401@openvz.org> <20080314163929.GP20815@postel.suug.ch> <47DAB065.6060804@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DAB065.6060804@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Emelyanov <xemul@openvz.org> 2008-03-14 20:05
> Hmmm... I'm afraid, that this can break the audit filtering and signal
> auditing. I haven't yet looked deep into it, but it compares the 
> task->tgid with this audit_pid for different purposes. If audit_pid
> changes this code will be broken.

OK, then both pids have to be stored. audit_pid remains as-is but is
no longer used as destination netlink pid. A second pid is stored and
updated whenever a netlink message is received from userspace.

> Bu we have no the netlink socket at the moment of setting the pid to
> check this. The audit_reveive_msg() call which does this set is received 
> via another (pre-created global) socket.

I don't understand this. As far as I can read the code, a plain kernel
side netlink socket is created in audit_init(). But it doesn't matter,
as soon as we receive the first message from userspace, we know the
netlink source pid.

> I though, that proper behavior would be to split audit_pid, used for
> filtering from the audit_nlk_pid used for netlink communications.

Yes, exactly.
