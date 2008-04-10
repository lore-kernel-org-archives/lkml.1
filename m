Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbYDJDmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbYDJDmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 23:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbYDJDmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 23:42:05 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:41379 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754348AbYDJDmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 23:42:02 -0400
Date: Thu, 10 Apr 2008 12:41:58 +0900 (JST)
Message-Id: <20080410.124158.115958557.taka@valinux.co.jp>
To: gerlof@atcomputing.nl
Cc: menage@google.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       balbir@in.ibm.com, xemul@openvz.org
Subject: Re: [PATCH 1/3] accounting: task counters for disk/network
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <6599ad830804072316q441a1816o11f39ee7f9b49c0f@mail.gmail.com>
References: <20080408054837.GA7103@atcmpg.ATComputing.nl>
	<20080407231007.4946410d.akpm@linux-foundation.org>
	<6599ad830804072316q441a1816o11f39ee7f9b49c0f@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerlof,

> >  This sort of accounting will presumably be needed by a disk bandwidth
> >  cgroup controller.  Perhaps the containers/cgroup people have plans of code
> >  already?
> >
> 
> Yes, there have been various cgroup block-I/O subsystems proposed. I
> know that at least the one posted by Hirokazu Takahashi
> <taka@valinux.co.jp> uses the same per-page cgroup pointer as the
> memory controller.

Yes, I'm working on this.

linux-2.6.25-rc series now have the memory controller in them, which
supports to get the cgroup from any pageframe. I made a block-I/O
controller on it experimentally.

If you use this controller with dm-ioband, which is an engine implemented
as a device mapper module to control the bandwidth of block I/Os,
you can also get "cgroup block I/O accounting" from it.

I guess you can enhance this controller to track the I/Os per process
if you really want to. But it will cause extra overhead which I think
you may not ignore.

Thanks,
Hirokazu Takahashi.



