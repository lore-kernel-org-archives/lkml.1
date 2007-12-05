Return-Path: <linux-kernel-owner+w=401wt.eu-S1751519AbXLEGH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbXLEGH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 01:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbXLEGHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 01:07:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49259
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750993AbXLEGHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 01:07:45 -0500
Date: Tue, 04 Dec 2007 22:07:44 -0800 (PST)
Message-Id: <20071204.220744.166144729.davem@davemloft.net>
To: greearb@candelatech.com
Cc: ebiederm@xmission.com, kaber@trash.net, shemminger@linux-foundation.org,
       lkml@rtr.ca, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: namespace support requires network modules to say "GPL"
From: David Miller <davem@davemloft.net>
In-Reply-To: <4755A2FD.9020608@candelatech.com>
References: <47544896.7070101@candelatech.com>
	<m18x4axrx2.fsf@ebiederm.dsl.xmission.com>
	<4755A2FD.9020608@candelatech.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>
Date: Tue, 04 Dec 2007 10:57:01 -0800

> echo add_my_bridge my_br1 eth0 namespaceX eth1 namespaceY > 
> /proc/net/foo/config

Each process executes in a namespace, so specifying the namespace
is redundant, just fetch the current process's namespace to pass
into the dev_get_by_*() routines.

Anyone interested in using a different namespace's devices
can change the namespace the process is executing in before
the procfs echo.
