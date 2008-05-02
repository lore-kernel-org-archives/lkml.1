Return-Path: <linux-kernel-owner+w=401wt.eu-S937508AbYEBXWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937508AbYEBXWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936982AbYEBXVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:21:49 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:42902 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937548AbYEBXVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:21:47 -0400
From: Roland Dreier <rdreier@cisco.com>
To: "Moore\, Eric" <Eric.Moore@lsi.com>
Cc: "David Miller" <davem@davemloft.net>, <linux-scsi@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: HELP: Is writeq an atomic operation??
References: <0631C836DBF79F42B5A60C8C8D4E822901047B4A@NAMAIL2.ad.lsil.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 02 May 2008 16:21:46 -0700
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E822901047B4A@NAMAIL2.ad.lsil.com>
	(Eric Moore's message of "Fri, 2 May 2008 17:13:08 -0600")
Message-ID: <adaod7o2sxh.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 May 2008 23:21:47.0088 (UTC) FILETIME=[4A976500:01C8ACAB]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Yeah,  I forgot I have a #ifndef writeq, then defined the x86_64 version
 > of that.   I've not tested on x86, so I'm not sure whether it works.
 > How are you handling writeq when its not defined, as the case in x86?

Write two writel() inside a spinlock to avoid any transactions in the
middle (the HW I'm dealing with can deal with two 32-bit transactions,
as long as nothing comes in the middle).  If your hardware demands a
single 64-bit transaction, you may be in trouble, because I'm not sure
all 32-bit systems can generate such a PCIe transaction.

You can see include/linux/mlx4/doorbell.h for exactly what I did.

 - R.
